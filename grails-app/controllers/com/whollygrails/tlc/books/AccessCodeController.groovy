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

class AccessCodeController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'name'].contains(params.sort) ? params.sort : 'code'
        [accessCodeInstanceList: AccessCode.selectList(company: utilService.currentCompany()), accessCodeInstanceTotal: AccessCode.selectCount()]
    }

    def show = {
        def accessCodeInstance = AccessCode.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!accessCodeInstance) {
            flash.message = 'accessCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Access Code not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [accessCodeInstance: accessCodeInstance]
        }
    }

    def delete = {
        def accessCodeInstance = AccessCode.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (accessCodeInstance) {
            try {
                accessCodeInstance.delete(flush: true)
                flash.message = 'accessCode.deleted'
                flash.args = [accessCodeInstance.toString()]
                flash.defaultMessage = "Access Code ${accessCodeInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'accessCode.not.deleted'
                flash.args = [accessCodeInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Access Code ${accessCodeInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'accessCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Access Code not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def accessCodeInstance = AccessCode.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!accessCodeInstance) {
            flash.message = 'accessCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Access Code not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [accessCodeInstance: accessCodeInstance]
        }
    }

    def update = {
        def accessCodeInstance = AccessCode.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (accessCodeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (accessCodeInstance.version > version) {
                    accessCodeInstance.errors.rejectValue('version', 'accessCode.optimistic.locking.failure', 'Another user has updated this Access Code while you were editing')
                    render(view: 'edit', model: [accessCodeInstance: accessCodeInstance])
                    return
                }
            }

            accessCodeInstance.properties['code', 'name'] = params
            if (!accessCodeInstance.hasErrors() && accessCodeInstance.saveThis()) {
                flash.message = 'accessCode.updated'
                flash.args = [accessCodeInstance.toString()]
                flash.defaultMessage = "Access Code ${accessCodeInstance.toString()} updated"
                redirect(action: show, id: accessCodeInstance.id)
            } else {
                render(view: 'edit', model: [accessCodeInstance: accessCodeInstance])
            }
        } else {
            flash.message = 'accessCode.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Access Code not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def accessCodeInstance = new AccessCode()
        accessCodeInstance.company = utilService.currentCompany()   // Ensure correct company
        return [accessCodeInstance: accessCodeInstance]
    }

    def save = {
        def accessCodeInstance = new AccessCode()
        accessCodeInstance.properties['code', 'name'] = params
        accessCodeInstance.company = utilService.currentCompany()   // Ensure correct company
        if (!accessCodeInstance.hasErrors() && accessCodeInstance.saveThis()) {
            flash.message = 'accessCode.created'
            flash.args = [accessCodeInstance.toString()]
            flash.defaultMessage = "Access Code ${accessCodeInstance.toString()} created"
            redirect(action: show, id: accessCodeInstance.id)
        } else {
            render(view: 'create', model: [accessCodeInstance: accessCodeInstance])
        }
    }
}