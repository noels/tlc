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

class TaxAuthorityController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['name', 'usage'].contains(params.sort) ? params.sort : 'name'
        [taxAuthorityInstanceList: TaxAuthority.selectList(company: utilService.currentCompany()), taxAuthorityInstanceTotal: TaxAuthority.selectCount()]
    }

    def show = {
        def taxAuthorityInstance = TaxAuthority.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!taxAuthorityInstance) {
            flash.message = 'taxAuthority.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Authority not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [taxAuthorityInstance: taxAuthorityInstance]
        }
    }

    def delete = {
        def taxAuthorityInstance = TaxAuthority.findByIdAndCompany(params.id, utilService.currentCompany())
        if (taxAuthorityInstance) {
            try {
                taxAuthorityInstance.delete(flush: true)
                flash.message = 'taxAuthority.deleted'
                flash.args = [taxAuthorityInstance.toString()]
                flash.defaultMessage = "Tax Authority ${taxAuthorityInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'taxAuthority.not.deleted'
                flash.args = [taxAuthorityInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Tax Authority ${taxAuthorityInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'taxAuthority.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Authority not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def taxAuthorityInstance = TaxAuthority.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!taxAuthorityInstance) {
            flash.message = 'taxAuthority.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Authority not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [taxAuthorityInstance: taxAuthorityInstance]
        }
    }

    def update = {
        def taxAuthorityInstance = TaxAuthority.findByIdAndCompany(params.id, utilService.currentCompany())
        if (taxAuthorityInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (taxAuthorityInstance.version > version) {
                    taxAuthorityInstance.errors.rejectValue('version', 'taxAuthority.optimistic.locking.failure', 'Another user has updated this Tax Authority while you were editing')
                    render(view: 'edit', model: [taxAuthorityInstance: taxAuthorityInstance])
                    return
                }
            }

            taxAuthorityInstance.properties['name', 'usage'] = params
            if (!taxAuthorityInstance.hasErrors() && taxAuthorityInstance.saveThis()) {
                flash.message = 'taxAuthority.updated'
                flash.args = [taxAuthorityInstance.toString()]
                flash.defaultMessage = "Tax Authority ${taxAuthorityInstance.toString()} updated"
                redirect(action: show, id: taxAuthorityInstance.id)
            } else {
                render(view: 'edit', model: [taxAuthorityInstance: taxAuthorityInstance])
            }
        } else {
            flash.message = 'taxAuthority.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Tax Authority not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def taxAuthorityInstance = new TaxAuthority()
        taxAuthorityInstance.company = utilService.currentCompany()   // Ensure correct company
        return [taxAuthorityInstance: taxAuthorityInstance]
    }

    def save = {
        def taxAuthorityInstance = new TaxAuthority()
        taxAuthorityInstance.properties['name', 'usage'] = params
        taxAuthorityInstance.company = utilService.currentCompany()   // Ensure correct company
        if (!taxAuthorityInstance.hasErrors() && taxAuthorityInstance.saveThis()) {
            flash.message = 'taxAuthority.created'
            flash.args = [taxAuthorityInstance.toString()]
            flash.defaultMessage = "Tax Authority ${taxAuthorityInstance.toString()} created"
            redirect(action: show, id: taxAuthorityInstance.id)
        } else {
            render(view: 'create', model: [taxAuthorityInstance: taxAuthorityInstance])
        }
    }
}