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

class SystemPageHelpController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin', display: 'any']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'locale', 'text'].contains(params.sort) ? params.sort : 'code'
        [systemPageHelpInstanceList: SystemPageHelp.selectList(), systemPageHelpInstanceTotal: SystemPageHelp.selectCount()]
    }

    def show = {
        def systemPageHelpInstance = SystemPageHelp.get(params.id)
        if (!systemPageHelpInstance) {
            flash.message = 'systemPageHelp.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Page Help not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemPageHelpInstance: systemPageHelpInstance]
        }
    }

    def delete = {
        def systemPageHelpInstance = SystemPageHelp.get(params.id)
        if (systemPageHelpInstance) {
            try {
                systemPageHelpInstance.delete(flush: true)
                utilService.cacheService.clearThis('pageHelp')
                flash.message = 'systemPageHelp.deleted'
                flash.args = [systemPageHelpInstance.toString()]
                flash.defaultMessage = "Page Help ${systemPageHelpInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemPageHelp.not.deleted'
                flash.args = [systemPageHelpInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Page Help ${systemPageHelpInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemPageHelp.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Page Help not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemPageHelpInstance = SystemPageHelp.get(params.id)
        if (!systemPageHelpInstance) {
            flash.message = 'systemPageHelp.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Page Help not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemPageHelpInstance: systemPageHelpInstance]
        }
    }

    def update = {
        def systemPageHelpInstance = SystemPageHelp.get(params.id)
        if (systemPageHelpInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemPageHelpInstance.version > version) {
                    systemPageHelpInstance.errors.rejectValue('version', 'systemPageHelp.optimistic.locking.failure', 'Another user has updated this Page Help while you were editing')
                    render(view: 'edit', model: [systemPageHelpInstance: systemPageHelpInstance])
                    return
                }
            }

            def oldCode = systemPageHelpInstance.code
            def oldLocale = systemPageHelpInstance.locale
            systemPageHelpInstance.properties['code', 'locale', 'text'] = params
            def valid = !systemPageHelpInstance.hasErrors()
            if (valid && systemPageHelpInstance.locale != oldLocale && !localeIsValid(systemPageHelpInstance.locale)) {
                systemPageHelpInstance.errorMessage(field: 'locale', code: 'systemMessage.bad.locale', default: 'Invalid locale')
                valid = false
            }

            if (valid) valid = systemPageHelpInstance.saveThis()

            if (valid) {
                utilService.cacheService.clearThis('pageHelp')
                flash.message = 'systemPageHelp.updated'
                flash.args = [systemPageHelpInstance.toString()]
                flash.defaultMessage = "Page Help ${systemPageHelpInstance.toString()} updated"
                redirect(action: show, id: systemPageHelpInstance.id)
            } else {
                render(view: 'edit', model: [systemPageHelpInstance: systemPageHelpInstance])
            }
        } else {
            flash.message = 'systemPageHelp.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Page Help not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemPageHelpInstance = new SystemPageHelp()
        return [systemPageHelpInstance: systemPageHelpInstance]
    }

    def save = {
        def systemPageHelpInstance = new SystemPageHelp()
        systemPageHelpInstance.properties['code', 'locale', 'text'] = params
        def valid = !systemPageHelpInstance.hasErrors()
        if (valid && !localeIsValid(systemPageHelpInstance.locale)) {
            systemPageHelpInstance.errorMessage(field: 'locale', code: 'systemMessage.bad.locale', default: 'Invalid locale')
            valid = false
        }

        if (valid) valid = systemPageHelpInstance.saveThis()
        if (valid) {
            utilService.cacheService.clearThis('pageHelp')
            flash.message = 'systemPageHelp.created'
            flash.args = [systemPageHelpInstance.toString()]
            flash.defaultMessage = "Page Help ${systemPageHelpInstance.toString()} created"
            redirect(action: show, id: systemPageHelpInstance.id)
        } else {
            render(view: 'create', model: [systemPageHelpInstance: systemPageHelpInstance])
        }
    }

    def display = {
        def code = params.code
        def model = [:]
        if (code) model.lines = utilService.getPageHelp(code)
        [displayInstance: model]
    }

// --------------------------------------------- Support Methods ---------------------------------------------

    private localeIsValid(locale) {
        if (locale) {
            if (locale == '*') return true

            if (locale.length() == 2) {
                return (SystemLanguage.countByCode(locale) == 1)
            }

            if (locale.length() == 4) {
                return (SystemLanguage.countByCode(locale.substring(0, 2)) == 1 && SystemCountry.countByCode(locale.substring(2)) == 1)
            }
        }

        return false
    }
}