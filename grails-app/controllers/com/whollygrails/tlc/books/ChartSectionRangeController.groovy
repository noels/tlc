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

class ChartSectionRangeController {

    // Injected services
    def utilService
    def bookService

    // Security settings
    def activities = [default: 'actadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['type', 'rangeFrom', 'rangeTo', 'comment', 'messageText'].contains(params.sort) ? params.sort : 'id'
        def ddSource = utilService.source('chartSection.list')
        [chartSectionRangeInstanceList: ChartSectionRange.selectList(securityCode: utilService.currentCompany().securityCode), chartSectionRangeInstanceTotal: ChartSectionRange.selectCount(), ddSource: ddSource]
    }

    def show = {
        def chartSectionRangeInstance = ChartSectionRange.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!chartSectionRangeInstance) {
            flash.message = 'chartSectionRange.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Chart Section Range not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [chartSectionRangeInstance: chartSectionRangeInstance]
        }
    }

    def delete = {
        def chartSectionRangeInstance = ChartSectionRange.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (chartSectionRangeInstance) {
            def valid = true
            ChartSectionRange.withTransaction {status ->
                try {
                    chartSectionRangeInstance.delete(flush: true)
                    utilService.cacheService.resetThis('ranges', chartSectionRangeInstance.securityCode, chartSectionRangeInstance.section.toString())
                    if (!bookService.verifyRangeTests(chartSectionRangeInstance.section, chartSectionRangeInstance)) {
                        status.setRollbackOnly()
                        valid = false
                    }
                } catch (Exception e) {
                    flash.message = 'chartSectionRange.not.deleted'
                    flash.args = [chartSectionRangeInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Chart Section Range ${chartSectionRangeInstance.toString()} could not be deleted (${e.class.simpleName})"
                    valid = false
                }
            }

            if (valid) {
                flash.message = 'chartSectionRange.deleted'
                flash.args = [chartSectionRangeInstance.toString()]
                flash.defaultMessage = "Chart Section Range ${chartSectionRangeInstance.toString()} deleted"
                redirect(action: list)
            } else {
                // Need to update the cache if something went wrong
                utilService.cacheService.resetThis('ranges', chartSectionRangeInstance.securityCode, chartSectionRangeInstance.section.toString())
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'chartSectionRange.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Chart Section Range not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def chartSectionRangeInstance = ChartSectionRange.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!chartSectionRangeInstance) {
            flash.message = 'chartSectionRange.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Chart Section Range not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [chartSectionRangeInstance: chartSectionRangeInstance]
        }
    }

    def update = {
        def chartSectionRangeInstance = ChartSectionRange.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (chartSectionRangeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (chartSectionRangeInstance.version > version) {
                    chartSectionRangeInstance.errors.rejectValue('version', 'chartSectionRange.optimistic.locking.failure', 'Another user has updated this Chart Section Range while you were editing')
                    render(view: 'edit', model: [chartSectionRangeInstance: chartSectionRangeInstance])
                    return
                }
            }

            chartSectionRangeInstance.properties['type', 'rangeFrom', 'rangeTo', 'comment', 'messageText'] = params
            fixRanges(chartSectionRangeInstance)
            def valid = !chartSectionRangeInstance.hasErrors()
            if (valid) {
                ChartSectionRange.withTransaction {status ->
                    if (chartSectionRangeInstance.saveThis()) {
                        utilService.cacheService.resetThis('ranges', chartSectionRangeInstance.securityCode, chartSectionRangeInstance.section.toString())
                        if (bookService.defaultsAreValid(chartSectionRangeInstance.section)) {
                            if (!bookService.verifyRangeTests(chartSectionRangeInstance.section, chartSectionRangeInstance)) {
                                status.setRollbackOnly()
                                valid = false
                            }
                        } else {
                            chartSectionRangeInstance.errorMessage(code: 'chartSectionRange.defaults.bad', default: 'The ranges invalidate one or more of the defaults for this section')
                            status.setRollbackOnly()
                            valid = false
                        }
                    } else {
                        status.setRollbackOnly()
                        valid = false
                    }
                }
            }

            if (valid) {
                flash.message = 'chartSectionRange.updated'
                flash.args = [chartSectionRangeInstance.toString()]
                flash.defaultMessage = "Chart Section Range ${chartSectionRangeInstance.toString()} updated"
                redirect(action: show, id: chartSectionRangeInstance.id)
            } else {
                // Need to update the cache if something went wrong
                utilService.cacheService.resetThis('ranges', chartSectionRangeInstance.securityCode, chartSectionRangeInstance.section.toString())
                render(view: 'edit', model: [chartSectionRangeInstance: chartSectionRangeInstance])
            }
        } else {
            flash.message = 'chartSectionRange.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Chart Section Range not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def chartSectionRangeInstance = new ChartSectionRange()
        chartSectionRangeInstance.section = utilService.reSource('chartSection.list')   // Ensure correct parent
        if (ChartSectionRange.countBySection(chartSectionRangeInstance.section) > 0) chartSectionRangeInstance.type = 'exclude'
        return [chartSectionRangeInstance: chartSectionRangeInstance]
    }

    def save = {
        def chartSectionRangeInstance = new ChartSectionRange()
        chartSectionRangeInstance.properties['type', 'rangeFrom', 'rangeTo', 'comment', 'messageText'] = params
        chartSectionRangeInstance.section = utilService.reSource('chartSection.list')   // Ensure correct parent
        fixRanges(chartSectionRangeInstance)
        def valid = !chartSectionRangeInstance.hasErrors()
        if (valid) {
            ChartSectionRange.withTransaction {status ->
                if (chartSectionRangeInstance.saveThis()) {
                    utilService.cacheService.resetThis('ranges', chartSectionRangeInstance.securityCode, chartSectionRangeInstance.section.toString())
                    if (bookService.defaultsAreValid(chartSectionRangeInstance.section)) {
                        if (!bookService.verifyRangeTests(chartSectionRangeInstance.section, chartSectionRangeInstance)) {
                            status.setRollbackOnly()
                            valid = false
                        }
                    } else {
                        chartSectionRangeInstance.errorMessage(code: 'chartSectionRange.defaults.bad', default: 'The ranges invalidate one or more of the defaults for this section')
                        status.setRollbackOnly()
                        valid = false
                    }
                } else {
                    status.setRollbackOnly()
                    valid = false
                }
            }
        }

        if (valid) {
            flash.message = 'chartSectionRange.created'
            flash.args = [chartSectionRangeInstance.toString()]
            flash.defaultMessage = "Chart Section Range ${chartSectionRangeInstance.toString()} created"
            redirect(action: show, id: chartSectionRangeInstance.id)
        } else {
            // Need to update the cache if something went wrong
            utilService.cacheService.resetThis('ranges', chartSectionRangeInstance.securityCode, chartSectionRangeInstance.section.toString())
            render(view: 'create', model: [chartSectionRangeInstance: chartSectionRangeInstance])
        }
    }

    private fixRanges(range) {
        range.rangeFrom = bookService.fixCase(range.rangeFrom)
        range.rangeTo = bookService.fixCase(range.rangeTo)
    }
}