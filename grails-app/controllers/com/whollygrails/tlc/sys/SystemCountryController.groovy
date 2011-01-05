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

class SystemCountryController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'flag'].contains(params.sort) ? params.sort : 'code'
        def ddSource = utilService.source('systemRegion.list')
        [systemCountryInstanceList: SystemCountry.selectList(), systemCountryInstanceTotal: SystemCountry.selectCount(), ddSource: ddSource]
    }

    def show = {
        def systemCountryInstance = SystemCountry.get(params.id)
        if (!systemCountryInstance) {
            flash.message = 'systemCountry.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Country not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemCountryInstance: systemCountryInstance]
        }
    }

    def delete = {
        def systemCountryInstance = SystemCountry.get(params.id)
        if (systemCountryInstance) {
            try {
                utilService.deleteWithMessages(systemCountryInstance, [prefix: 'country.name', code: systemCountryInstance.code])
                flash.message = 'systemCountry.deleted'
                flash.args = [systemCountryInstance.toString()]
                flash.defaultMessage = "System Country ${systemCountryInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemCountry.not.deleted'
                flash.args = [systemCountryInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Country ${systemCountryInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemCountry.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Country not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemCountryInstance = SystemCountry.get(params.id)
        if (!systemCountryInstance) {
            flash.message = 'systemCountry.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Country not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemCountryInstance: systemCountryInstance]
        }
    }

    def update = {
        def systemCountryInstance = SystemCountry.get(params.id)
        if (systemCountryInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemCountryInstance.version > version) {
                    systemCountryInstance.errors.rejectValue('version', 'systemCountry.optimistic.locking.failure', 'Another user has updated this System Country while you were editing')
                    render(view: 'edit', model: [systemCountryInstance: systemCountryInstance])
                    return
                }
            }

            def oldCode = systemCountryInstance.code
            systemCountryInstance.properties['code', 'name', 'flag', 'currency', 'language', 'region', 'addressFormat'] = params
            if (utilService.saveWithMessages(systemCountryInstance, [prefix: 'country.name', code: systemCountryInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemCountry.updated'
                flash.args = [systemCountryInstance.toString()]
                flash.defaultMessage = "System Country ${systemCountryInstance.toString()} updated"
                redirect(action: show, id: systemCountryInstance.id)
            } else {
                render(view: 'edit', model: [systemCountryInstance: systemCountryInstance])
            }
        } else {
            flash.message = 'systemCountry.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Country not found with id ${params.id}"
            redirect(action: edit, id: params.id)
        }
    }

    def create = {
        def systemCountryInstance = new SystemCountry()
        systemCountryInstance.addressFormat = SystemAddressFormat.findByCode('default')
        systemCountryInstance.region = utilService.reSource('systemRegion.list')
        return [systemCountryInstance: systemCountryInstance]
    }

    def save = {
        def systemCountryInstance = new SystemCountry()
        systemCountryInstance.properties['code', 'name', 'flag', 'currency', 'language', 'region', 'addressFormat'] = params
        if (utilService.saveWithMessages(systemCountryInstance, [prefix: 'country.name', code: systemCountryInstance.code, field: 'name'])) {
            flash.message = 'systemCountry.created'
            flash.args = [systemCountryInstance.toString()]
            flash.defaultMessage = "System Country ${systemCountryInstance.toString()} created"
            redirect(action: show, id: systemCountryInstance.id)
        } else {
            render(view: 'create', model: [systemCountryInstance: systemCountryInstance])
        }
    }
}