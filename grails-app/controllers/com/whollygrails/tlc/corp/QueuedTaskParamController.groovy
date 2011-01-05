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

class QueuedTaskParamController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin', queueList: 'sysadmin', queueShow: 'sysadmin', queueEdit: 'sysadmin', queueUpdate: 'sysadmin',
            usrList: 'attached', usrShow: 'attached', usrEdit: 'attached', usrUpdate: 'attached']

    // List of actions with specific request types
    static allowedMethods = [update: 'POST', queueUpdate: 'POST', usrUpdate: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.sort = ['value'].contains(params.sort) ? params.sort : 'id'
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def ddSource = utilService.source('queuedTask.list')
        [queuedTaskParamInstanceList: QueuedTaskParam.selectList(securityCode: utilService.currentCompany().securityCode), queuedTaskParamInstanceTotal: QueuedTaskParam.selectCount(), ddSource: ddSource]
    }

    def show = {
        def queuedTaskParamInstance = QueuedTaskParam.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!queuedTaskParamInstance) {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [queuedTaskParamInstance: queuedTaskParamInstance]
        }
    }

    def edit = {
        def queuedTaskParamInstance = QueuedTaskParam.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!queuedTaskParamInstance) {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: list)
        } else if (queuedTaskParamInstance.queued.currentStatus != 'waiting') {
            flash.message = 'queuedTaskParam.wait.edit'
            flash.defaultMessage = 'Only waiting task parameters can be edited'
            redirect(action: list)
        } else {
            return [queuedTaskParamInstance: queuedTaskParamInstance]
        }
    }

    def update = {
        def queuedTaskParamInstance = QueuedTaskParam.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (queuedTaskParamInstance) {
            if (queuedTaskParamInstance.queued.currentStatus != 'waiting') {
                flash.message = 'queuedTaskParam.wait.edit'
                flash.defaultMessage = 'Only waiting task parameters can be edited'
                redirect(action: list)
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (queuedTaskParamInstance.version > version) {
                    queuedTaskParamInstance.errors.rejectValue('version', 'queuedTaskParam.optimistic.locking.failure', 'Another user has updated this Queued Task Parameter while you were editing')
                    render(view: 'edit', model: [queuedTaskParamInstance: queuedTaskParamInstance])
                    return
                }
            }

            queuedTaskParamInstance.properties['value'] = params
            if (!queuedTaskParamInstance.hasErrors() && queuedTaskParamInstance.saveThis()) {
                flash.message = 'queuedTaskParam.updated'
                flash.args = [queuedTaskParamInstance.toString()]
                flash.defaultMessage = "Queued Task Parameter ${queuedTaskParamInstance.toString()} updated"
                redirect(action: show, id: queuedTaskParamInstance.id)
            } else {
                render(view: 'edit', model: [queuedTaskParamInstance: queuedTaskParamInstance])
            }
        } else {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def queueList = {
        params.sort = ['value'].contains(params.sort) ? params.sort : 'id'
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def ddSource = utilService.source('queuedTask.queue')
        [queuedTaskParamInstanceList: QueuedTaskParam.selectList(), queuedTaskParamInstanceTotal: QueuedTaskParam.selectCount(), ddSource: ddSource]
    }

    def queueShow = {
        def queuedTaskParamInstance = QueuedTaskParam.get(params.id)

        if (!queuedTaskParamInstance) {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: queueList)
        } else {
            return [queuedTaskParamInstance: queuedTaskParamInstance]
        }
    }

    def queueEdit = {
        def queuedTaskParamInstance = QueuedTaskParam.get(params.id)

        if (!queuedTaskParamInstance) {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: queueList)
        } else if (queuedTaskParamInstance.queued.currentStatus != 'waiting') {
            flash.message = 'queuedTaskParam.wait.edit'
            flash.defaultMessage = 'Only waiting task parameters can be edited'
            redirect(action: queueList)
        } else {
            return [queuedTaskParamInstance: queuedTaskParamInstance]
        }
    }

    def queueUpdate = {
        def queuedTaskParamInstance = QueuedTaskParam.get(params.id)
        if (queuedTaskParamInstance) {
            if (queuedTaskParamInstance.queued.currentStatus != 'waiting') {
                flash.message = 'queuedTaskParam.wait.edit'
                flash.defaultMessage = 'Only waiting task parameters can be edited'
                redirect(action: queueList)
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (queuedTaskParamInstance.version > version) {
                    queuedTaskParamInstance.errors.rejectValue('version', 'queuedTaskParam.optimistic.locking.failure', 'Another user has updated this Queued Task Parameter while you were editing')
                    render(view: 'queueEdit', model: [queuedTaskParamInstance: queuedTaskParamInstance])
                    return
                }
            }

            queuedTaskParamInstance.properties['value'] = params
            if (!queuedTaskParamInstance.hasErrors() && queuedTaskParamInstance.saveThis()) {
                flash.message = 'queuedTaskParam.updated'
                flash.args = [queuedTaskParamInstance.toString()]
                flash.defaultMessage = "Queued Task Parameter ${queuedTaskParamInstance.toString()} updated"
                redirect(action: queueShow, id: queuedTaskParamInstance.id)
            } else {
                render(view: 'queueEdit', model: [queuedTaskParamInstance: queuedTaskParamInstance])
            }
        } else {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: queueList)
        }
    }

    def usrList = {
        params.sort = ['value'].contains(params.sort) ? params.sort : 'id'
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def ddSource = utilService.source('queuedTask.usrList')
        def list = QueuedTaskParam.selectList(securityCode: utilService.currentCompany().securityCode, where: 'x.queued.user = ?', params: utilService.currentUser())
        def total = QueuedTaskParam.selectCount()
        [queuedTaskParamInstanceList: list, queuedTaskParamInstanceTotal: total, ddSource: ddSource]
    }

    def usrShow = {
        def queuedTaskParamInstance = QueuedTaskParam.find('from QueuedTaskParam as x where x.id = ? and x.queued.user = ? and x.securityCode = ?',
                [params.id?.toLong(), utilService.currentUser(), utilService.currentCompany().securityCode])

        if (!queuedTaskParamInstance) {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: usrList)
        } else {
            return [queuedTaskParamInstance: queuedTaskParamInstance]
        }
    }

    def usrEdit = {
        def queuedTaskParamInstance = QueuedTaskParam.find('from QueuedTaskParam as x where x.id = ? and x.queued.user = ? and x.securityCode = ?',
                [params.id?.toLong(), utilService.currentUser(), utilService.currentCompany().securityCode])

        if (!queuedTaskParamInstance) {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: usrList)
        } else if (queuedTaskParamInstance.queued.currentStatus != 'waiting') {
            flash.message = 'queuedTaskParam.wait.edit'
            flash.defaultMessage = 'Only waiting task parameters can be edited'
            redirect(action: usrList)
        } else {
            return [queuedTaskParamInstance: queuedTaskParamInstance]
        }
    }

    def usrUpdate = {
        def queuedTaskParamInstance = QueuedTaskParam.find('from QueuedTaskParam as x where x.id = ? and x.queued.user = ? and x.securityCode = ?',
                [params.id?.toLong(), utilService.currentUser(), utilService.currentCompany().securityCode])
        if (queuedTaskParamInstance) {
            if (queuedTaskParamInstance.queued.currentStatus != 'waiting') {
                flash.message = 'queuedTaskParam.wait.edit'
                flash.defaultMessage = 'Only waiting task parameters can be edited'
                redirect(action: usrList)
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (queuedTaskParamInstance.version > version) {
                    queuedTaskParamInstance.errors.rejectValue('version', 'queuedTaskParam.optimistic.locking.failure', 'Another user has updated this Queued Task Parameter while you were editing')
                    render(view: 'usrEdit', model: [queuedTaskParamInstance: queuedTaskParamInstance])
                    return
                }
            }

            queuedTaskParamInstance.properties['value'] = params
            if (!queuedTaskParamInstance.hasErrors() && queuedTaskParamInstance.saveThis()) {
                flash.message = 'queuedTaskParam.updated'
                flash.args = [queuedTaskParamInstance.toString()]
                flash.defaultMessage = "Queued Task Parameter ${queuedTaskParamInstance.toString()} updated"
                redirect(action: usrShow, id: queuedTaskParamInstance.id)
            } else {
                render(view: 'usrEdit', model: [queuedTaskParamInstance: queuedTaskParamInstance])
            }
        } else {
            flash.message = 'queuedTaskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task Parameter not found with id ${params.id}"
            redirect(action: usrList)
        }
    }
}