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
package com.whollygrails.tlc.corp

class TaxCodeController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code'].contains(params.sort) ? params.sort : 'code'
        [taxCodeInstanceList: TaxCode.selectList(company: utilService.currentCompany()), taxCodeInstanceTotal: TaxCode.selectCount()]
    }

    def show = {
        def taxCodeInstance = TaxCode.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!taxCodeInstance) {
            flash.message = 'taxCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Code not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [taxCodeInstance: taxCodeInstance]
        }
    }

    def delete = {
        def taxCodeInstance = TaxCode.findByIdAndCompany(params.id, utilService.currentCompany())
        if (taxCodeInstance) {
            if (taxCodeInstance.companyTaxCode) {
                flash.message = 'taxCode.corp.delete'
                flash.defaultMessage = 'The company tax code cannot be deleted'
                redirect(action: show, id: params.id)
            } else {
                try {
                    utilService.deleteWithMessages(taxCodeInstance, [prefix: 'taxCode.name', code: taxCodeInstance.code])
                    flash.message = 'taxCode.deleted'
                    flash.args = [taxCodeInstance.toString()]
                    flash.defaultMessage = "Tax Code ${taxCodeInstance.toString()} deleted"
                    redirect(action: list)
                } catch (Exception e) {
                    flash.message = 'taxCode.not.deleted'
                    flash.args = [taxCodeInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Tax Code ${taxCodeInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            }
        } else {
            flash.message = 'taxCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Code not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def taxCodeInstance = TaxCode.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!taxCodeInstance) {
            flash.message = 'taxCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Code not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [taxCodeInstance: taxCodeInstance]
        }
    }

    def update = {
        def taxCodeInstance = TaxCode.findByIdAndCompany(params.id, utilService.currentCompany())
        if (taxCodeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (taxCodeInstance.version > version) {
                    taxCodeInstance.errors.rejectValue('version', 'taxCode.optimistic.locking.failure', 'Another user has updated this Tax Code while you were editing')
                    render(view: 'edit', model: [taxCodeInstance: taxCodeInstance])
                    return
                }
            }

            def oldCode = taxCodeInstance.code
            taxCodeInstance.properties['code', 'name', 'authority'] = params
            utilService.verify(taxCodeInstance, ['authority'])             // Ensure correct references
            if (utilService.saveWithMessages(taxCodeInstance, [prefix: 'taxCode.name', code: taxCodeInstance.code, field: 'name', oldCode: oldCode])) {
                flash.message = 'taxCode.updated'
                flash.args = [taxCodeInstance.toString()]
                flash.defaultMessage = "Tax Code ${taxCodeInstance.toString()} updated"
                redirect(action: show, id: taxCodeInstance.id)
            } else {
                render(view: 'edit', model: [taxCodeInstance: taxCodeInstance])
            }
        } else {
            flash.message = 'taxCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Code not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def taxCodeInstance = new TaxCode()
        taxCodeInstance.company = utilService.currentCompany()
        return [taxCodeInstance: taxCodeInstance]
    }

    def save = {
        def taxCodeInstance = new TaxCode()
        taxCodeInstance.properties['code', 'name', 'authority'] = params
        taxCodeInstance.company = utilService.currentCompany()
        utilService.verify(taxCodeInstance, ['authority'])             // Ensure correct references
        if (utilService.saveWithMessages(taxCodeInstance, [prefix: 'taxCode.name', code: taxCodeInstance.code, field: 'name'])) {
            flash.message = 'taxCode.created'
            flash.args = [taxCodeInstance.toString()]
            flash.defaultMessage = "Tax Code ${taxCodeInstance.toString()} created"
            redirect(action: show, id: taxCodeInstance.id)
        } else {
            render(view: 'create', model: [taxCodeInstance: taxCodeInstance])
        }
    }
}