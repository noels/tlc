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

class CodeElementController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'actadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['elementNumber', 'name', 'dataType', 'dataLength'].contains(params.sort) ? params.sort : 'elementNumber'
        [codeElementInstanceList: CodeElement.selectList(securityCode: utilService.currentCompany().securityCode), codeElementInstanceTotal: CodeElement.selectCount()]
    }

    def show = {
        def codeElementInstance = CodeElement.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!codeElementInstance) {
            flash.message = 'codeElement.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Code Element not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [codeElementInstance: codeElementInstance, codeElementValueTotal: CodeElementValue.countByElement(codeElementInstance), codeElementInstanceTotal: CodeElement.countByCompany(utilService.currentCompany())]
        }
    }

    def delete = {
        def codeElementInstance = CodeElement.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (codeElementInstance) {
            try {
                codeElementInstance.delete(flush: true)
                flash.message = 'codeElement.deleted'
                flash.args = [codeElementInstance.toString()]
                flash.defaultMessage = "Code Element ${codeElementInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'codeElement.not.deleted'
                flash.args = [codeElementInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Code Element ${codeElementInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'codeElement.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Code Element not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def codeElementInstance = CodeElement.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!codeElementInstance) {
            flash.message = 'codeElement.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Code Element not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [codeElementInstance: codeElementInstance, codeElementValueTotal: CodeElementValue.countByElement(codeElementInstance), codeElementInstanceTotal: CodeElement.countByCompany(utilService.currentCompany())]
        }
    }

    def update = {
        def codeElementInstance = CodeElement.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (codeElementInstance) {
            def codeElementValueTotal = CodeElementValue.countByElement(codeElementInstance)
            if (params.version) {
                def version = params.version.toLong()
                if (codeElementInstance.version > version) {
                    codeElementInstance.errors.rejectValue('version', 'codeElement.optimistic.locking.failure', 'Another user has updated this Code Element while you were editing')
                    render(view: 'edit', model: [codeElementInstance: codeElementInstance, codeElementValueTotal: codeElementValueTotal, codeElementInstanceTotal: CodeElement.countByCompany(utilService.currentCompany())])
                    return
                }
            }

            def oldElementNumber = codeElementInstance.elementNumber
            def oldDataType = codeElementInstance.dataType
            def oldDataLength = codeElementInstance.dataLength
            codeElementInstance.properties['elementNumber', 'name', 'dataType', 'dataLength'] = params
            def valid = !codeElementInstance.hasErrors()
            if (valid && codeElementValueTotal > 0 && (codeElementInstance.dataType != oldDataType || codeElementInstance.dataLength != oldDataLength)) {
                codeElementInstance.errorMessage(code: 'codeElement.spec.changed', default: 'You may not change the specification of the element once values have been created for it')
                valid = false
            }

            def dependants
            if (valid && (codeElementInstance.elementNumber != oldElementNumber || codeElementInstance.dataType != oldDataType || codeElementInstance.dataLength != oldDataLength)) {
                dependants = ChartSection.findAll('from ChartSection where segment1 = :val or segment2 = :val or segment3 = :val or segment4 = :val or segment5 = :val or segment6 = :val or segment7 = :val or segment8 = :val',
                        [val: codeElementInstance])

                if (dependants) {
                    if (codeElementInstance.elementNumber != oldElementNumber) {
                        codeElementInstance.errorMessage(code: 'codeElement.pos.changed', default: 'You may not change the number of the element once chart sections are using it')
                        valid = false
                    } else {
                        for (section in dependants) {
                            if (ChartSectionRange.countBySection(section)) {
                                codeElementInstance.errorMessage(code: 'codeElement.bad.ranges', default: 'You may not change the specification of the element once chart section ranges are using it')
                                valid = false
                                break
                            }
                        }
                    }
                }
            }

            if (valid) {
                CodeElement.withTransaction {status ->
                    if (codeElementInstance.saveThis()) {
                        for (section in dependants) {

                            section.pattern = null
                            if (!section.saveThis()) {
                                codeElementInstance.errorMessage(code: 'codeElement.bad.sections', default: 'Unable to updated affected chart sections')
                                status.setRollbackOnly()
                                valid = false
                                break
                            }
                        }
                    } else {
                        status.setRollbackOnly()
                        valid = false
                    }
                }
            }

            if (valid) {
                flash.message = 'codeElement.updated'
                flash.args = [codeElementInstance.toString()]
                flash.defaultMessage = "Code Element ${codeElementInstance.toString()} updated"
                redirect(action: show, id: codeElementInstance.id)
            } else {
                render(view: 'edit', model: [codeElementInstance: codeElementInstance, codeElementValueTotal: codeElementValueTotal, codeElementInstanceTotal: CodeElement.countByCompany(utilService.currentCompany())])
            }
        } else {
            flash.message = 'codeElement.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Code Element not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def codeElementInstance = new CodeElement()
        codeElementInstance.company = utilService.currentCompany()   // Ensure correct company
        def used = [false, false, false, false, false, false, false, false]
        CodeElement.findAllByCompany(utilService.currentCompany()).each {
            used[it.elementNumber - 1] = true
        }

        for (int i = 0; i < used.size(); i++) {
            if (!used[i]) {
                codeElementInstance.elementNumber = (byte) (i + 1)
                break
            }
        }

        return [codeElementInstance: codeElementInstance, codeElementValueTotal: 0, codeElementInstanceTotal: CodeElement.countByCompany(utilService.currentCompany())]
    }

    def save = {
        def codeElementInstance = new CodeElement()
        codeElementInstance.properties['elementNumber', 'name', 'dataType', 'dataLength'] = params
        codeElementInstance.company = utilService.currentCompany()   // Ensure correct company
        if (!codeElementInstance.hasErrors() && codeElementInstance.saveThis()) {
            flash.message = 'codeElement.created'
            flash.args = [codeElementInstance.toString()]
            flash.defaultMessage = "Code Element ${codeElementInstance.toString()} created"
            redirect(action: show, id: codeElementInstance.id)
        } else {
            render(view: 'create', model: [codeElementInstance: codeElementInstance, codeElementValueTotal: 0, codeElementInstanceTotal: CodeElement.countByCompany(utilService.currentCompany())])
        }
    }
}