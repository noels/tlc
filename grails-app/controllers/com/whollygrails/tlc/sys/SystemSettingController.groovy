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

import com.whollygrails.tlc.corp.Company
import com.whollygrails.tlc.corp.Setting

class SystemSettingController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', propagate: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.sort = ['code', 'dataScale', 'value', 'systemOnly'].contains(params.sort) ? params.sort : 'code'
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        [systemSettingInstanceList: SystemSetting.selectList(), systemSettingInstanceTotal: SystemSetting.selectCount()]
    }

    def show = {
        def systemSettingInstance = SystemSetting.get(params.id)

        if (!systemSettingInstance) {
            flash.message = 'systemSetting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Setting not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemSettingInstance: systemSettingInstance]
        }
    }

    def delete = {
        def systemSettingInstance = SystemSetting.get(params.id)
        if (systemSettingInstance) {
            try {
                systemSettingInstance.delete(flush: true)
                utilService.cacheService.resetThis('setting', 0L, systemSettingInstance.code)
                flash.message = 'systemSetting.deleted'
                flash.args = [systemSettingInstance.toString()]
                flash.defaultMessage = "System Setting ${systemSettingInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemSetting.not.deleted'
                flash.args = [systemSettingInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Setting ${systemSettingInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemSetting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Setting not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemSettingInstance = SystemSetting.get(params.id)

        if (!systemSettingInstance) {
            flash.message = 'systemSetting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Setting not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemSettingInstance: systemSettingInstance]
        }
    }

    def update = {
        def systemSettingInstance = SystemSetting.get(params.id)
        if (systemSettingInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemSettingInstance.version > version) {
                    systemSettingInstance.errors.rejectValue('version', 'systemSetting.optimistic.locking.failure', 'Another user has updated this System Setting while you were editing')
                    render(view: 'edit', model: [systemSettingInstance: systemSettingInstance])
                    return
                }
            }

            def oldCode = systemSettingInstance.code
            systemSettingInstance.properties['code', 'dataType', 'dataScale', 'value', 'systemOnly'] = params
            if (!systemSettingInstance.hasErrors() && systemSettingInstance.saveThis()) {
                utilService.cacheService.resetThis('setting', 0L, oldCode)
                if (systemSettingInstance.code != oldCode) utilService.cacheService.resetThis('setting', 0L, systemSettingInstance.code)
                flash.message = 'systemSetting.updated'
                flash.args = [systemSettingInstance.toString()]
                flash.defaultMessage = "System Setting ${systemSettingInstance.toString()} updated"
                redirect(action: show, id: systemSettingInstance.id)
            } else {
                render(view: 'edit', model: [systemSettingInstance: systemSettingInstance])
            }
        } else {
            flash.message = 'systemSetting.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Setting not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        return ['systemSettingInstance': new SystemSetting()]
    }

    def save = {
        def systemSettingInstance = new SystemSetting()
        systemSettingInstance.properties['code', 'dataType', 'dataScale', 'value', 'systemOnly'] = params
        if (!systemSettingInstance.hasErrors() && systemSettingInstance.saveThis()) {
            utilService.cacheService.resetThis('setting', 0L, systemSettingInstance.code)
            flash.message = 'systemSetting.created'
            flash.args = [systemSettingInstance.toString()]
            flash.defaultMessage = "System Setting ${systemSettingInstance.toString()} created"
            redirect(action: show, id: systemSettingInstance.id)
        } else {
            render(view: 'create', model: [systemSettingInstance: systemSettingInstance])
        }
    }

    def propagate = {
        def count = 0
        def systemSettingInstance = SystemSetting.get(params.id)
        if (systemSettingInstance && !systemSettingInstance.systemOnly) {
            def setting
            def companies = Company.list()
            for (company in companies) {
                setting = Setting.findByCompanyAndCode(company, systemSettingInstance.code)
                if (!setting) {
                    setting = new Setting(company: company, code: systemSettingInstance.code, dataType: systemSettingInstance.dataType,
                            dataScale: systemSettingInstance.dataScale, value: systemSettingInstance.value)
                    if (setting.saveThis()) count++
                }
            }
        }

        flash.message = 'systemSetting.propagated'
        flash.args = ["${count}"]
        flash.defaultMessage = "${count} company/companies updated"
        redirect(action: list)
    }
}