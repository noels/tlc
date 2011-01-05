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

class SystemMeasureController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code'].contains(params.sort) ? params.sort : 'code'
        [systemMeasureInstanceList: SystemMeasure.selectList(), systemMeasureInstanceTotal: SystemMeasure.selectCount()]
    }

    def show = {
        def systemMeasureInstance = SystemMeasure.get(params.id)
        if (!systemMeasureInstance) {
            flash.message = 'systemMeasure.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Measure not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemMeasureInstance: systemMeasureInstance]
        }
    }

    def delete = {
        def systemMeasureInstance = SystemMeasure.get(params.id)
        if (systemMeasureInstance) {
            try {
                utilService.deleteWithMessages(systemMeasureInstance, [prefix: 'measure.name', code: systemMeasureInstance.code])
                flash.message = 'systemMeasure.deleted'
                flash.args = [systemMeasureInstance.toString()]
                flash.defaultMessage = "System Measure ${systemMeasureInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemMeasure.not.deleted'
                flash.args = [systemMeasureInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Measure ${systemMeasureInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemMeasure.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Measure not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemMeasureInstance = SystemMeasure.get(params.id)
        if (!systemMeasureInstance) {
            flash.message = 'systemMeasure.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Measure not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemMeasureInstance: systemMeasureInstance]
        }
    }

    def update = {
        def systemMeasureInstance = SystemMeasure.get(params.id)
        if (systemMeasureInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemMeasureInstance.version > version) {
                    systemMeasureInstance.errors.rejectValue('version', 'systemMeasure.optimistic.locking.failure', 'Another user has updated this System Measure while you were editing')
                    render(view: 'edit', model: [systemMeasureInstance: systemMeasureInstance])
                    return
                }
            }

            def oldCode = systemMeasureInstance.code
            systemMeasureInstance.properties['code', 'name'] = params
            if (utilService.saveWithMessages(systemMeasureInstance, [prefix: 'measure.name', code: systemMeasureInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemMeasure.updated'
                flash.args = [systemMeasureInstance.toString()]
                flash.defaultMessage = "System Measure ${systemMeasureInstance.toString()} updated"
                redirect(action: show, id: systemMeasureInstance.id)
            } else {
                render(view: 'edit', model: [systemMeasureInstance: systemMeasureInstance])
            }
        } else {
            flash.message = 'systemMeasure.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Measure not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        return [systemMeasureInstance: new SystemMeasure()]
    }

    def save = {
        def systemMeasureInstance = new SystemMeasure()
        systemMeasureInstance.properties['code', 'name'] = params
        if (utilService.saveWithMessages(systemMeasureInstance, [prefix: 'measure.name', code: systemMeasureInstance.code, field: 'name'])) {
            flash.message = 'systemMeasure.created'
            flash.args = [systemMeasureInstance.toString()]
            flash.defaultMessage = "System Measure ${systemMeasureInstance.toString()} created"
            redirect(action: show, id: systemMeasureInstance.id)
        } else {
            render(view: 'create', model: [systemMeasureInstance: systemMeasureInstance])
        }
    }
}