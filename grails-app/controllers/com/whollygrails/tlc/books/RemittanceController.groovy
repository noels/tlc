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

import com.whollygrails.tlc.corp.ExchangeCurrency

class RemittanceController {

    // Injected services
    def utilService
    def bookService

    // Security settings
    def activities = [default: 'apremit']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', authorize: 'POST', authorizeAll: 'POST', releasing: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        def multipage = false
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.offset = params.offset ? params.offset.toLong() : 0L

        // Note that the list and count calls below are inherently limited to the current
        // company since the list of accessCode objects is company (and user) specific
        def remittanceInstanceList, remittanceInstanceTotal
        def accessList = bookService.supplierAccessCodes()
        if (accessList) {
            def where
            for (item in accessList) {
                if (where) {
                    where = where + ',?'
                } else {
                    where = '?'
                }
            }

            remittanceInstanceList = Remittance.findAll('from Remittance as x where x.authorizedDate is null and x.supplier.accessCode in (' + where + ') order by x.supplier.code',
                    accessList, [max: params.max, offset: params.offset])
            remittanceInstanceTotal = Remittance.executeQuery('select count(*) from Remittance as x where x.authorizedDate is null and x.supplier.accessCode in (' + where + ')', accessList)[0]

            def val
            for (remittance in remittanceInstanceList) {
                val = Remittance.executeQuery('select sum(accountUnallocated) from RemittanceLine where remittance = ?', remittance)[0]
                if (val) remittance.accountValue = -val
            }

            multipage = ((remittanceInstanceTotal / params.max) > 1)
        } else {
            remittanceInstanceList = []
            remittanceInstanceTotal = 0L
        }

        [remittanceInstanceList: remittanceInstanceList, remittanceInstanceTotal: remittanceInstanceTotal, multipage: multipage]
    }

    def show = {
        def remittanceInstance = Remittance.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!remittanceInstance || remittanceInstance.authorizedDate || !bookService.hasSupplierAccess(remittanceInstance.supplier)) {
            flash.message = 'remittance.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Remittance Advice not found with id ${params.id}"
            redirect(action: list)
        } else {
            def val = Remittance.executeQuery('select sum(accountUnallocated) from RemittanceLine where remittance = ?', remittanceInstance)[0]
            if (val) remittanceInstance.accountValue = -val
            return [remittanceInstance: remittanceInstance]
        }
    }

    def delete = {
        def remittanceInstance = Remittance.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode, [lock: true])
        if (remittanceInstance && !remittanceInstance.authorizedDate && bookService.hasSupplierAccess(remittanceInstance.supplier)) {
            try {
                remittanceInstance.delete(flush: true)
                flash.message = 'remittance.deleted'
                flash.args = [remittanceInstance.supplier.code]
                flash.defaultMessage = "Remittance Advice for Supplier ${remittanceInstance.supplier.code} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'remittance.not.deleted'
                flash.args = [remittanceInstance.supplier.code, e.class.simpleName]
                flash.defaultMessage = "Remittance Advice for Supplier ${remittanceInstance.supplier.code} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'remittance.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Remittance Advice not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        [supplierInstance: new Supplier()]
    }

    def save = {
        def supplierInstance = Supplier.findByCompanyAndCode(utilService.currentCompany(), bookService.fixSupplierCase(params.code))
        if (supplierInstance && bookService.hasSupplierAccess(supplierInstance)) {
            def result = bookService.autoPayService.createRemittanceAdvice(supplierInstance.id, false, utilService.fixDate())
            if (result && result instanceof String) {
                flash.message = result
                render(view: 'create', model: [supplierInstance: supplierInstance])
                return
            }

            if (!result) {
                flash.message = 'supplier.nothing.due'
                flash.args = [supplierInstance.code]
                flash.defaultMessage = "No payment is required for supplier ${supplierInstance.code}"
                render(view: 'create', model: [supplierInstance: supplierInstance])
                return
            }
        } else {
            supplierInstance = new Supplier(code: params.code)
            supplierInstance.errorMessage(field: 'code', code: 'document.supplier.invalid', default: 'Invalid supplier')
            render(view: 'create', model: [supplierInstance: supplierInstance])
            return
        }

        flash.message = 'remittance.created'
        flash.args = [supplierInstance.code]
        flash.defaultMessage = "Remittance Advice created for Supplier ${supplierInstance.code}"
        redirect(action: list)
    }

    def authorize = {
        def remittanceInstance = Remittance.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode, [lock: true])
        if (remittanceInstance && !remittanceInstance.authorizedDate && bookService.hasSupplierAccess(remittanceInstance.supplier)) {
            remittanceInstance.authorizedDate = utilService.fixDate()
            if (remittanceInstance.save(flush: true)) {
                flash.message = 'remittance.authorized'
                flash.args = [remittanceInstance.supplier.code]
                flash.defaultMessage = "Remittance Advice for supplier ${remittanceInstance.supplier.code} authorized"
            } else {
                flash.message = 'remittance.not.authorized'
                flash.args = [remittanceInstance.supplier.code]
                flash.defaultMessage = "Unable to authorize Remittance Advice for Supplier ${remittanceInstance.supplier.code}"
            }
        } else {
            flash.message = 'remittance.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Remittance Advice not found with id ${params.id}"
        }

        redirect(action: list)
    }

    def authorizeAll = {

        def count = 0
        def valid = true

        // Note that the list below is inherently limited to the current company
        // since the list of accessCode objects is company (and user) specific
        def accessList = bookService.supplierAccessCodes()
        if (accessList) {
            def where
            for (item in accessList) {
                if (where) {
                    where = where + ',?'
                } else {
                    where = '?'
                }
            }

            def today = utilService.fixDate()
            Remittance.withTransaction {status ->
                def remittanceInstanceList = Remittance.findAll('from Remittance as x where x.authorizedDate is null and x.supplier.accessCode in (' + where + ') order by id', accessList, [lock: true])
                for (remittance in remittanceInstanceList) {
                    remittance.authorizedDate = today
                    if (remittance.saveThis()) {
                        count++
                    } else {
                        flash.message = 'remittance.authorized.error'
                        flash.defaultMessage = 'Error authorizing the Remittance Advices'
                        status.setRollbackOnly()
                        valid = false
                        break
                    }
                }
            }
        }

        if (valid) {
            flash.message = 'remittance.authorized.all'
            flash.args = ["${count}"]
            flash.defaultMessage = "${count} Remittance Advice(s) authorized"
        }

        redirect(action: list)
    }

    def release = {
        def supplierInstance = new Supplier()
        def sql = 'select dt.autoBankAccount.id, s.currency.id, sum(rl.accountUnallocated)' +
                ' from Remittance as r, Supplier as s, DocumentType as dt, RemittanceLine as rl' +
                ' where r.authorizedDate is not null' +
                ' and r.paymentDate is null' +
                ' and r.supplier = s' +
                ' and s.company = ?' +
                ' and s.documentType = dt' +
                ' and rl.remittance = r' +
                ' group by dt.autoBankAccount.id, s.currency.id'
        def advices = Remittance.executeQuery(sql, utilService.currentCompany())
        def summaries = []
        for (advice in advices) summaries << new PaymentBlock(advice[0], advice[1], advice[2])
        summaries.sort {it.bankCode + ' ' + it.currencyCode}
        return [supplierInstance: supplierInstance, summaries: summaries]
    }

    def releasing = {
        def valid = true
        def supplierInstance = new Supplier()
        def batchSize = params.taxId
        supplierInstance.taxId = batchSize
        if (batchSize != null && batchSize != '' && (!batchSize.isInteger() || batchSize.toInteger() <= 0 || batchSize.toInteger() > 99999)) {
            supplierInstance.errorMessage(field: 'taxId', code: 'remittance.batchSize.bad', default: 'Invalid Batch Size')
            valid = false
        }

        def result
        if (valid) {
            if (batchSize) params.p_batchSize = batchSize
            result = utilService.demandRunFromParams('release', params)
            if (result instanceof String) {
                supplierInstance.errors.reject(null, result)
                valid = false
            }
        }

        if (valid) {
            flash.message = 'queuedTask.demand.good'
            flash.args = [result]
            flash.defaultMessage = "The task has been placed in the queue for execution as task number ${result}"
            redirect(controller: 'systemMenu', action: 'display')
        } else {
            def sql = 'select dt.autoBankAccount.id, s.currency.id, sum(rl.accountUnallocated)' +
                    ' from Remittance as r, Supplier as s, DocumentType as dt, RemittanceLine as rl' +
                    ' where r.authorizedDate is not null' +
                    ' and r.paymentDate is null' +
                    ' and r.supplier = s' +
                    ' and s.company = ?' +
                    ' and s.documentType = dt' +
                    ' and rl.remittance = r' +
                    ' group by dt.autoBankAccount.id, s.currency.id'
            def advices = Remittance.executeQuery(sql, utilService.currentCompany())
            def summaries = []
            for (advice in advices) summaries << new PaymentBlock(advice[0], advice[1], advice[2])
            summaries.sort {it.bankCode + ' ' + it.currencyCode}
            render(view: 'release', model: [supplierInstance: supplierInstance, summaries: summaries])
        }
    }

    def print = {
        def result = utilService.demandRunFromParams('advices', params)
        if (result instanceof String) {
            flash.message = result
        } else {
            flash.message = 'queuedTask.demand.good'
            flash.args = [result]
            flash.defaultMessage = "The task has been placed in the queue for execution as task number ${result}"
        }

        redirect(action: 'list')
    }
}

class PaymentBlock {
    def bankCode
    def bankName
    def currencyCode
    def currencyDecimals
    def accountValue

    PaymentBlock(bankId, currencyId, value) {
        def obj = Account.get(bankId)
        bankCode = obj.code
        bankName = obj.name
        obj = ExchangeCurrency.get(currencyId)
        currencyCode = obj.code
        currencyDecimals = obj.decimals
        accountValue = -value
    }
}