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

class SystemActivityController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', link: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'systemOnly'].contains(params.sort) ? params.sort : 'code'
        def ddSource = utilService.source('systemRole.list')
        [systemActivityInstanceList: SystemActivity.selectList(), systemActivityInstanceTotal: SystemActivity.selectCount(), ddSource: ddSource]
    }

    def show = {
        def systemActivityInstance = SystemActivity.get(params.id)
        if (!systemActivityInstance) {
            flash.message = 'systemActivity.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Activity not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemActivityInstance: systemActivityInstance]
        }
    }

    def delete = {
        def systemActivityInstance = SystemActivity.get(params.id)
        if (systemActivityInstance) {
            try {
                systemActivityInstance.delete(flush: true)
                utilService.cacheService.resetThis('userActivity', utilService.cacheService.COMPANY_INSENSITIVE, systemActivityInstance.code)
                flash.message = 'systemActivity.deleted'
                flash.args = [systemActivityInstance.toString()]
                flash.defaultMessage = "Activity ${systemActivityInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemActivity.not.deleted'
                flash.args = [systemActivityInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Activity ${systemActivityInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemActivity.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Activity not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemActivityInstance = SystemActivity.get(params.id)
        if (!systemActivityInstance) {
            flash.message = 'systemActivity.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Activity not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemActivityInstance: systemActivityInstance]
        }
    }

    def update = {
        def systemActivityInstance = SystemActivity.get(params.id)
        if (systemActivityInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemActivityInstance.version > version) {
                    systemActivityInstance.errors.rejectValue('version', 'systemActivity.optimistic.locking.failure', 'Another user has updated this Activity while you were editing')
                    render(view: 'edit', model: [systemActivityInstance: systemActivityInstance])
                    return
                }
            }

            def oldCode = systemActivityInstance.code
            systemActivityInstance.properties['code', 'systemOnly'] = params
            if (!systemActivityInstance.hasErrors() && systemActivityInstance.saveThis()) {
                if (systemActivityInstance.code != oldCode) {
                    utilService.cacheService.resetThis('userActivity', utilService.cacheService.COMPANY_INSENSITIVE, oldCode)
                    utilService.cacheService.resetThis('userActivity', utilService.cacheService.COMPANY_INSENSITIVE, systemActivityInstance.code)
                }

                flash.message = 'systemActivity.updated'
                flash.args = [systemActivityInstance.toString()]
                flash.defaultMessage = "Activity ${systemActivityInstance.toString()} updated"
                redirect(action: show, id: systemActivityInstance.id)
            } else {
                render(view: 'edit', model: [systemActivityInstance: systemActivityInstance])
            }
        } else {
            flash.message = 'systemActivity.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Activity not found with id ${params.id}"
            redirect(action: edit, id: params.id)
        }
    }

    def create = {
        def systemActivityInstance = new SystemActivity()
        systemActivityInstance.properties['code', 'systemOnly'] = params
        return [systemActivityInstance: systemActivityInstance]
    }

    def save = {
        def systemActivityInstance = new SystemActivity()
        systemActivityInstance.properties['code', 'systemOnly'] = params
        if (!systemActivityInstance.hasErrors() && systemActivityInstance.saveThis()) {
            utilService.cacheService.resetThis('userActivity', utilService.cacheService.COMPANY_INSENSITIVE, systemActivityInstance.code)
            flash.message = 'systemActivity.created'
            flash.args = [systemActivityInstance.toString()]
            flash.defaultMessage = "Activity ${systemActivityInstance.toString()} created"
            redirect(action: show, id: systemActivityInstance.id)
        } else {
            render(view: 'create', model: [systemActivityInstance: systemActivityInstance])
        }
    }

    def links = {
        def ddSource = utilService.reSource('systemRole.list')
        [allActivities: SystemActivity.findAllBySystemOnly(false), roleActivities: SystemActivity.selectList(action: 'list'), ddSource: ddSource]
    }

    def link = {
        def ddSource = utilService.reSource('systemRole.list')
        def roleActivities = SystemActivity.selectList(action: 'list')
        def activities = []
        if (params.linkages) activities = params.linkages instanceof String ? [params.linkages.toLong()] : params.linkages*.toLong() as List
        def modified = false
        for (activity in roleActivities) {
            if (!activities.contains(activity.id)) {
                ddSource.removeFromActivities(activity)
                modified = true
            }
        }

        for (activity in activities) {
            def found = false
            for (a in roleActivities) {
                if (a.id == activity) {
                    found = true
                    break
                }
            }

            if (!found) {
                ddSource.addToActivities(SystemActivity.get(activity))
                modified = true
            }
        }

        if (modified) {
            if (ddSource.save(flush: true)) {      // With deep validation
                utilService.cacheService.clearThis('userActivity')
                flash.message = 'generic.links.changed'
                flash.defaultMessage = "The links were successfully updated"
            } else {
                flash.message = 'generic.links.failed'
                flash.defaultMessage = "Error updating the links"
            }
        } else {
            flash.message = 'generic.links.unchanged'
            flash.defaultMessage = "No links were changed"
        }

        redirect(action: list)
    }
}