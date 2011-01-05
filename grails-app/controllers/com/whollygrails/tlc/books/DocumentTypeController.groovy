/*
 *  Copyright 2010 Wholly Grails.
 *
 *  This file is part of the Three Ledger Core (TLC) software
 *  from Wholly Grails.
 *
 *  TLC is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  TLC is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with TLC.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.whollygrails.tlc.books

class DocumentTypeController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'name', 'nextSequenceNumber', 'autoGenerate', 'allowEdit'].contains(params.sort) ? params.sort : 'code'
        [documentTypeInstanceList: DocumentType.selectList(company: utilService.currentCompany()), documentTypeInstanceTotal: DocumentType.selectCount()]
    }

    def show = {
        def documentTypeInstance = DocumentType.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!documentTypeInstance) {
            flash.message = 'documentType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Document Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [documentTypeInstance: documentTypeInstance]
        }
    }

    def delete = {
        def documentTypeInstance = DocumentType.findByIdAndCompany(params.id, utilService.currentCompany())
        if (documentTypeInstance) {
            try {
                documentTypeInstance.delete(flush: true)
                flash.message = 'documentType.deleted'
                flash.args = [documentTypeInstance.toString()]
                flash.defaultMessage = "Document Type ${documentTypeInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'documentType.not.deleted'
                flash.args = [documentTypeInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Document Type ${documentTypeInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'documentType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Document Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def documentTypeInstance = DocumentType.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!documentTypeInstance) {
            flash.message = 'documentType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Document Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            def bankAccountList
            if (documentTypeInstance.type.code == 'BP') {
                bankAccountList = Account.findAll("from Account as x where x.securityCode = ? and x.active = ? and x.type.code = 'bank' order by x.name",
                        [utilService.currentCompany().securityCode, true])
            }

            return [documentTypeInstance: documentTypeInstance, bankAccountList: bankAccountList]
        }
    }

    def update = {
        def documentTypeInstance = DocumentType.findByIdAndCompany(params.id, utilService.currentCompany())
        if (documentTypeInstance) {
            def bankAccountList
            if (documentTypeInstance.type.code == 'BP') {
                bankAccountList = Account.findAll("from Account as x where x.securityCode = ? and x.active = ? and x.type.code = 'bank' order by x.name",
                        [utilService.currentCompany().securityCode, true])
            }

            if (params.version) {
                def version = params.version.toLong()
                if (documentTypeInstance.version > version) {
                    documentTypeInstance.errors.rejectValue('version', 'documentType.optimistic.locking.failure', 'Another user has updated this Document Type while you were editing')
                    render(view: 'edit', model: [documentTypeInstance: documentTypeInstance, bankAccountList: bankAccountList])
                    return
                }
            }

            def oldBank = documentTypeInstance.autoBankAccount
            def oldFlag = documentTypeInstance.autoForeignCurrency
            def oldBankDetails = documentTypeInstance.autoBankDetails
            documentTypeInstance.properties['code', 'name', 'nextSequenceNumber', 'autoGenerate', 'allowEdit', 'autoBankAccount', 'autoForeignCurrency', 'autoMaxPayees', 'autoBankDetails'] = params
            utilService.verify(documentTypeInstance, ['autoBankAccount'])             // Ensure correct references
            def valid = (!documentTypeInstance.hasErrors() && documentTypeInstance.validate())

            // If it's no longer an auto-payment type
            if (valid && oldBank && !documentTypeInstance.autoBankAccount && Supplier.countByDocumentType(documentTypeInstance)) {
                documentTypeInstance.errorMessage(field: 'autoBankAccount', code: 'documentType.auto.suppliers',
                        default: 'You cannot remove the auto-payment specification when their are suppliers that use this document type for their auto-payments')
                valid = false
            }

            // If they've changed the auto-payment currencies allowed
            if (valid && oldBank && documentTypeInstance.autoBankAccount && !documentTypeInstance.autoForeignCurrency &&
                    (oldFlag || oldBank.currency.id != documentTypeInstance.autoBankAccount.currency.id) &&
                    Supplier.countByDocumentTypeAndCurrencyNotEqual(documentTypeInstance, documentTypeInstance.autoBankAccount.currency)) {
                if (oldFlag) {
                    documentTypeInstance.errorMessage(field: 'autoForeignCurrency', code: 'documentType.auto.flag',
                            default: 'The change of the foreign currency flag would invalidate suppliers using this document type for their auto-payments')
                } else {
                    documentTypeInstance.errorMessage(field: 'autoBankAccount', code: 'documentType.auto.bank',
                            default: 'The change of bank currency would invalidate suppliers using this document type for their auto-payments')
                }

                valid = false
            }

            // If they have changed to requiring bank details
            if (valid && !oldBankDetails && documentTypeInstance.autoBankDetails) {
                def count = Supplier.executeQuery('from Supplier where documentType = ? and (bankSortCode is null or bankAccountName is null or bankAccountNumber is null)', [documentTypeInstance])[0]
                if (count) {
                    documentTypeInstance.errorMessage(field: 'autoBankDetails', code: 'documentType.details.flag',
                            default: 'The change to requiring bank details would invalidate suppliers using this document type for their auto-payments')
                    valid = false
                }
            }

            if (valid && documentTypeInstance.saveThis()) {
                flash.message = 'documentType.updated'
                flash.args = [documentTypeInstance.toString()]
                flash.defaultMessage = "Document Type ${documentTypeInstance.toString()} updated"
                redirect(action: show, id: documentTypeInstance.id)
            } else {
                render(view: 'edit', model: [documentTypeInstance: documentTypeInstance, bankAccountList: bankAccountList])
            }
        } else {
            flash.message = 'documentType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Document Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def documentTypeInstance = new DocumentType()
        documentTypeInstance.company = utilService.currentCompany()   // Ensure correct company
        def bankAccountList = Account.findAll("from Account as x where x.securityCode = ? and x.active = ? and x.type.code = 'bank' order by x.name",
                [utilService.currentCompany().securityCode, true])
        return [documentTypeInstance: documentTypeInstance, bankAccountList: bankAccountList]
    }

    def save = {
        def documentTypeInstance = new DocumentType()
        documentTypeInstance.properties['code', 'name', 'nextSequenceNumber', 'type', 'autoGenerate', 'allowEdit', 'autoBankAccount', 'autoForeignCurrency', 'autoMaxPayees', 'autoBankDetails'] = params
        documentTypeInstance.company = utilService.currentCompany()   // Ensure correct company
        utilService.verify(documentTypeInstance, ['autoBankAccount'])             // Ensure correct references
        if (!documentTypeInstance.hasErrors() && documentTypeInstance.saveThis()) {
            flash.message = 'documentType.created'
            flash.args = [documentTypeInstance.toString()]
            flash.defaultMessage = "Document Type ${documentTypeInstance.toString()} created"
            redirect(action: show, id: documentTypeInstance.id)
        } else {
            def bankAccountList = Account.findAll("from Account as x where x.securityCode = ? and x.active = ? and x.type.code = 'bank' order by x.name",
                    [utilService.currentCompany().securityCode, true])
            render(view: 'create', model: [documentTypeInstance: documentTypeInstance, bankAccountList: bankAccountList])
        }
    }
}