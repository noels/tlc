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

import com.whollygrails.tlc.obj.SystemConversionTest

class SystemConversionController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', testing: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'preAddition', 'multiplier', 'postAddition'].contains(params.sort) ? params.sort : 'code'
        [systemConversionInstanceList: SystemConversion.selectList(), systemConversionInstanceTotal: SystemConversion.selectCount()]
    }

    def show = {
        def systemConversionInstance = SystemConversion.get(params.id)
        if (!systemConversionInstance) {
            flash.message = 'systemConversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Conversion not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemConversionInstance: systemConversionInstance]
        }
    }

    def delete = {
        def systemConversionInstance = SystemConversion.get(params.id)
        if (systemConversionInstance) {
            try {
                utilService.deleteWithMessages(systemConversionInstance, [prefix: 'conversion.name', code: systemConversionInstance.code])
                utilService.cacheService.resetThis('conversion', 0L, systemConversionInstance.source.code)
                utilService.cacheService.resetThis('conversion', 0L, systemConversionInstance.target.code)
                flash.message = 'systemConversion.deleted'
                flash.args = [systemConversionInstance.toString()]
                flash.defaultMessage = "System Conversion ${systemConversionInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemConversion.not.deleted'
                flash.args = [systemConversionInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Conversion ${systemConversionInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemConversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Conversion not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemConversionInstance = SystemConversion.get(params.id)
        if (!systemConversionInstance) {
            flash.message = 'systemConversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Conversion not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemConversionInstance: systemConversionInstance]
        }
    }

    def update = {
        def systemConversionInstance = SystemConversion.get(params.id)
        if (systemConversionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemConversionInstance.version > version) {
                    systemConversionInstance.errors.rejectValue('version', 'systemConversion.optimistic.locking.failure', 'Another user has updated this System Conversion while you were editing')
                    render(view: 'edit', model: [systemConversionInstance: systemConversionInstance])
                    return
                }
            }

            def oldCode = systemConversionInstance.code
            systemConversionInstance.properties['code', 'name', 'preAddition', 'multiplier', 'postAddition', 'target', 'source'] = params
            if (utilService.saveWithMessages(systemConversionInstance, [prefix: 'conversion.name', code: systemConversionInstance.code, oldCode: oldCode, field: 'name'])) {
                utilService.cacheService.resetThis('conversion', 0L, systemConversionInstance.source.code)
                utilService.cacheService.resetThis('conversion', 0L, systemConversionInstance.target.code)
                flash.message = 'systemConversion.updated'
                flash.args = [systemConversionInstance.toString()]
                flash.defaultMessage = "System Conversion ${systemConversionInstance.toString()} updated"
                redirect(action: show, id: systemConversionInstance.id)
            } else {
                render(view: 'edit', model: [systemConversionInstance: systemConversionInstance])
            }
        } else {
            flash.message = 'systemConversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Conversion not found with id ${params.id}"
            redirect(action: edit, id: params.id)
        }
    }

    def create = {
        return [systemConversionInstance: new SystemConversion()]
    }

    def save = {
        def systemConversionInstance = new SystemConversion()
        systemConversionInstance.properties['code', 'name', 'preAddition', 'multiplier', 'postAddition', 'target', 'source'] = params
        if (utilService.saveWithMessages(systemConversionInstance, [prefix: 'conversion.name', code: systemConversionInstance.code, field: 'name'])) {
            utilService.cacheService.resetThis('conversion', 0L, systemConversionInstance.source.code)
            utilService.cacheService.resetThis('conversion', 0L, systemConversionInstance.target.code)
            flash.message = 'systemConversion.created'
            flash.args = [systemConversionInstance.toString()]
            flash.defaultMessage = "System Conversion ${systemConversionInstance.toString()} created"
            redirect(action: show, id: systemConversionInstance.id)
        } else {
            render(view: 'create', model: [systemConversionInstance: systemConversionInstance])
        }
    }

    def test = {SystemConversionTest testInstance ->
        return [testInstance: testInstance]
    }

    def testing = {SystemConversionTest testInstance ->
        if (!testInstance.hasErrors()) {
            if (testInstance.quantity == null) testInstance.quantity = 0
            try {
                def rslt = utilService.convertUnit(testInstance.fromUnit, testInstance.toUnit, testInstance.quantity, 10)
                testInstance.result = (rslt == null) ? '' : rslt.toPlainString()
            } catch (IllegalArgumentException ex) {
                testInstance.result = ex.message
            }
        }

        render(view: 'test', model: [testInstance: testInstance])
    }
}