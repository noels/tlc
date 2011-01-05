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

class SystemActionController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['appController', 'appAction'].contains(params.sort) ? params.sort : 'appController'
        def ddSource = utilService.source('systemActivity.list')
        [systemActionInstanceList: SystemAction.selectList(), systemActionInstanceTotal: SystemAction.selectCount(), ddSource: ddSource]
    }

    def show = {
        def systemActionInstance = SystemAction.get(params.id)
        if (!systemActionInstance) {
            flash.message = 'systemAction.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Action not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemActionInstance: systemActionInstance]
        }
    }

    def delete = {
        def systemActionInstance = SystemAction.get(params.id)
        if (systemActionInstance) {
            try {
                systemActionInstance.delete(flush: true)
                utilService.cacheService.resetThis('actionActivity', CacheService.COMPANY_INSENSITIVE, "${systemActionInstance.appController}.${systemActionInstance.appAction}")
                flash.message = 'systemAction.deleted'
                flash.args = [systemActionInstance.toString()]
                flash.defaultMessage = "Action ${systemActionInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemAction.not.deleted'
                flash.args = [systemActionInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Action ${systemActionInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemAction.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Action not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemActionInstance = SystemAction.get(params.id)
        if (!systemActionInstance) {
            flash.message = 'systemAction.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Action not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemActionInstance: systemActionInstance]
        }
    }

    def update = {
        def systemActionInstance = SystemAction.get(params.id)
        if (systemActionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemActionInstance.version > version) {
                    systemActionInstance.errors.rejectValue('version', 'systemAction.optimistic.locking.failure', 'Another user has updated this Action while you were editing')
                    render(view: 'edit', model: [systemActionInstance: systemActionInstance])
                    return
                }
            }

            def oldController = systemActionInstance.appController
            def oldAction = systemActionInstance.appAction
            def oldActivityId = systemActionInstance.activity.id
            systemActionInstance.properties['appController', 'appAction', 'activity'] = params
            if (!systemActionInstance.hasErrors() && systemActionInstance.saveThis()) {
                if (systemActionInstance.appController != oldController || systemActionInstance.appAction != oldAction || systemActionInstance.activity.id != oldActivityId) {
                    utilService.cacheService.resetThis('actionActivity', CacheService.COMPANY_INSENSITIVE, "${oldController}.${oldAction}")
                    utilService.cacheService.resetThis('actionActivity', CacheService.COMPANY_INSENSITIVE, "${systemActionInstance.appController}.${systemActionInstance.appAction}")
                }

                flash.message = 'systemAction.updated'
                flash.args = [systemActionInstance.toString()]
                flash.defaultMessage = "Action ${systemActionInstance.toString()} updated"
                redirect(action: show, id: systemActionInstance.id)
            } else {
                render(view: 'edit', model: [systemActionInstance: systemActionInstance])
            }
        } else {
            flash.message = 'systemAction.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Action not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemActionInstance = new SystemAction()
        systemActionInstance.activity = utilService.reSource('systemActivity.list')
        return [systemActionInstance: systemActionInstance]
    }

    def save = {
        def systemActionInstance = new SystemAction()
        systemActionInstance.properties['appController', 'appAction', 'activity'] = params
        if (!systemActionInstance.hasErrors() && systemActionInstance.saveThis()) {
            utilService.cacheService.resetThis('actionActivity', CacheService.COMPANY_INSENSITIVE, "${systemActionInstance.appController}.${systemActionInstance.appAction}")
            flash.message = 'systemAction.created'
            flash.args = [systemActionInstance.toString()]
            flash.defaultMessage = "Action ${systemActionInstance.toString()} created"
            redirect(action: show, id: systemActionInstance.id)
        } else {
            render(view: 'create', model: [systemActionInstance: systemActionInstance])
        }
    }
}