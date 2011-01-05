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

class SystemGeoController {

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
        [systemGeoInstanceList: SystemGeo.selectList(), systemGeoInstanceTotal: SystemGeo.selectCount()]
    }

    def show = {
        def systemGeoInstance = SystemGeo.get(params.id)
        if (!systemGeoInstance) {
            flash.message = 'systemGeo.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Geo not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemGeoInstance: systemGeoInstance]
        }
    }

    def delete = {
        def systemGeoInstance = SystemGeo.get(params.id)
        if (systemGeoInstance) {
            try {
                utilService.deleteWithMessages(systemGeoInstance, [prefix: 'geo.name', code: systemGeoInstance.code])
                flash.message = 'systemGeo.deleted'
                flash.args = [systemGeoInstance.toString()]
                flash.defaultMessage = "System Geo ${systemGeoInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemGeo.not.deleted'
                flash.args = [systemGeoInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Geo ${systemGeoInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemGeo.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Geo not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemGeoInstance = SystemGeo.get(params.id)
        if (!systemGeoInstance) {
            flash.message = 'systemGeo.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Geo not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemGeoInstance: systemGeoInstance]
        }
    }

    def update = {
        def systemGeoInstance = SystemGeo.get(params.id)
        if (systemGeoInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemGeoInstance.version > version) {
                    systemGeoInstance.errors.rejectValue('version', 'systemGeo.optimistic.locking.failure', 'Another user has updated this System Geo while you were editing')
                    render(view: 'edit', model: [systemGeoInstance: systemGeoInstance])
                    return
                }
            }

            def oldCode = systemGeoInstance.code
            systemGeoInstance.properties['code', 'name'] = params
            if (utilService.saveWithMessages(systemGeoInstance, [prefix: 'geo.name', code: systemGeoInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemGeo.updated'
                flash.args = [systemGeoInstance.toString()]
                flash.defaultMessage = "System Geo ${systemGeoInstance.toString()} updated"
                redirect(action: show, id: systemGeoInstance.id)
            } else {
                render(view: 'edit', model: [systemGeoInstance: systemGeoInstance])
            }
        } else {
            flash.message = 'systemGeo.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Geo not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        return [systemGeoInstance: new SystemGeo()]
    }

    def save = {
        def systemGeoInstance = new SystemGeo()
        systemGeoInstance.properties['code', 'name'] = params
        if (utilService.saveWithMessages(systemGeoInstance, [prefix: 'geo.name', code: systemGeoInstance.code, field: 'name'])) {
            flash.message = 'systemGeo.created'
            flash.args = [systemGeoInstance.toString()]
            flash.defaultMessage = "System Geo ${systemGeoInstance.toString()} created"
            redirect(action: show, id: systemGeoInstance.id)
        } else {
            render(view: 'create', model: [systemGeoInstance: systemGeoInstance])
        }
    }
}