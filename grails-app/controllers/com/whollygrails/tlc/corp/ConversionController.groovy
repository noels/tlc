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

import com.whollygrails.tlc.obj.ConversionTest

class ConversionController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', testing: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'preAddition', 'multiplier', 'postAddition'].contains(params.sort) ? params.sort : 'code'
        [conversionInstanceList: Conversion.selectList(securityCode: utilService.currentCompany().securityCode), conversionInstanceTotal: Conversion.selectCount()]
    }

    def show = {
        def conversionInstance = Conversion.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!conversionInstance) {
            flash.message = 'conversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Conversion not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [conversionInstance: conversionInstance]
        }
    }

    def delete = {
        def conversionInstance = Conversion.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (conversionInstance) {
            try {
                utilService.deleteWithMessages(conversionInstance, [prefix: 'conversion.name', code: conversionInstance.code])
                utilService.cacheService.resetThis('conversion', conversionInstance.securityCode, conversionInstance.source.code)
                utilService.cacheService.resetThis('conversion', conversionInstance.securityCode, conversionInstance.target.code)
                flash.message = 'conversion.deleted'
                flash.args = [conversionInstance.toString()]
                flash.defaultMessage = "Conversion ${conversionInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'conversion.not.deleted'
                flash.args = [conversionInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Conversion ${conversionInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'conversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Conversion not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def conversionInstance = Conversion.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!conversionInstance) {
            flash.message = 'conversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Conversion not found with id ${params.id}"
            redirect(action: list)
        } else {
            def unitList = Unit.findAllBySecurityCode(utilService.currentCompany().securityCode)
            return [conversionInstance: conversionInstance, unitList: unitList]
        }
    }

    def update = {
        def conversionInstance = Conversion.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (conversionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (conversionInstance.version > version) {
                    conversionInstance.errors.rejectValue('version', 'conversion.optimistic.locking.failure', 'Another user has updated this Conversion while you were editing')
                    def unitList = Unit.findAllBySecurityCode(utilService.currentCompany().securityCode)
                    render(view: 'edit', model: [conversionInstance: conversionInstance, unitList: unitList])
                    return
                }
            }

            def oldCode = conversionInstance.code
            conversionInstance.properties['code', 'name', 'preAddition', 'multiplier', 'postAddition', 'target', 'source'] = params
            utilService.verify(conversionInstance, ['target', 'source'])             // Ensure correct references
            if (utilService.saveWithMessages(conversionInstance, [prefix: 'conversion.name', code: conversionInstance.code, oldCode: oldCode, field: 'name'])) {
                utilService.cacheService.resetThis('conversion', conversionInstance.securityCode, conversionInstance.source.code)
                utilService.cacheService.resetThis('conversion', conversionInstance.securityCode, conversionInstance.target.code)
                flash.message = 'conversion.updated'
                flash.args = [conversionInstance.toString()]
                flash.defaultMessage = "Conversion ${conversionInstance.toString()} updated"
                redirect(action: show, id: conversionInstance.id)
            } else {
                def unitList = Unit.findAllBySecurityCode(utilService.currentCompany().securityCode)
                render(view: 'edit', model: [conversionInstance: conversionInstance, unitList: unitList])
            }
        } else {
            flash.message = 'conversion.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Conversion not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def conversionInstance = new Conversion()
        def unitList = Unit.findAllBySecurityCode(utilService.currentCompany().securityCode)
        return [conversionInstance: conversionInstance, unitList: unitList]
    }

    def save = {
        def conversionInstance = new Conversion()
        conversionInstance.properties['code', 'name', 'preAddition', 'multiplier', 'postAddition', 'target', 'source'] = params
        utilService.verify(conversionInstance, ['target', 'source'])             // Ensure correct references
        if (utilService.saveWithMessages(conversionInstance, [prefix: 'conversion.name', code: conversionInstance.code, field: 'name'])) {
            utilService.cacheService.resetThis('conversion', conversionInstance.securityCode, conversionInstance.source.code)
            utilService.cacheService.resetThis('conversion', conversionInstance.securityCode, conversionInstance.target.code)
            flash.message = 'conversion.created'
            flash.args = [conversionInstance.toString()]
            flash.defaultMessage = "Conversion ${conversionInstance.toString()} created"
            redirect(action: show, id: conversionInstance.id)
        } else {
            def unitList = Unit.findAllBySecurityCode(utilService.currentCompany().securityCode)
            render(view: 'create', model: [conversionInstance: conversionInstance, unitList: unitList])
        }
    }

    def test = {ConversionTest testInstance ->
        def unitList = Unit.findAllBySecurityCode(utilService.currentCompany().securityCode)
        return [testInstance: testInstance, unitList: unitList]
    }

    def testing = {ConversionTest testInstance ->
        if (!testInstance.hasErrors()) {
            if (testInstance.quantity == null) testInstance.quantity = 0
            try {
                def rslt = utilService.convertUnit(testInstance.fromUnit, testInstance.toUnit, testInstance.quantity, 10)
                testInstance.result = (rslt == null) ? '' : rslt.toPlainString()
            } catch (IllegalArgumentException ex) {
                testInstance.result = ex.message
            }
        }

        def unitList = Unit.findAllBySecurityCode(utilService.currentCompany().securityCode)
        render(view: 'test', model: [testInstance: testInstance, unitList: unitList])
    }
}