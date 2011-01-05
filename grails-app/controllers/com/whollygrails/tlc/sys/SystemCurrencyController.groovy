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

class SystemCurrencyController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'decimals', 'autoUpdate'].contains(params.sort) ? params.sort : 'code'
        [systemCurrencyInstanceList: SystemCurrency.selectList(), systemCurrencyInstanceTotal: SystemCurrency.selectCount()]
    }

    def show = {
        def systemCurrencyInstance = SystemCurrency.get(params.id)
        if (!systemCurrencyInstance) {
            flash.message = 'systemCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Currency not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemCurrencyInstance: systemCurrencyInstance]
        }
    }

    def delete = {
        def systemCurrencyInstance = SystemCurrency.get(params.id)
        if (systemCurrencyInstance) {
            if (systemCurrencyInstance.code == UtilService.BASE_CURRENCY_CODE) {
                flash.message = 'exchangeCurrency.base.delete'
                flash.defaultMessage = 'This is the system base currency and cannot be deleted'
                redirect(action: show, id: params.id)
            } else {
                try {
                    utilService.deleteWithMessages(systemCurrencyInstance, [prefix: 'currency.name', code: systemCurrencyInstance.code])
                    flash.message = 'systemCurrency.deleted'
                    flash.args = [systemCurrencyInstance.toString()]
                    flash.defaultMessage = "System Currency ${systemCurrencyInstance.toString()} deleted"
                    redirect(action: list)
                } catch (Exception e) {
                    flash.message = 'systemCurrency.not.deleted'
                    flash.args = [systemCurrencyInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "System Currency ${systemCurrencyInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            }
        } else {
            flash.message = 'systemCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Currency not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemCurrencyInstance = SystemCurrency.get(params.id)
        if (!systemCurrencyInstance) {
            flash.message = 'systemCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Currency not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemCurrencyInstance: systemCurrencyInstance]
        }
    }

    def update = {
        def systemCurrencyInstance = SystemCurrency.get(params.id)
        if (systemCurrencyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemCurrencyInstance.version > version) {
                    systemCurrencyInstance.errors.rejectValue('version', 'systemCurrency.optimistic.locking.failure', 'Another user has updated this System Currency while you were editing')
                    render(view: 'edit', model: [systemCurrencyInstance: systemCurrencyInstance])
                    return
                }
            }

            def oldCode = systemCurrencyInstance.code
            systemCurrencyInstance.properties['code', 'name', 'decimals', 'autoUpdate'] = params
            if (oldCode != systemCurrencyInstance.code && oldCode == UtilService.BASE_CURRENCY_CODE) {
                systemCurrencyInstance.errorMessage(field: 'code', code: 'exchangeCurrency.base.change', default: 'This is the system base currency and cannot have its code changed')
                render(view: 'edit', model: [systemCurrencyInstance: systemCurrencyInstance])
            } else {
                if (utilService.saveWithMessages(systemCurrencyInstance, [prefix: 'currency.name', code: systemCurrencyInstance.code, oldCode: oldCode, field: 'name'])) {
                    flash.message = 'systemCurrency.updated'
                    flash.args = [systemCurrencyInstance.toString()]
                    flash.defaultMessage = "System Currency ${systemCurrencyInstance.toString()} updated"
                    redirect(action: show, id: systemCurrencyInstance.id)
                } else {
                    render(view: 'edit', model: [systemCurrencyInstance: systemCurrencyInstance])
                }
            }
        } else {
            flash.message = 'systemCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Currency not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        return [systemCurrencyInstance: new SystemCurrency()]
    }

    def save = {
        def systemCurrencyInstance = new SystemCurrency()
        systemCurrencyInstance.properties['code', 'name', 'decimals', 'autoUpdate'] = params
        if (utilService.saveWithMessages(systemCurrencyInstance, [prefix: 'currency.name', code: systemCurrencyInstance.code, field: 'name'])) {
            flash.message = 'systemCurrency.created'
            flash.args = [systemCurrencyInstance.toString()]
            flash.defaultMessage = "System Currency ${systemCurrencyInstance.toString()} created"
            redirect(action: show, id: systemCurrencyInstance.id)
        } else {
            render(view: 'create', model: [systemCurrencyInstance: systemCurrencyInstance])
        }
    }
}