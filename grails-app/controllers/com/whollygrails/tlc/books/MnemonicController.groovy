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
package com.whollygrails.tlc.books

class MnemonicController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'login']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'name', 'accountCodeFragment'].contains(params.sort) ? params.sort : 'code'
        [mnemonicInstanceList: Mnemonic.selectList(where: 'x.user = ?', params: utilService.currentUser()), mnemonicInstanceTotal: Mnemonic.selectCount()]
    }

    def show = {
        def mnemonicInstance = Mnemonic.findByIdAndUser(params.id, utilService.currentUser())
        if (!mnemonicInstance) {
            flash.message = 'mnemonic.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Mnemonic not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [mnemonicInstance: mnemonicInstance]
        }
    }

    def delete = {
        def mnemonicInstance = Mnemonic.findByIdAndUser(params.id, utilService.currentUser())
        if (mnemonicInstance) {
            try {
                mnemonicInstance.delete(flush: true)
                utilService.cacheService.resetThis('mnemonic', 0L, utilService.currentUser().id.toString())
                flash.message = 'mnemonic.deleted'
                flash.args = [mnemonicInstance.toString()]
                flash.defaultMessage = "Mnemonic ${mnemonicInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'mnemonic.not.deleted'
                flash.args = [mnemonicInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Mnemonic ${mnemonicInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'mnemonic.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Mnemonic not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def mnemonicInstance = Mnemonic.findByIdAndUser(params.id, utilService.currentUser())
        if (!mnemonicInstance) {
            flash.message = 'mnemonic.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Mnemonic not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [mnemonicInstance: mnemonicInstance]
        }
    }

    def update = {
        def mnemonicInstance = Mnemonic.findByIdAndUser(params.id, utilService.currentUser())
        if (mnemonicInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (mnemonicInstance.version > version) {
                    mnemonicInstance.errors.rejectValue('version', 'mnemonic.optimistic.locking.failure', 'Another user has updated this Mnemonic while you were editing')
                    render(view: 'edit', model: [mnemonicInstance: mnemonicInstance])
                    return
                }
            }

            mnemonicInstance.properties['code', 'name', 'accountCodeFragment'] = params
            if (!mnemonicInstance.hasErrors() && mnemonicInstance.saveThis()) {
                utilService.cacheService.resetThis('mnemonic', 0L, utilService.currentUser().id.toString())
                flash.message = 'mnemonic.updated'
                flash.args = [mnemonicInstance.toString()]
                flash.defaultMessage = "Mnemonic ${mnemonicInstance.toString()} updated"
                redirect(action: show, id: mnemonicInstance.id)
            } else {
                render(view: 'edit', model: [mnemonicInstance: mnemonicInstance])
            }
        } else {
            flash.message = 'mnemonic.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Mnemonic not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def mnemonicInstance = new Mnemonic()
        mnemonicInstance.user = utilService.currentUser()   // Ensure correct parent
        return [mnemonicInstance: mnemonicInstance]
    }

    def save = {
        def mnemonicInstance = new Mnemonic()
        mnemonicInstance.properties['code', 'name', 'accountCodeFragment'] = params
        mnemonicInstance.user = utilService.currentUser()   // Ensure correct parent
        if (!mnemonicInstance.hasErrors() && mnemonicInstance.saveThis()) {
            utilService.cacheService.resetThis('mnemonic', 0L, utilService.currentUser().id.toString())
            flash.message = 'mnemonic.created'
            flash.args = [mnemonicInstance.toString()]
            flash.defaultMessage = "Mnemonic ${mnemonicInstance.toString()} created"
            redirect(action: show, id: mnemonicInstance.id)
        } else {
            render(view: 'create', model: [mnemonicInstance: mnemonicInstance])
        }
    }
}