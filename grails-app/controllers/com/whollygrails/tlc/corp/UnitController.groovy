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

class UnitController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'multiplier'].contains(params.sort) ? params.sort : 'code'
        def ddSource = utilService.source('measure.list')
        if (!ddSource) ddSource = utilService.source('scale.list')
        [unitInstanceList: Unit.selectList(securityCode: utilService.currentCompany().securityCode), unitInstanceTotal: Unit.selectCount(), ddSource: ddSource]
    }

    def show = {
        def unitInstance = Unit.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!unitInstance) {
            flash.message = 'unit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Unit not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [unitInstance: unitInstance]
        }
    }

    def delete = {
        def unitInstance = Unit.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (unitInstance) {
            try {
                utilService.deleteWithMessages(unitInstance, [prefix: 'unit.name', code: unitInstance.code])
                utilService.cacheService.resetThis('conversion', unitInstance.securityCode, unitInstance.code)
                flash.message = 'unit.deleted'
                flash.args = [unitInstance.toString()]
                flash.defaultMessage = "Unit ${unitInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'unit.not.deleted'
                flash.args = [unitInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Unit ${unitInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'unit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Unit not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def unitInstance = Unit.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!unitInstance) {
            flash.message = 'unit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Unit not found with id ${params.id}"
            redirect(action: list)
        } else {
            def measureList = Measure.findAllByCompany(utilService.currentCompany())
            def scaleList = Scale.findAllByCompany(utilService.currentCompany())
            return [unitInstance: unitInstance, measureList: measureList, scaleList: scaleList]
        }
    }

    def update = {
        def unitInstance = Unit.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (unitInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (unitInstance.version > version) {
                    unitInstance.errors.rejectValue('version', 'unit.optimistic.locking.failure', 'Another user has updated this Unit while you were editing')
                    def measureList = Measure.findAllByCompany(utilService.currentCompany())
                    def scaleList = Scale.findAllByCompany(utilService.currentCompany())
                    render(view: 'edit', model: [unitInstance: unitInstance, measureList: measureList, scaleList: scaleList])
                    return
                }
            }

            def oldCode = unitInstance.code
            unitInstance.properties['code', 'name', 'multiplier', 'measure', 'scale'] = params
            utilService.verify(unitInstance, ['measure', 'scale'])             // Ensure correct references
            if (utilService.saveWithMessages(unitInstance, [prefix: 'unit.name', code: unitInstance.code, oldCode: oldCode, field: 'name'])) {
                utilService.cacheService.resetThis('conversion', unitInstance.securityCode, unitInstance.code)
                flash.message = 'unit.updated'
                flash.args = [unitInstance.toString()]
                flash.defaultMessage = "Unit ${unitInstance.toString()} updated"
                redirect(action: show, id: unitInstance.id)
            } else {
                def measureList = Measure.findAllByCompany(utilService.currentCompany())
                def scaleList = Scale.findAllByCompany(utilService.currentCompany())
                render(view: 'edit', model: [unitInstance: unitInstance, measureList: measureList, scaleList: scaleList])
            }
        } else {
            flash.message = 'unit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Unit not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def unitInstance = new Unit()
        def ddSource = utilService.reSource('measure.list')
        if (ddSource) {
            unitInstance.measure = ddSource
        } else {
            ddSource = utilService.reSource('scale.list')
            if (ddSource) unitInstance.scale = ddSource
        }

        def measureList = Measure.findAllByCompany(utilService.currentCompany())
        def scaleList = Scale.findAllByCompany(utilService.currentCompany())
        return [unitInstance: unitInstance, measureList: measureList, scaleList: scaleList]
    }

    def save = {
        def unitInstance = new Unit()
        unitInstance.properties['code', 'name', 'multiplier', 'measure', 'scale'] = params
        utilService.verify(unitInstance, ['measure', 'scale'])             // Ensure correct references
        if (utilService.saveWithMessages(unitInstance, [prefix: 'unit.name', code: unitInstance.code, field: 'name'])) {
            utilService.cacheService.resetThis('conversion', unitInstance.securityCode, unitInstance.code)
            flash.message = 'unit.created'
            flash.args = [unitInstance.toString()]
            flash.defaultMessage = "Unit ${unitInstance.toString()} created"
            redirect(action: show, id: unitInstance.id)
        } else {
            def measureList = Measure.findAllByCompany(utilService.currentCompany())
            def scaleList = Scale.findAllByCompany(utilService.currentCompany())
            render(view: 'create', model: [unitInstance: unitInstance, measureList: measureList, scaleList: scaleList])
        }
    }
}