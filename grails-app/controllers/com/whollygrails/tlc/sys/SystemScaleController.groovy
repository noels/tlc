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

class SystemScaleController {

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
        [systemScaleInstanceList: SystemScale.selectList(), systemScaleInstanceTotal: SystemScale.selectCount()]
    }

    def show = {
        def systemScaleInstance = SystemScale.get(params.id)
        if (!systemScaleInstance) {
            flash.message = 'systemScale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Scale not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemScaleInstance: systemScaleInstance]
        }
    }

    def delete = {
        def systemScaleInstance = SystemScale.get(params.id)
        if (systemScaleInstance) {
            try {
                utilService.deleteWithMessages(systemScaleInstance, [prefix: 'scale.name', code: systemScaleInstance.code])
                flash.message = 'systemScale.deleted'
                flash.args = [systemScaleInstance.toString()]
                flash.defaultMessage = "System Scale ${systemScaleInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemScale.not.deleted'
                flash.args = [systemScaleInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Scale ${systemScaleInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemScale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Scale not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemScaleInstance = SystemScale.get(params.id)
        if (!systemScaleInstance) {
            flash.message = 'systemScale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Scale not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemScaleInstance: systemScaleInstance]
        }
    }

    def update = {
        def systemScaleInstance = SystemScale.get(params.id)
        if (systemScaleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemScaleInstance.version > version) {
                    systemScaleInstance.errors.rejectValue('version', 'systemScale.optimistic.locking.failure', 'Another user has updated this System Scale while you were editing')
                    render(view: 'edit', model: [systemScaleInstance: systemScaleInstance])
                    return
                }
            }

            def oldCode = systemScaleInstance.code
            systemScaleInstance.properties['code', 'name'] = params
            if (utilService.saveWithMessages(systemScaleInstance, [prefix: 'scale.name', code: systemScaleInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemScale.updated'
                flash.args = [systemScaleInstance.toString()]
                flash.defaultMessage = "System Scale ${systemScaleInstance.toString()} updated"
                redirect(action: show, id: systemScaleInstance.id)
            } else {
                render(view: 'edit', model: [systemScaleInstance: systemScaleInstance])
            }
        } else {
            flash.message = 'systemScale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Scale not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        return [systemScaleInstance: new SystemScale()]
    }

    def save = {
        def systemScaleInstance = new SystemScale()
        systemScaleInstance.properties['code', 'name'] = params
        if (utilService.saveWithMessages(systemScaleInstance, [prefix: 'scale.name', code: systemScaleInstance.code, field: 'name'])) {
            flash.message = 'systemScale.created'
            flash.args = [systemScaleInstance.toString()]
            flash.defaultMessage = "System Scale ${systemScaleInstance.toString()} created"
            redirect(action: show, id: systemScaleInstance.id)
        } else {
            render(view: 'create', model: [systemScaleInstance: systemScaleInstance])
        }
    }
}