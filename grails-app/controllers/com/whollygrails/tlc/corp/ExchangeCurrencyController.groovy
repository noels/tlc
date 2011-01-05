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

import com.whollygrails.tlc.obj.ExchangeRateTest
import com.whollygrails.tlc.sys.SystemCurrency
import com.whollygrails.tlc.sys.UtilService

class ExchangeCurrencyController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', importing: 'POST', updateRate: 'POST', updateRates: 'POST', testing: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'decimals', 'autoUpdate'].contains(params.sort) ? params.sort : 'code'
        def today = utilService.fixDate()
        def exchangeCurrencyInstanceList = ExchangeCurrency.selectList(company: utilService.currentCompany())
        for (currency in exchangeCurrencyInstanceList) {
            def rates = ExchangeRate.findAllByCurrencyAndValidFromLessThanEquals(currency, today, [sort: 'validFrom', order: 'desc', max: 1])
            if (rates) {
                currency.currentRateDate = rates[0].validFrom
                currency.currentRateValue = rates[0].rate
                currency.currentRateUpdatable = (currency.code != UtilService.BASE_CURRENCY_CODE && currency.currentRateDate < today)
            } else if (currency.code != UtilService.BASE_CURRENCY_CODE) {
                currency.currentRateUpdatable = true
            }
        }

        def baseCurrencies = []
        baseCurrencies << message(code: "currency.name.${UtilService.BASE_CURRENCY_CODE}", default: UtilService.BASE_CURRENCY_CODE)
        def companyCurrency = utilService.companyCurrency()
        baseCurrencies << message(code: "currency.name.${companyCurrency?.code}", default: companyCurrency?.code)

        [exchangeCurrencyInstanceList: exchangeCurrencyInstanceList, exchangeCurrencyInstanceTotal: ExchangeCurrency.selectCount(), baseCurrencies: baseCurrencies]
    }

    def show = {
        def exchangeCurrencyInstance = ExchangeCurrency.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!exchangeCurrencyInstance) {
            flash.message = 'exchangeCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Currency not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [exchangeCurrencyInstance: exchangeCurrencyInstance]
        }
    }

    def delete = {
        def exchangeCurrencyInstance = ExchangeCurrency.findByIdAndCompany(params.id, utilService.currentCompany())
        if (exchangeCurrencyInstance) {
            if (exchangeCurrencyInstance.code == UtilService.BASE_CURRENCY_CODE) {
                flash.message = 'exchangeCurrency.base.delete'
                flash.defaultMessage = 'This is the system base currency and cannot be deleted'
                redirect(action: show, id: params.id)
            } else if (exchangeCurrencyInstance.companyCurrency) {
                flash.message = 'exchangeCurrency.corp.delete'
                flash.defaultMessage = 'This is the company currency and cannot be deleted'
                redirect(action: show, id: params.id)
            } else {
                try {
                    utilService.deleteWithMessages(exchangeCurrencyInstance, [prefix: 'currency.name', code: exchangeCurrencyInstance.code])
                    utilService.cacheService.resetThis('exchangeRate', exchangeCurrencyInstance.securityCode, exchangeCurrencyInstance.code)
                    flash.message = 'exchangeCurrency.deleted'
                    flash.args = [exchangeCurrencyInstance.toString()]
                    flash.defaultMessage = "Currency ${exchangeCurrencyInstance.toString()} deleted"
                    redirect(action: list)
                } catch (Exception e) {
                    flash.message = 'exchangeCurrency.not.deleted'
                    flash.args = [exchangeCurrencyInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Currency ${exchangeCurrencyInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            }
        } else {
            flash.message = 'exchangeCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Currency not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def exchangeCurrencyInstance = ExchangeCurrency.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!exchangeCurrencyInstance) {
            flash.message = 'exchangeCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Currency not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [exchangeCurrencyInstance: exchangeCurrencyInstance]
        }
    }

    def update = {
        def exchangeCurrencyInstance = ExchangeCurrency.findByIdAndCompany(params.id, utilService.currentCompany())
        if (exchangeCurrencyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (exchangeCurrencyInstance.version > version) {
                    exchangeCurrencyInstance.errors.rejectValue('version', 'exchangeCurrency.optimistic.locking.failure', 'Another user has updated this Currency while you were editing')
                    render(view: 'edit', model: [exchangeCurrencyInstance: exchangeCurrencyInstance])
                    return
                }
            }

            def oldCode = exchangeCurrencyInstance.code
            exchangeCurrencyInstance.properties['code', 'name', 'decimals', 'autoUpdate'] = params
            if (oldCode != exchangeCurrencyInstance.code && oldCode == UtilService.BASE_CURRENCY_CODE) {
                exchangeCurrencyInstance.errorMessage(field: 'code', code: 'exchangeCurrency.base.change', default: 'This is the system base currency and cannot have its code changed')
                render(view: 'edit', model: [exchangeCurrencyInstance: exchangeCurrencyInstance])
            } else {
                if (utilService.saveWithMessages(exchangeCurrencyInstance, [prefix: 'currency.name', code: exchangeCurrencyInstance.code, oldCode: oldCode, field: 'name'])) {
                    utilService.cacheService.resetThis('exchangeRate', exchangeCurrencyInstance.securityCode, exchangeCurrencyInstance.code)
                    flash.message = 'exchangeCurrency.updated'
                    flash.args = [exchangeCurrencyInstance.toString()]
                    flash.defaultMessage = "Currency ${exchangeCurrencyInstance.toString()} updated"
                    redirect(action: show, id: exchangeCurrencyInstance.id)
                } else {
                    render(view: 'edit', model: [exchangeCurrencyInstance: exchangeCurrencyInstance])
                }
            }
        } else {
            flash.message = 'exchangeCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Currency not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def exchangeCurrencyInstance = new ExchangeCurrency()
        exchangeCurrencyInstance.company = utilService.currentCompany()   // Ensure correct company
        return [exchangeCurrencyInstance: exchangeCurrencyInstance]
    }

    def save = {
        def exchangeCurrencyInstance = new ExchangeCurrency()
        exchangeCurrencyInstance.properties['code', 'name', 'decimals', 'autoUpdate'] = params
        exchangeCurrencyInstance.company = utilService.currentCompany()   // Ensure correct company
        if (utilService.saveWithMessages(exchangeCurrencyInstance, [prefix: 'currency.name', code: exchangeCurrencyInstance.code, field: 'name'])) {
            utilService.cacheService.resetThis('exchangeRate', exchangeCurrencyInstance.securityCode, exchangeCurrencyInstance.code)
            flash.message = 'exchangeCurrency.created'
            flash.args = [exchangeCurrencyInstance.toString()]
            flash.defaultMessage = "Currency ${exchangeCurrencyInstance.toString()} created"
            redirect(action: show, id: exchangeCurrencyInstance.id)
        } else {
            render(view: 'create', model: [exchangeCurrencyInstance: exchangeCurrencyInstance])
        }
    }

    def imports = {}

    def importing = {
        def systemCurrencyInstance = SystemCurrency.get(params.systemCurrency.id)
        if (systemCurrencyInstance) {
            def exchangeCurrencyInstance = new ExchangeCurrency()
            exchangeCurrencyInstance.company = utilService.currentCompany()
            exchangeCurrencyInstance.code = systemCurrencyInstance.code
            exchangeCurrencyInstance.name = systemCurrencyInstance.name
            exchangeCurrencyInstance.decimals = systemCurrencyInstance.decimals
            exchangeCurrencyInstance.autoUpdate = (systemCurrencyInstance.autoUpdate && systemCurrencyInstance.code != UtilService.BASE_CURRENCY_CODE)
            if (utilService.saveWithMessages(exchangeCurrencyInstance, [prefix: 'currency.name', code: exchangeCurrencyInstance.code, field: 'name'])) {
                utilService.cacheService.resetThis('exchangeRate', exchangeCurrencyInstance.securityCode, exchangeCurrencyInstance.code)
                flash.message = 'exchangeCurrency.created'
                flash.args = [exchangeCurrencyInstance.toString()]
                flash.defaultMessage = "Currency ${exchangeCurrencyInstance.toString()} created"
                redirect(action: show, id: exchangeCurrencyInstance.id)
            } else {
                flash.message = 'exchangeCurrency.imports.error'
                flash.args = [exchangeCurrencyInstance.code]
                flash.defaultMessage = "Unable to import currency ${exchangeCurrencyInstance.code}. A currency with the same code may already exist in your company."
                render(view: 'imports')
            }
        } else {
            flash.message = 'systemCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Currency not found with id ${params.id}"
            render(view: 'imports')
        }
    }

    def updateRate = {
        def exchangeCurrencyInstance = ExchangeCurrency.findByIdAndCompany(params.id, utilService.currentCompany())
        if (exchangeCurrencyInstance) {
            if (exchangeCurrencyInstance.code != UtilService.BASE_CURRENCY_CODE) {
                def rate = utilService.readURL("http://finance.yahoo.com/d/quotes.csv?s=${utilService.BASE_CURRENCY_CODE}${exchangeCurrencyInstance.code}=X&f=b")
                if (rate) {
                    try {
                        rate = utilService.round(new BigDecimal(rate), 6)
                    } catch (NumberFormatException nfe) {
                        rate = null
                    }
                }

                if (rate) {
                    def exchangeRateInstance = new ExchangeRate()
                    exchangeRateInstance.currency = exchangeCurrencyInstance
                    exchangeRateInstance.validFrom = utilService.fixDate()
                    exchangeRateInstance.rate = rate
                    if (exchangeRateInstance.saveThis()) {
                        utilService.cacheService.resetThis('exchangeRate', exchangeCurrencyInstance.securityCode, exchangeCurrencyInstance.code)
                        flash.message = 'exchangeRate.good.update'
                        flash.args = [exchangeCurrencyInstance.code]
                        flash.defaultMessage = "The exchange rate for currency ${exchangeCurrencyInstance.code} was successfully updated"
                        redirect(action: list)
                    } else {
                        flash.message = 'exchangeRate.bad.update'
                        flash.args = [exchangeCurrencyInstance.code]
                        flash.defaultMessage = "The new exchange rate record for currency ${exchangeCurrencyInstance.code} could not be saved"
                        redirect(action: list)
                    }
                } else {
                    flash.message = 'exchangeRate.no.update'
                    flash.args = [exchangeCurrencyInstance.code]
                    flash.defaultMessage = "A valid exchange rate for currency ${exchangeCurrencyInstance.code} could not be retrieved from the Internet"
                    redirect(action: list)
                }
            } else {
                flash.message = 'exchangeRate.base.rate'
                flash.defaultMessage = 'This is the system base currency and must have a fixed exchange rate of 1.0'
                redirect(action: list)
            }
        } else {
            flash.message = 'systemCurrency.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Currency not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def updateRates = {
        def currencies = ExchangeCurrency.findAllByCompany(utilService.currentCompany(), [cache: true])
        def updated = 0
        def notUpdated = 0
        def today = utilService.fixDate()
        for (currency in currencies) {
            if (currency.code == UtilService.BASE_CURRENCY_CODE) {
                notUpdated++
            } else {
                def exchangeRate = ExchangeRate.findByCurrencyAndValidFrom(currency, today)
                if (exchangeRate) {
                    notUpdated++
                } else {
                    def rate = utilService.readURL("http://finance.yahoo.com/d/quotes.csv?s=${utilService.BASE_CURRENCY_CODE}${currency.code}=X&f=b")
                    if (rate) {
                        try {
                            rate = utilService.round(new BigDecimal(rate), 6)
                        } catch (NumberFormatException nfe) {
                            rate = null
                        }
                    }

                    if (rate) {
                        exchangeRate = new ExchangeRate()
                        exchangeRate.currency = currency
                        exchangeRate.validFrom = today
                        exchangeRate.rate = rate
                        if (exchangeRate.saveThis()) {
                            utilService.cacheService.resetThis('exchangeRate', currency.securityCode, currency.code)
                            updated++
                        } else {
                            notUpdated++
                        }
                    } else {
                        notUpdated++
                    }
                }
            }
        }

        flash.message = 'exchangeRate.all.message'
        flash.args = [updated, notUpdated]
        flash.defaultMessage = "${updated} rate(s) were updated. ${notUpdated} rate(s) were not updated."
        redirect(action: list)
    }

    def test = {ExchangeRateTest testInstance ->
        def currencyList = ExchangeCurrency.findAllByCompany(utilService.currentCompany(), [cache: true])
        return [testInstance: testInstance, currencyList: currencyList]
    }

    def testing = {ExchangeRateTest testInstance ->
        if (!testInstance.hasErrors()) {
            if (testInstance.value == null) testInstance.value = 0
            testInstance.value = utilService.round(testInstance.value, testInstance.fromCurrency.decimals)
            if (testInstance.conversionDate == null) testInstance.conversionDate = new Date()
            testInstance.conversionDate = utilService.fixDate(testInstance.conversionDate)
            def rslt = utilService.convertCurrency(testInstance.fromCurrency, testInstance.toCurrency, testInstance.value, testInstance.conversionDate)
            if (rslt != null) {
                testInstance.result = utilService.format(rslt, testInstance.toCurrency.decimals)
            } else {
                testInstance.result = message(code: 'exchangeRate.test.invalid',
                        args: [testInstance.fromCurrency.code, testInstance.toCurrency.code, utilService.format(testInstance.conversionDate, 1)],
                        default: "No conversion between ${testInstance.fromCurrency.code} and ${testInstance.toCurrency.code} currencies on ${utilService.format(testInstance.conversionDate, 1)} is available")
            }
        }

        def currencyList = ExchangeCurrency.findAllByCompany(utilService.currentCompany(), [cache: true])
        render(view: 'test', model: [testInstance: testInstance, currencyList: currencyList])
    }
}