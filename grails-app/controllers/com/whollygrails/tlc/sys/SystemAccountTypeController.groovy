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

class SystemAccountTypeController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'sectionType', 'singleton', 'changeable', 'allowInvoices', 'allowCash', 'allowProvisions', 'allowJournals'].contains(params.sort) ? params.sort : 'code'
        [systemAccountTypeInstanceList: SystemAccountType.selectList(), systemAccountTypeInstanceTotal: SystemAccountType.selectCount()]
    }

    def show = {
        def systemAccountTypeInstance = SystemAccountType.get(params.id)
        if (!systemAccountTypeInstance) {
            flash.message = 'systemAccountType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Account Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemAccountTypeInstance: systemAccountTypeInstance]
        }
    }

    def delete = {
        def systemAccountTypeInstance = SystemAccountType.get(params.id)
        if (systemAccountTypeInstance) {
            try {
                utilService.deleteWithMessages(systemAccountTypeInstance, [prefix: 'systemAccountType.name', code: systemAccountTypeInstance.code])
                flash.message = 'systemAccountType.deleted'
                flash.args = [systemAccountTypeInstance.toString()]
                flash.defaultMessage = "System Account Type ${systemAccountTypeInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemAccountType.not.deleted'
                flash.args = [systemAccountTypeInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Account Type ${systemAccountTypeInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemAccountType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Account Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemAccountTypeInstance = SystemAccountType.get(params.id)
        if (!systemAccountTypeInstance) {
            flash.message = 'systemAccountType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Account Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemAccountTypeInstance: systemAccountTypeInstance]
        }
    }

    def update = {
        def systemAccountTypeInstance = SystemAccountType.get(params.id)
        if (systemAccountTypeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemAccountTypeInstance.version > version) {
                    systemAccountTypeInstance.errors.rejectValue('version', 'systemAccountType.optimistic.locking.failure', 'Another user has updated this System Account Type while you were editing')
                    render(view: 'edit', model: [systemAccountTypeInstance: systemAccountTypeInstance])
                    return
                }
            }

            def oldCode = systemAccountTypeInstance.code
            systemAccountTypeInstance.properties['code', 'name', 'sectionType', 'singleton', 'changeable', 'allowInvoices', 'allowCash', 'allowProvisions', 'allowJournals'] = params
            if (utilService.saveWithMessages(systemAccountTypeInstance, [prefix: 'systemAccountType.name', code: systemAccountTypeInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemAccountType.updated'
                flash.args = [systemAccountTypeInstance.toString()]
                flash.defaultMessage = "System Account Type ${systemAccountTypeInstance.toString()} updated"
                redirect(action: show, id: systemAccountTypeInstance.id)
            } else {
                render(view: 'edit', model: [systemAccountTypeInstance: systemAccountTypeInstance])
            }
        } else {
            flash.message = 'systemAccountType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Account Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemAccountTypeInstance = new SystemAccountType()
        return [systemAccountTypeInstance: systemAccountTypeInstance]
    }

    def save = {
        def systemAccountTypeInstance = new SystemAccountType()
        systemAccountTypeInstance.properties['code', 'name', 'sectionType', 'singleton', 'changeable', 'allowInvoices', 'allowCash', 'allowProvisions', 'allowJournals'] = params
        if (utilService.saveWithMessages(systemAccountTypeInstance, [prefix: 'systemAccountType.name', code: systemAccountTypeInstance.code, field: 'name'])) {
            flash.message = 'systemAccountType.created'
            flash.args = [systemAccountTypeInstance.toString()]
            flash.defaultMessage = "System Account Type ${systemAccountTypeInstance.toString()} created"
            redirect(action: show, id: systemAccountTypeInstance.id)
        } else {
            render(view: 'create', model: [systemAccountTypeInstance: systemAccountTypeInstance])
        }
    }
}