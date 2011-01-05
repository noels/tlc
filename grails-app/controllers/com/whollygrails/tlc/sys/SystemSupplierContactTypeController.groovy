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

class SystemSupplierContactTypeController {

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
        [systemSupplierContactTypeInstanceList: SystemSupplierContactType.selectList(), systemSupplierContactTypeInstanceTotal: SystemSupplierContactType.selectCount()]
    }

    def show = {
        def systemSupplierContactTypeInstance = SystemSupplierContactType.get(params.id)
        if (!systemSupplierContactTypeInstance) {
            flash.message = 'systemSupplierContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Supplier Contact Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemSupplierContactTypeInstance: systemSupplierContactTypeInstance]
        }
    }

    def delete = {
        def systemSupplierContactTypeInstance = SystemSupplierContactType.get(params.id)
        if (systemSupplierContactTypeInstance) {
            try {
                utilService.deleteWithMessages(systemSupplierContactTypeInstance, [prefix: 'supplierContactType.name', code: systemSupplierContactTypeInstance.code])
                flash.message = 'systemSupplierContactType.deleted'
                flash.args = [systemSupplierContactTypeInstance.toString()]
                flash.defaultMessage = "Supplier Contact Type ${systemSupplierContactTypeInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemSupplierContactType.not.deleted'
                flash.args = [systemSupplierContactTypeInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Supplier Contact Type ${systemSupplierContactTypeInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemSupplierContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Supplier Contact Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemSupplierContactTypeInstance = SystemSupplierContactType.get(params.id)
        if (!systemSupplierContactTypeInstance) {
            flash.message = 'systemSupplierContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Supplier Contact Type not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemSupplierContactTypeInstance: systemSupplierContactTypeInstance]
        }
    }

    def update = {
        def systemSupplierContactTypeInstance = SystemSupplierContactType.get(params.id)
        if (systemSupplierContactTypeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemSupplierContactTypeInstance.version > version) {
                    systemSupplierContactTypeInstance.errors.rejectValue('version', 'systemSupplierContactType.optimistic.locking.failure', 'Another user has updated this Supplier Contact Type while you were editing')
                    render(view: 'edit', model: [systemSupplierContactTypeInstance: systemSupplierContactTypeInstance])
                    return
                }
            }

            def oldCode = systemSupplierContactTypeInstance.code
            systemSupplierContactTypeInstance.properties['code', 'name'] = params
            if (utilService.saveWithMessages(systemSupplierContactTypeInstance, [prefix: 'supplierContactType.name', code: systemSupplierContactTypeInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemSupplierContactType.updated'
                flash.args = [systemSupplierContactTypeInstance.toString()]
                flash.defaultMessage = "Supplier Contact Type ${systemSupplierContactTypeInstance.toString()} updated"
                redirect(action: show, id: systemSupplierContactTypeInstance.id)
            } else {
                render(view: 'edit', model: [systemSupplierContactTypeInstance: systemSupplierContactTypeInstance])
            }
        } else {
            flash.message = 'systemSupplierContactType.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Supplier Contact Type not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemSupplierContactTypeInstance = new SystemSupplierContactType()
        return [systemSupplierContactTypeInstance: systemSupplierContactTypeInstance]
    }

    def save = {
        def systemSupplierContactTypeInstance = new SystemSupplierContactType()
        systemSupplierContactTypeInstance.properties['code', 'name'] = params
        if (utilService.saveWithMessages(systemSupplierContactTypeInstance, [prefix: 'supplierContactType.name', code: systemSupplierContactTypeInstance.code, field: 'name'])) {
            flash.message = 'systemSupplierContactType.created'
            flash.args = [systemSupplierContactTypeInstance.toString()]
            flash.defaultMessage = "Supplier Contact Type ${systemSupplierContactTypeInstance.toString()} created"
            redirect(action: show, id: systemSupplierContactTypeInstance.id)
        } else {
            render(view: 'create', model: [systemSupplierContactTypeInstance: systemSupplierContactTypeInstance])
        }
    }
}