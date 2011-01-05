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

import com.whollygrails.tlc.sys.UtilService

class ExchangeRateController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        if (!['validFrom', 'rate'].contains(params.sort)) {
            params.sort = 'validFrom'
            params.order = 'desc'
        }

        def ddSource = utilService.source('exchangeCurrency.list')
        [exchangeRateInstanceList: ExchangeRate.selectList(securityCode: utilService.currentCompany().securityCode), exchangeRateInstanceTotal: ExchangeRate.selectCount(), ddSource: ddSource]
    }

    def show = {
        def exchangeRateInstance = ExchangeRate.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!exchangeRateInstance) {
            flash.message = 'exchangeRate.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Exchange Rate not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [exchangeRateInstance: exchangeRateInstance]
        }
    }

    def delete = {
        def exchangeRateInstance = ExchangeRate.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (exchangeRateInstance) {
            if (exchangeRateInstance.currency.code == UtilService.BASE_CURRENCY_CODE && ExchangeRate.countByCurrency(exchangeRateInstance.currency) == 1) {
                flash.message = 'exchangeRate.base.delete'
                flash.defaultMessage = 'This is the fixed rate for the system base currency and cannot be deleted'
                redirect(action: show, id: params.id)
            } else {
                try {
                    exchangeRateInstance.delete(flush: true)
                    utilService.cacheService.resetThis('exchangeRate', exchangeRateInstance.securityCode, exchangeRateInstance.currency.code)
                    flash.message = 'exchangeRate.deleted'
                    flash.args = [exchangeRateInstance.toString()]
                    flash.defaultMessage = "Exchange Rate ${exchangeRateInstance.toString()} deleted"
                    redirect(action: list)
                } catch (Exception e) {
                    flash.message = 'exchangeRate.not.deleted'
                    flash.args = [exchangeRateInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Exchange Rate ${exchangeRateInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            }
        } else {
            flash.message = 'exchangeRate.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Exchange Rate not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def exchangeRateInstance = ExchangeRate.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!exchangeRateInstance) {
            flash.message = 'exchangeRate.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Exchange Rate not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [exchangeRateInstance: exchangeRateInstance]
        }
    }

    def update = {
        def exchangeRateInstance = ExchangeRate.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (exchangeRateInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (exchangeRateInstance.version > version) {
                    exchangeRateInstance.errors.rejectValue('version', 'exchangeRate.optimistic.locking.failure', 'Another user has updated this Exchange Rate while you were editing')
                    render(view: 'edit', model: [exchangeRateInstance: exchangeRateInstance])
                    return
                }
            }

            exchangeRateInstance.properties['validFrom', 'rate'] = params
            def valid = !exchangeRateInstance.hasErrors()
            if (valid && exchangeRateInstance.currency.code == UtilService.BASE_CURRENCY_CODE && exchangeRateInstance.rate != 1.0) {
                exchangeRateInstance.errorMessage(field: 'rate', code: 'exchangeRate.base.rate', default: 'This is the system base currency and must have a fixed exchange rate of 1.0')
                valid = false
            }

            if (valid) valid = exchangeRateInstance.saveThis()
            if (valid) {
                utilService.cacheService.resetThis('exchangeRate', exchangeRateInstance.securityCode, exchangeRateInstance.currency.code)
                flash.message = 'exchangeRate.updated'
                flash.args = [exchangeRateInstance.toString()]
                flash.defaultMessage = "Exchange Rate ${exchangeRateInstance.toString()} updated"
                redirect(action: show, id: exchangeRateInstance.id)
            } else {
                render(view: 'edit', model: [exchangeRateInstance: exchangeRateInstance])
            }
        } else {
            flash.message = 'exchangeRate.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Exchange Rate not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def exchangeRateInstance = new ExchangeRate()
        exchangeRateInstance.currency = utilService.reSource('exchangeCurrency.list')   // Ensure correct parent
        exchangeRateInstance.validFrom = utilService.fixDate()
        return [exchangeRateInstance: exchangeRateInstance]
    }

    def save = {
        def exchangeRateInstance = new ExchangeRate()
        exchangeRateInstance.properties['validFrom', 'rate'] = params
        exchangeRateInstance.currency = utilService.reSource('exchangeCurrency.list')   // Ensure correct parent
        def valid = !exchangeRateInstance.hasErrors()
        if (valid && exchangeRateInstance.currency.code == UtilService.BASE_CURRENCY_CODE && exchangeRateInstance.rate != 1.0) {
            exchangeRateInstance.errorMessage(field: 'rate', code: 'exchangeRate.base.rate', default: 'This is the system base currency and must have a fixed exchange rate of 1.0')
            valid = false
        }

        if (valid) valid = exchangeRateInstance.saveThis()
        if (valid) {
            utilService.cacheService.resetThis('exchangeRate', exchangeRateInstance.securityCode, exchangeRateInstance.currency.code)
            flash.message = 'exchangeRate.created'
            flash.args = [exchangeRateInstance.toString()]
            flash.defaultMessage = "Exchange Rate ${exchangeRateInstance.toString()} created"
            redirect(action: show, id: exchangeRateInstance.id)
        } else {
            render(view: 'create', model: [exchangeRateInstance: exchangeRateInstance])
        }
    }
}