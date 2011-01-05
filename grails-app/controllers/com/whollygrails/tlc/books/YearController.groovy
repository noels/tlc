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

class YearController {

    // Injected services
    def utilService
    def bookService

    // Security settings
    def activities = [default: 'actadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', process: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        if (!['code', 'validFrom', 'validTo'].contains(params.sort)) {
            params.sort = 'code'
            params.order = 'desc'
        }

        [yearInstanceList: Year.selectList(company: utilService.currentCompany()), yearInstanceTotal: Year.selectCount()]
    }

    def show = {
        def yearInstance = Year.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!yearInstance) {
            flash.message = 'year.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Year not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [yearInstance: yearInstance]
        }
    }

    def delete = {
        def yearInstance = Year.findByIdAndCompany(params.id, utilService.currentCompany())
        if (yearInstance) {
            if (Year.countByCompanyAndValidFromGreaterThan(utilService.currentCompany(), yearInstance.validTo) &&
                    Year.countByCompanyAndValidToLessThan(utilService.currentCompany(), yearInstance.validFrom)) {
                flash.message = 'year.delete.gap'
                flash.defaultMessage = 'Deleting this year would leave a gap in the date ranges.'
                redirect(action: show, id: params.id)
            } else if (Period.countByYearAndStatusInList(yearInstance, ['open', 'adjust'])) {
                flash.message = 'year.delete.status'
                flash.defaultMessage = 'You may not delete a year if any of its periods are open'
                redirect(action: show, id: params.id)
            } else {

                // If there are any transaction, do it as a background task after getting them to confirm it
                def pds = Period.findAllByYear(yearInstance)
                for (pd in pds) {
                    def bals = GeneralBalance.findAllByPeriod(pd)
                    for (bal in bals) {
                        if (GeneralTransaction.countByBalance(bal)) {
                            redirect(action: confirm, id: params.id)
                            return
                        }
                    }
                }

                try {
                    bookService.deleteYear(yearInstance)
                    flash.message = 'year.deleted'
                    flash.args = [yearInstance.toString()]
                    flash.defaultMessage = "Year ${yearInstance.toString()} deleted"
                    redirect(action: list)
                } catch (Exception e) {
                    flash.message = 'year.not.deleted'
                    flash.args = [yearInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Year ${yearInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            }
        } else {
            flash.message = 'year.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Year not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def yearInstance = Year.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!yearInstance) {
            flash.message = 'year.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Year not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [yearInstance: yearInstance]
        }
    }

    def update = {
        def yearInstance = Year.findByIdAndCompany(params.id, utilService.currentCompany())
        if (yearInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (yearInstance.version > version) {
                    yearInstance.errors.rejectValue('version', 'year.optimistic.locking.failure', 'Another user has updated this Year while you were editing')
                    render(view: 'edit', model: [yearInstance: yearInstance])
                    return
                }
            }

            def oldFrom = yearInstance.validFrom
            def oldTo = yearInstance.validTo
            yearInstance.properties['code', 'validFrom', 'validTo'] = params
            def valid = !yearInstance.hasErrors()
            if (valid && yearInstance.validFrom != oldFrom) {

                // If there used to be a preceding year, then changing the from date must create either a gap or an overlap
                if (Year.countByCompanyAndValidTo(utilService.currentCompany(), oldFrom - 1)) {
                    yearInstance.errorMessage(code: 'year.consecutive', field: 'validFrom', default: "The Valid From date must be one day after the preceding year's Valid To date")
                    valid = false
                }
            }

            if (valid && yearInstance.validTo != oldTo) {

                // If there used to be a following year, then changing the to date must create either a gap or an overlap
                if (Year.countByCompanyAndValidFrom(utilService.currentCompany(), oldTo + 1)) {
                    yearInstance.errorMessage(code: 'year.next', field: 'validTo', default: "The Valid To date must be one day before the following year's Valid From date")
                    valid = false
                }
            }

            if (valid) {
                Year.withTransaction {status ->
                    if (yearInstance.saveThis()) {
                        if (yearInstance.validFrom != oldFrom) {
                            def pds = Period.findAllByYear(yearInstance, [sort: 'validFrom', max: 1])
                            if (pds) {
                                if (pds[0].validTo >= yearInstance.validFrom) {
                                    pds[0].validFrom = yearInstance.validFrom
                                    if (!pds[0].saveThis()) {
                                        yearInstance.errorMessage(code: 'year.err.first.pd', field: 'validFrom', default: 'Unable to change the start date of the first period of the year')
                                        status.setRollbackOnly()
                                        valid = false
                                    }
                                } else {
                                    yearInstance.errorMessage(code: 'year.bad.first.pd', field: 'validFrom', default: 'The new Valid From date would invalidate the first period of the year')
                                    status.setRollbackOnly()
                                    valid = false
                                }
                            }
                        }

                        if (valid && yearInstance.validTo != oldTo) {
                            def pds = Period.findAllByYear(yearInstance, [sort: 'validFrom', order: 'desc', max: 1])
                            if (pds) {
                                if (pds[0].validFrom > yearInstance.validTo) {
                                    yearInstance.errorMessage(code: 'year.bad.last.pd', field: 'validTo', default: 'The new Valid To date would invalidate the last period of the year')
                                    status.setRollbackOnly()
                                    valid = false
                                } else if (pds[0].validTo > yearInstance.validTo || pds[0].validTo == oldTo) {
                                    pds[0].validTo = yearInstance.validTo
                                    if (!pds[0].saveThis()) {
                                        yearInstance.errorMessage(code: 'year.err.last.pd', field: 'validTo', default: 'Unable to change the end date of the last period of the year')
                                        status.setRollbackOnly()
                                        valid = false
                                    }
                                }
                            }
                        }
                    } else {
                        status.setRollbackOnly()
                        valid = false
                    }
                }
            }

            if (valid) {
                flash.message = 'year.updated'
                flash.args = [yearInstance.toString()]
                flash.defaultMessage = "Year ${yearInstance.toString()} updated"
                redirect(action: show, id: yearInstance.id)
            } else {
                render(view: 'edit', model: [yearInstance: yearInstance])
            }
        } else {
            flash.message = 'year.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Year not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def yearInstance = new Year()
        def flag = newYearIsProhibited()
        if (!flag) {
            yearInstance.company = utilService.currentCompany()   // Ensure correct company
            def priorYears = Year.findAllByCompany(utilService.currentCompany(), [sort: 'validTo', order: 'desc', max: 1])
            if (priorYears) {
                yearInstance.validFrom = priorYears[0].validTo + 1
                def cal = Calendar.getInstance()
                cal.setTime(yearInstance.validFrom)
                cal.add(Calendar.YEAR, 1)
                cal.add(Calendar.DATE, -1)
                yearInstance.validTo = cal.getTime()
                if (priorYears[0].code.isInteger()) {
                    def str = (priorYears[0].code.toInteger() + 1).toString()
                    if (str.length() <= 10 && Year.countByCompanyAndCode(utilService.currentCompany(), str) == 0) yearInstance.code = str
                }
            }
        }

        return [yearInstance: yearInstance, newYearIsProhibited: flag]
    }

    def save = {
        def yearInstance = new Year()
        def flag = newYearIsProhibited()
        if (!flag) {
            yearInstance.properties['code', 'validFrom', 'validTo'] = params
            yearInstance.company = utilService.currentCompany()   // Ensure correct company
            def valid = !yearInstance.hasErrors()
            def priorYears = Year.findAllByCompany(utilService.currentCompany(), [sort: 'validTo', order: 'desc', max: 1])
            if (priorYears && priorYears[0].validTo + 1 != yearInstance.validFrom) {
                yearInstance.errorMessage(code: 'year.consecutive', field: 'validFrom', default: "The Valid From date must be one day after the preceding year's Valid To date")
                valid = false
            }

            if (valid) valid = yearInstance.saveThis()
            if (valid) {
                flash.message = 'year.created'
                flash.args = [yearInstance.toString()]
                flash.defaultMessage = "Year ${yearInstance.toString()} created"
                redirect(action: show, id: yearInstance.id)
            } else {
                render(view: 'create', model: [yearInstance: yearInstance, newYearIsProhibited: flag])
            }
        } else {
            render(view: 'create', model: [yearInstance: yearInstance, newYearIsProhibited: flag])
        }
    }

    def confirm = {
        [yearInstance: Year.findByIdAndCompany(params.id, utilService.currentCompany())]
    }

    def process = {
        def yearInstance = Year.findByIdAndCompany(params.id, utilService.currentCompany())
        if (yearInstance) {
            def result = utilService.demandRunFromParams('delYear', [p_stringId: yearInstance.id.toString(), preferredStart: params.preferredStart])
            if (result instanceof String) {
                flash.message = result
                redirect(action: confirm, id: yearInstance.id)
                return
            }

            flash.message = 'queuedTask.demand.good'
            flash.args = [result]
            flash.defaultMessage = "The task has been placed in the queue for execution as task number ${result}"
        } else {
            flash.message = 'year.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Year not found with id ${params.id}"
        }

        redirect(action: list)
    }

    private newYearIsProhibited() {
        def years = Year.findAllByCompany(utilService.currentCompany(), [sort: 'validFrom', order: 'desc', max: 1])
        if (years) {
            def pd = Period.findByYearAndValidTo(years[0], years[0].validTo)
            if (!pd) return true
        }

        return false
    }
}