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
package com.whollygrails.tlc.corp

class SettingController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'dataType', 'dataScale', 'value'].contains(params.sort) ? params.sort : 'code'
        [settingInstanceList: Setting.selectList(company: utilService.currentCompany()), settingInstanceTotal: Setting.selectCount()]
    }

    def show = {
        def settingInstance = Setting.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!settingInstance) {
            flash.message = 'setting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Setting not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [settingInstance: settingInstance]
        }
    }

    def delete = {
        def settingInstance = Setting.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (settingInstance) {
            try {
                settingInstance.delete(flush: true)
                utilService.cacheService.resetThis('setting', settingInstance.securityCode, settingInstance.code)
                flash.message = 'setting.deleted'
                flash.args = [settingInstance.toString()]
                flash.defaultMessage = "Setting ${settingInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'setting.not.deleted'
                flash.args = [settingInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Setting ${settingInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'setting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Setting not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def settingInstance = Setting.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!settingInstance) {
            flash.message = 'setting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Setting not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [settingInstance: settingInstance]
        }
    }

    def update = {
        def settingInstance = Setting.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (settingInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (settingInstance.version > version) {
                    settingInstance.errors.rejectValue('version', 'setting.optimistic.locking.failure', 'Another user has updated this Setting while you were editing')
                    render(view: 'edit', model: [settingInstance: settingInstance])
                    return
                }
            }

            def oldCode = settingInstance.code
            settingInstance.properties['code', 'dataType', 'dataScale', 'value'] = params
            if (!settingInstance.hasErrors() && settingInstance.saveThis()) {
                utilService.cacheService.resetThis('setting', settingInstance.securityCode, oldCode)
                if (settingInstance.code != oldCode) utilService.cacheService.resetThis('setting', settingInstance.securityCode, settingInstance.code)
                flash.message = 'setting.updated'
                flash.args = [settingInstance.toString()]
                flash.defaultMessage = "Setting ${settingInstance.toString()} updated"
                redirect(action: show, id: settingInstance.id)
            } else {
                render(view: 'edit', model: [settingInstance: settingInstance])
            }
        } else {
            flash.message = 'setting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Setting not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def settingInstance = new Setting()
        settingInstance.company = utilService.currentCompany()   // Ensure correct company
        return [settingInstance: settingInstance]
    }

    def save = {
        def settingInstance = new Setting()
        settingInstance.properties['code', 'dataType', 'dataScale', 'value'] = params
        settingInstance.company = utilService.currentCompany()   // Ensure correct company
        if (!settingInstance.hasErrors() && settingInstance.saveThis()) {
            utilService.cacheService.resetThis('setting', settingInstance.securityCode, settingInstance.code)
            flash.message = 'setting.created'
            flash.args = [settingInstance.toString()]
            flash.defaultMessage = "Setting ${settingInstance.toString()} created"
            redirect(action: show, id: settingInstance.id)
        } else {
            render(view: 'create', model: [settingInstance: settingInstance])
        }
    }
}