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

class ScaleController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code'].contains(params.sort) ? params.sort : 'code'
        [scaleInstanceList: Scale.selectList(company: utilService.currentCompany()), scaleInstanceTotal: Scale.selectCount()]
    }

    def show = {
        def scaleInstance = Scale.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!scaleInstance) {
            flash.message = 'scale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Scale not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [scaleInstance: scaleInstance]
        }
    }

    def delete = {
        def scaleInstance = Scale.findByIdAndCompany(params.id, utilService.currentCompany())
        if (scaleInstance) {
            try {
                utilService.deleteWithMessages(scaleInstance, [prefix: 'scale.name', code: scaleInstance.code])
                flash.message = 'scale.deleted'
                flash.args = [scaleInstance.toString()]
                flash.defaultMessage = "Scale ${scaleInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'scale.not.deleted'
                flash.args = [scaleInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Scale ${scaleInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'scale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Scale not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def scaleInstance = Scale.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!scaleInstance) {
            flash.message = 'scale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Scale not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [scaleInstance: scaleInstance]
        }
    }

    def update = {
        def scaleInstance = Scale.findByIdAndCompany(params.id, utilService.currentCompany())
        if (scaleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (scaleInstance.version > version) {
                    scaleInstance.errors.rejectValue('version', 'scale.optimistic.locking.failure', 'Another user has updated this Scale while you were editing')
                    render(view: 'edit', model: [scaleInstance: scaleInstance])
                    return
                }
            }

            def oldCode = scaleInstance.code
            scaleInstance.properties['code', 'name'] = params
            if (utilService.saveWithMessages(scaleInstance, [prefix: 'scale.name', code: scaleInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'scale.updated'
                flash.args = [scaleInstance.toString()]
                flash.defaultMessage = "Scale ${scaleInstance.toString()} updated"
                redirect(action: show, id: scaleInstance.id)
            } else {
                render(view: 'edit', model: [scaleInstance: scaleInstance])
            }
        } else {
            flash.message = 'scale.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Scale not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def scaleInstance = new Scale()
        scaleInstance.company = utilService.currentCompany()
        return [scaleInstance: scaleInstance]
    }

    def save = {
        def scaleInstance = new Scale()
        scaleInstance.properties['code', 'name'] = params
        scaleInstance.company = utilService.currentCompany()
        if (utilService.saveWithMessages(scaleInstance, [prefix: 'scale.name', code: scaleInstance.code, field: 'name'])) {
            flash.message = 'scale.created'
            flash.args = [scaleInstance.toString()]
            flash.defaultMessage = "Scale ${scaleInstance.toString()} created"
            redirect(action: show, id: scaleInstance.id)
        } else {
            render(view: 'create', model: [scaleInstance: scaleInstance])
        }
    }
}