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

class SystemLanguageController {

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
        [systemLanguageInstanceList: SystemLanguage.selectList(), systemLanguageInstanceTotal: SystemLanguage.selectCount()]
    }

    def show = {
        def systemLanguageInstance = SystemLanguage.get(params.id)
        if (!systemLanguageInstance) {
            flash.message = 'systemLanguage.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Language not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemLanguageInstance: systemLanguageInstance]
        }
    }

    def delete = {
        def systemLanguageInstance = SystemLanguage.get(params.id)
        if (systemLanguageInstance) {
            try {
                utilService.deleteWithMessages(systemLanguageInstance, [prefix: 'language.name', code: systemLanguageInstance.code])
                utilService.cacheService.clearThis('message')
                flash.message = 'systemLanguage.deleted'
                flash.args = [systemLanguageInstance.toString()]
                flash.defaultMessage = "System Language ${systemLanguageInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemLanguage.not.deleted'
                flash.args = [systemLanguageInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Language ${systemLanguageInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemLanguage.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Language not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemLanguageInstance = SystemLanguage.get(params.id)
        if (!systemLanguageInstance) {
            flash.message = 'systemLanguage.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Language not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemLanguageInstance: systemLanguageInstance]
        }
    }

    def update = {
        def systemLanguageInstance = SystemLanguage.get(params.id)
        if (systemLanguageInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemLanguageInstance.version > version) {
                    systemLanguageInstance.errors.rejectValue('version', 'systemLanguage.optimistic.locking.failure', 'Another user has updated this System Language while you were editing')
                    render(view: 'edit', model: [systemLanguageInstance: systemLanguageInstance])
                    return
                }
            }

            def oldCode = systemLanguageInstance.code
            systemLanguageInstance.properties['code', 'name'] = params
            if (utilService.saveWithMessages(systemLanguageInstance, [prefix: 'language.name', code: systemLanguageInstance.code, oldCode: oldCode, field: 'name'])) {
                utilService.cacheService.clearThis('message')
                flash.message = 'systemLanguage.updated'
                flash.args = [systemLanguageInstance.toString()]
                flash.defaultMessage = "System Language ${systemLanguageInstance.toString()} updated"
                redirect(action: show, id: systemLanguageInstance.id)
            } else {
                render(view: 'edit', model: [systemLanguageInstance: systemLanguageInstance])
            }
        } else {
            flash.message = 'systemLanguage.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Language not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        return [systemLanguageInstance: new SystemLanguage()]
    }

    def save = {
        def systemLanguageInstance = new SystemLanguage()
        systemLanguageInstance.properties['code', 'name'] = params
        if (utilService.saveWithMessages(systemLanguageInstance, [prefix: 'language.name', code: systemLanguageInstance.code, field: 'name'])) {
            utilService.cacheService.clearThis('message')
            flash.message = 'systemLanguage.created'
            flash.args = [systemLanguageInstance.toString()]
            flash.defaultMessage = "System Language ${systemLanguageInstance.toString()} created"
            redirect(action: show, id: systemLanguageInstance.id)
        } else {
            render(view: 'create', model: [systemLanguageInstance: systemLanguageInstance])
        }
    }
}