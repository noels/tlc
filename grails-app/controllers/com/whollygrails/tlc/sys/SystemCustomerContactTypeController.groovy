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
package com.whollygrails.tlc.sys

class SystemCustomerContactTypeController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = 'code'
        [systemCustomerContactTypeInstanceList: SystemCustomerContactType.selectList(), systemCustomerContactTypeInstanceTotal: SystemCustomerContactType.selectCount()]
    }

    def show = {
        def systemCustomerContactTypeInstance = SystemCustomerContactType.get(params.id)
        if (!systemCustomerContactTypeInstance) {
            flash.message = 'systemCustomerContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemCustomerContactTypeInstance: systemCustomerContactTypeInstance]
        }
    }

    def delete = {
        def systemCustomerContactTypeInstance = SystemCustomerContactType.get(params.id)
        if (systemCustomerContactTypeInstance) {
            try {
                utilService.deleteWithMessages(systemCustomerContactTypeInstance, [prefix: 'customerContactType.name', code: systemCustomerContactTypeInstance.code])
                flash.message = 'systemCustomerContactType.deleted'
                flash.args = [systemCustomerContactTypeInstance.toString()]
                flash.defaultMessage = "Customer Contact Type ${systemCustomerContactTypeInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemCustomerContactType.not.deleted'
                flash.args = [systemCustomerContactTypeInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Customer Contact Type ${systemCustomerContactTypeInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemCustomerContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemCustomerContactTypeInstance = SystemCustomerContactType.get(params.id)
        if (!systemCustomerContactTypeInstance) {
            flash.message = 'systemCustomerContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemCustomerContactTypeInstance: systemCustomerContactTypeInstance]
        }
    }

    def update = {
        def systemCustomerContactTypeInstance = SystemCustomerContactType.get(params.id)
        if (systemCustomerContactTypeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemCustomerContactTypeInstance.version > version) {
                    systemCustomerContactTypeInstance.errors.rejectValue('version', 'systemCustomerContactType.optimistic.locking.failure', 'Another user has updated this Customer Contact Type while you were editing')
                    render(view: 'edit', model: [systemCustomerContactTypeInstance: systemCustomerContactTypeInstance])
                    return
                }
            }

            def oldCode = systemCustomerContactTypeInstance.code
            systemCustomerContactTypeInstance.properties['code', 'name'] = params
            if (utilService.saveWithMessages(systemCustomerContactTypeInstance, [prefix: 'customerContactType.name', code: systemCustomerContactTypeInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemCustomerContactType.updated'
                flash.args = [systemCustomerContactTypeInstance.toString()]
                flash.defaultMessage = "Customer Contact Type ${systemCustomerContactTypeInstance.toString()} updated"
                redirect(action: show, id: systemCustomerContactTypeInstance.id)
            } else {
                render(view: 'edit', model: [systemCustomerContactTypeInstance: systemCustomerContactTypeInstance])
            }
        } else {
            flash.message = 'systemCustomerContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemCustomerContactTypeInstance = new SystemCustomerContactType()
        return [systemCustomerContactTypeInstance: systemCustomerContactTypeInstance]
    }

    def save = {
        def systemCustomerContactTypeInstance = new SystemCustomerContactType()
        systemCustomerContactTypeInstance.properties['code', 'name'] = params
        if (utilService.saveWithMessages(systemCustomerContactTypeInstance, [prefix: 'customerContactType.name', code: systemCustomerContactTypeInstance.code, field: 'name'])) {
            flash.message = 'systemCustomerContactType.created'
            flash.args = [systemCustomerContactTypeInstance.toString()]
            flash.defaultMessage = "Customer Contact Type ${systemCustomerContactTypeInstance.toString()} created"
            redirect(action: show, id: systemCustomerContactTypeInstance.id)
        } else {
            render(view: 'create', model: [systemCustomerContactTypeInstance: systemCustomerContactTypeInstance])
        }
    }
}