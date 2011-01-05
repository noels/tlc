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

import com.whollygrails.tlc.books.PaymentSchedule
import com.whollygrails.tlc.corp.Company
import it.sauronsoftware.cron4j.Predictor

class SystemPaymentScheduleController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', testing: 'POST', propagate: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'monthDayPattern', 'weekDayPattern'].contains(params.sort) ? params.sort : 'code'
        [systemPaymentScheduleInstanceList: SystemPaymentSchedule.selectList(), systemPaymentScheduleInstanceTotal: SystemPaymentSchedule.selectCount()]
    }

    def show = {
        def systemPaymentScheduleInstance = SystemPaymentSchedule.get(params.id)
        if (!systemPaymentScheduleInstance) {
            flash.message = 'systemPaymentSchedule.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Payment Schedule not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemPaymentScheduleInstance: systemPaymentScheduleInstance]
        }
    }

    def delete = {
        def systemPaymentScheduleInstance = SystemPaymentSchedule.get(params.id)
        if (systemPaymentScheduleInstance) {
            try {
                utilService.deleteWithMessages(systemPaymentScheduleInstance, [prefix: 'paymentSchedule.name', code: systemPaymentScheduleInstance.code])
                flash.message = 'systemPaymentSchedule.deleted'
                flash.args = [systemPaymentScheduleInstance.toString()]
                flash.defaultMessage = "System Payment Schedule ${systemPaymentScheduleInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemPaymentSchedule.not.deleted'
                flash.args = [systemPaymentScheduleInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Payment Schedule ${systemPaymentScheduleInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemPaymentSchedule.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Payment Schedule not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemPaymentScheduleInstance = SystemPaymentSchedule.get(params.id)
        if (!systemPaymentScheduleInstance) {
            flash.message = 'systemPaymentSchedule.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Payment Schedule not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemPaymentScheduleInstance: systemPaymentScheduleInstance]
        }
    }

    def update = {
        def systemPaymentScheduleInstance = SystemPaymentSchedule.get(params.id)
        if (systemPaymentScheduleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemPaymentScheduleInstance.version > version) {
                    systemPaymentScheduleInstance.errors.rejectValue('version', 'systemPaymentSchedule.optimistic.locking.failure', 'Another user has updated this System Payment Schedule while you were editing')
                    render(view: 'edit', model: [systemPaymentScheduleInstance: systemPaymentScheduleInstance])
                    return
                }
            }

            def oldCode = systemPaymentScheduleInstance.code
            systemPaymentScheduleInstance.properties['code', 'name', 'monthDayPattern', 'weekDayPattern'] = params
            if (utilService.saveWithMessages(systemPaymentScheduleInstance, [prefix: 'paymentSchedule.name', code: systemPaymentScheduleInstance.code, oldCode: oldCode, field: 'name'])) {
                flash.message = 'systemPaymentSchedule.updated'
                flash.args = [systemPaymentScheduleInstance.toString()]
                flash.defaultMessage = "System Payment Schedule ${systemPaymentScheduleInstance.toString()} updated"
                redirect(action: show, id: systemPaymentScheduleInstance.id)
            } else {
                render(view: 'edit', model: [systemPaymentScheduleInstance: systemPaymentScheduleInstance])
            }
        } else {
            flash.message = 'systemPaymentSchedule.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Payment Schedule not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemPaymentScheduleInstance = new SystemPaymentSchedule()
        return [systemPaymentScheduleInstance: systemPaymentScheduleInstance]
    }

    def save = {
        def systemPaymentScheduleInstance = new SystemPaymentSchedule()
        systemPaymentScheduleInstance.properties['code', 'name', 'monthDayPattern', 'weekDayPattern'] = params
        if (utilService.saveWithMessages(systemPaymentScheduleInstance, [prefix: 'paymentSchedule.name', code: systemPaymentScheduleInstance.code, field: 'name'])) {
            flash.message = 'systemPaymentSchedule.created'
            flash.args = [systemPaymentScheduleInstance.toString()]
            flash.defaultMessage = "System Payment Schedule ${systemPaymentScheduleInstance.toString()} created"
            redirect(action: show, id: systemPaymentScheduleInstance.id)
        } else {
            render(view: 'create', model: [systemPaymentScheduleInstance: systemPaymentScheduleInstance])
        }
    }

    def test = {
        [systemPaymentScheduleInstance: new SystemPaymentSchedule(), scheduleList: SystemPaymentSchedule.list(), predictions: []]
    }

    def testing = {
        def systemPaymentScheduleInstance = SystemPaymentSchedule.get(params.id)
        if (!systemPaymentScheduleInstance) {
            flash.message = 'systemPaymentSchedule.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Payment Schedule not found with id ${params.id}"
            redirect(action: list)
        } else {
            def predictor = new Predictor(systemPaymentScheduleInstance.pattern)
            def predictions = []
            for (int i = 0; i < 12; i++) predictions << predictor.nextMatchingDate()

            render(view: 'test', model: [systemPaymentScheduleInstance: systemPaymentScheduleInstance, scheduleList: SystemPaymentSchedule.list(), predictions: predictions])
        }
    }

    def propagate = {
        def count = 0
        def systemPaymentScheduleInstance = SystemPaymentSchedule.get(params.id)
        if (systemPaymentScheduleInstance) {
            def schedule
            def companies = Company.list()
            for (company in companies) {
                schedule = PaymentSchedule.findByCompanyAndCode(company, systemPaymentScheduleInstance.code)
                if (!schedule) {
                    schedule = new PaymentSchedule(company: company, code: systemPaymentScheduleInstance.code, name: systemPaymentScheduleInstance.name,
                            monthDayPattern: systemPaymentScheduleInstance.monthDayPattern, weekDayPattern: systemPaymentScheduleInstance.weekDayPattern)
                    if (schedule.saveThis()) count++
                }
            }
        }

        flash.message = 'systemPaymentSchedule.propagated'
        flash.args = ["${count}"]
        flash.defaultMessage = "${count} company/companies updated"
        redirect(action: list)
    }
}