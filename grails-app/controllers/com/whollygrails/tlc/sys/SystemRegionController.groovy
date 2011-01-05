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

class SystemRegionController {

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
        def ddSource = utilService.source('systemGeo.list')
        [systemRegionInstanceList: SystemRegion.selectList(), systemRegionInstanceTotal: SystemRegion.selectCount(), ddSource: ddSource]
    }

    def show = {
        def systemRegionInstance = SystemRegion.get(params.id)
        if (!systemRegionInstance) {
            flash.message = 'systemRegion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Region not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemRegionInstance: systemRegionInstance]
        }
    }

    def delete = {
        def systemRegionInstance = SystemRegion.get(params.id)
        if (systemRegionInstance) {
            try {
                utilService.deleteWithMessages(systemRegionInstance, [prefix: 'region.name', code: systemRegionInstance.code])
                flash.message = 'systemRegion.deleted'
                flash.args = [systemRegionInstance.toString()]
                flash.defaultMessage = "System Region ${systemRegionInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemRegion.not.deleted'
                flash.args = [systemRegionInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Region ${systemRegionInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemRegion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Region not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemRegionInstance = SystemRegion.get(params.id)
        if (!systemRegionInstance) {
            flash.message = 'systemRegion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Region not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemRegionInstance: systemRegionInstance]
        }
    }

    def update = {
        def systemRegionInstance = SystemRegion.get(params.id)
        if (systemRegionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemRegionInstance.version > version) {
                    systemRegionInstance.errors.rejectValue('version', 'systemRegion.optimistic.locking.failure', 'Another user has updated this System Region while you were editing')
                    render(view: 'edit', model: [systemRegionInstance: systemRegionInstance])
                    return
                }
            }

            def oldCode = systemRegionInstance.code
            systemRegionInstance.properties['code', 'name', 'geo'] = params
            if (utilService.saveWithMessages(systemRegionInstance, [prefix: 'region.name', code: systemRegionInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemRegion.updated'
                flash.args = [systemRegionInstance.toString()]
                flash.defaultMessage = "System Region ${systemRegionInstance.toString()} updated"
                redirect(action: show, id: systemRegionInstance.id)
            } else {
                render(view: 'edit', model: [systemRegionInstance: systemRegionInstance])
            }
        } else {
            flash.message = 'systemRegion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Region not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemRegionInstance = new SystemRegion()
        systemRegionInstance.geo = utilService.reSource('systemGeo.list')
        return [systemRegionInstance: systemRegionInstance]
    }

    def save = {
        def systemRegionInstance = new SystemRegion()
        systemRegionInstance.properties['code', 'name', 'geo'] = params
        if (utilService.saveWithMessages(systemRegionInstance, [prefix: 'region.name', code: systemRegionInstance.code, field: 'name'])) {
            flash.message = 'systemRegion.created'
            flash.args = [systemRegionInstance.toString()]
            flash.defaultMessage = "System Region ${systemRegionInstance.toString()} created"
            redirect(action: show, id: systemRegionInstance.id)
        } else {
            render(view: 'create', model: [systemRegionInstance: systemRegionInstance])
        }
    }
}