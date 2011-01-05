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

import com.whollygrails.tlc.sys.SystemUser
import com.whollygrails.tlc.sys.TaskExecutor
import com.whollygrails.tlc.sys.TaskService

class QueuedTaskController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin', queue: 'sysadmin', start: 'sysadmin', stop: 'sysadmin', pause: 'sysadmin', resize: 'sysadmin',
            queueShow: 'sysadmin', queueDelete: 'sysadmin', queueEdit: 'sysadmin', queueUpdate: 'sysadmin', queueRerun: 'sysadmin',
            usrList: 'attached', usrShow: 'attached', usrDelete: 'attached', usrEdit: 'attached', usrUpdate: 'attached']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', update: 'POST', start: 'POST', stop: 'POST', pause: 'POST', resize: 'POST',
            queueDelete: 'POST', queueUpdate: 'POST', usrDelete: 'POST', usrUpdate: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        if (!['dateCreated', 'scheduled', 'preferredStart', 'startedAt', 'completedAt', 'completionMessage'].contains(params.sort)) {
            params.sort = 'dateCreated'
            params.order = 'desc'
        }
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def queueStatus = utilService.taskService.statistics()
        if (queueStatus) queueStatus.status = message(code: "queuedTask.queue.status.${queueStatus.status}", default: queueStatus.status)
        [queuedTaskInstanceList: QueuedTask.selectList(securityCode: utilService.currentCompany().securityCode), queuedTaskInstanceTotal: QueuedTask.selectCount(), queueStatus: queueStatus]
    }

    def show = {
        def queuedTaskInstance = QueuedTask.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!queuedTaskInstance) {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [queuedTaskInstance: queuedTaskInstance]
        }
    }

    def delete = {
        def queuedTaskInstance = QueuedTask.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (queuedTaskInstance) {
            if (queuedTaskInstance.currentStatus == 'waiting') {
                try {
                    queuedTaskInstance.delete(flush: true)
                    flash.message = 'queuedTask.deleted'
                    flash.args = [queuedTaskInstance.toString()]
                    flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} deleted"
                    redirect(action: list)
                } catch (Exception e) {
                    flash.message = 'queuedTask.not.deleted'
                    flash.args = [queuedTaskInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            } else {
                flash.message = 'queuedTask.wait.delete'
                flash.defaultMessage = 'Only waiting tasks can be deleted'
                redirect(action: list)
            }
        } else {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def queuedTaskInstance = QueuedTask.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!queuedTaskInstance) {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: list)
        } else if (queuedTaskInstance.currentStatus != 'waiting') {
            flash.message = 'queuedTask.wait.edit'
            flash.defaultMessage = 'Only waiting tasks can be edited'
            redirect(action: list)
        } else {
            return [queuedTaskInstance: queuedTaskInstance, companyUserList: utilService.currentCompanyUserList()]
        }
    }

    def update = {
        def queuedTaskInstance = QueuedTask.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (queuedTaskInstance) {
            if (queuedTaskInstance.currentStatus != 'waiting') {
                flash.message = 'queuedTask.wait.edit'
                flash.defaultMessage = 'Only waiting tasks can be edited'
                redirect(action: list)
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (queuedTaskInstance.version > version) {
                    queuedTaskInstance.errors.rejectValue('version', 'queuedTask.optimistic.locking.failure', 'Another user has updated this Queued Task while you were editing')
                    render(view: 'edit', model: [queuedTaskInstance: queuedTaskInstance])
                    return
                }
            }

            def oldUser = queuedTaskInstance.user
            queuedTaskInstance.properties['user', 'preferredStart'] = params
            def valid = !queuedTaskInstance.hasErrors()
            if (valid && queuedTaskInstance.user.id != oldUser.id) {
                if (CompanyUser.countByCompanyAndUser(utilService.currentCompany(), queuedTaskInstance.user) == 0) {
                    queuedTaskInstance.errorMessage(field: 'user', code: 'queuedTask.no.combo', default: 'Invalid company and user combination')
                    valid = false
                }
            }

            if (valid && queuedTaskInstance.preferredStart &&
                    (queuedTaskInstance.preferredStart.getTime() < System.currentTimeMillis() - 60000L || queuedTaskInstance.preferredStart > new Date() + 365)) {
                queuedTaskInstance.errorMessage(field: 'preferredStart', code: 'queuedTask.preferredStart.invalid', default: 'Invalid preferred start date and time')
                valid = false
            }

            if (valid) valid = queuedTaskInstance.saveThis()
            if (valid) {
                flash.message = 'queuedTask.updated'
                flash.args = [queuedTaskInstance.toString()]
                flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} updated"
                redirect(action: show, id: queuedTaskInstance.id)
            } else {
                render(view: 'edit', model: [queuedTaskInstance: queuedTaskInstance])
            }
        } else {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: list)
        }
    }

    // System administrators view of the whole queue
    def queue = {
        if (!['dateCreated', 'scheduled', 'preferredStart', 'startedAt', 'completedAt', 'completionMessage'].contains(params.sort)) {
            params.sort = 'dateCreated'
            params.order = 'desc'
        }
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def queueStatus = utilService.taskService.statistics()
        if (queueStatus) {

            // Translate the status message in to a new entry within the map
            queueStatus.statusText = message(code: "queuedTask.queue.status.${queueStatus.status}", default: queueStatus.status)

            // Create a size range for the thread pool
            queueStatus.sizeRange = 1..utilService.taskService.poolSizeLimit()

            // Stop the executor if the scanner is not running
            if (queueStatus.status == TaskExecutor.QUEUE_HALTED) TaskExecutor.stop()
        }

        [queuedTaskInstanceList: QueuedTask.selectList(), queuedTaskInstanceTotal: QueuedTask.selectCount(), queueStatus: queueStatus]
    }

    def start = {
        def status = utilService.taskService.queueStatus()
        if (status == TaskExecutor.QUEUE_STOPPED) {
            if (TaskService.start()) {
                flash.message = 'queuedTask.sys.started'
                flash.defaultMessage = 'Task queue started'
            } else {
                flash.message = 'queuedTask.sys.not.started'
                flash.defaultMessage = 'Task queue NOT started'
            }
        } else if (status == TaskExecutor.QUEUE_PAUSED) {
            if (utilService.taskService.resume()) {
                flash.message = 'queuedTask.sys.resumed'
                flash.defaultMessage = 'Task queue processing resumed'
            } else {
                flash.message = 'queuedTask.sys.not.resumed'
                flash.defaultMessage = 'Task queue processing NOT resumed'
            }
        } else {
            flash.message = 'queuedTask.sys.no.startup'
            flash.defaultMessage = 'Task queue is already running'
        }

        redirect(action: queue)
    }

    def stop = {
        if (TaskService.stop()) {
            flash.message = 'queuedTask.sys.stopped'
            flash.defaultMessage = 'Task queue stopped'
        } else {
            flash.message = 'queuedTask.sys.not.stopped'
            flash.defaultMessage = 'Task queue NOT stopped'
        }

        redirect(action: queue)
    }

    def pause = {
        if (utilService.taskService.pause()) {
            flash.message = 'queuedTask.sys.paused'
            flash.defaultMessage = 'Task queue paused'
        } else {
            flash.message = 'queuedTask.sys.not.paused'
            flash.defaultMessage = 'Task queue NOT paused'
        }

        redirect(action: queue)
    }

    def resize = {
        if (params.newSize && utilService.taskService.resize(params.newSize.toInteger())) {
            flash.message = 'queuedTask.sys.resized'
            flash.defaultMessage = 'Task queue resized'
        } else {
            flash.message = 'queuedTask.sys.not.resized'
            flash.defaultMessage = 'Task queue NOT resized'
        }

        redirect(action: queue)
    }

    def queueShow = {
        def queuedTaskInstance = QueuedTask.get(params.id)

        if (!queuedTaskInstance) {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [queuedTaskInstance: queuedTaskInstance]
        }
    }

    def queueDelete = {
        def queuedTaskInstance = QueuedTask.get(params.id)
        if (queuedTaskInstance) {
            if (queuedTaskInstance.currentStatus == 'waiting') {
                try {
                    queuedTaskInstance.delete(flush: true)
                    flash.message = 'queuedTask.deleted'
                    flash.args = [queuedTaskInstance.toString()]
                    flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} deleted"
                    redirect(action: queue)
                } catch (Exception e) {
                    flash.message = 'queuedTask.not.deleted'
                    flash.args = [queuedTaskInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: queueShow, id: params.id)
                }
            } else {
                flash.message = 'queuedTask.wait.delete'
                flash.defaultMessage = 'Only waiting tasks can be deleted'
                redirect(action: queue)
            }
        } else {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: queue)
        }
    }

    def queueEdit = {
        def queuedTaskInstance = QueuedTask.get(params.id)

        if (!queuedTaskInstance) {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: queue)
        } else if (queuedTaskInstance.currentStatus != 'waiting') {
            flash.message = 'queuedTask.wait.edit'
            flash.defaultMessage = 'Only waiting tasks can be edited'
            redirect(action: queue)
        } else {
            def cul = SystemUser.findAll('from SystemUser as x where x.id in (select y.user.id from CompanyUser as y where y.company = ?) order by x.name', [queuedTaskInstance.task.company])
            return [queuedTaskInstance: queuedTaskInstance, companyUserList: cul]
        }
    }

    def queueUpdate = {
        def queuedTaskInstance = QueuedTask.get(params.id)
        if (queuedTaskInstance) {
            if (queuedTaskInstance.currentStatus != 'waiting') {
                flash.message = 'queuedTask.wait.edit'
                flash.defaultMessage = 'Only waiting tasks can be edited'
                redirect(action: queue)
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (queuedTaskInstance.version > version) {
                    queuedTaskInstance.errors.rejectValue('version', 'queuedTask.optimistic.locking.failure', 'Another user has updated this Queued Task while you were editing')
                    render(view: 'queueEdit', model: [queuedTaskInstance: queuedTaskInstance])
                    return
                }
            }

            def oldUser = queuedTaskInstance.user
            queuedTaskInstance.properties['user', 'preferredStart'] = params
            def valid = !queuedTaskInstance.hasErrors()
            if (valid && queuedTaskInstance.user.id != oldUser.id) {
                if (CompanyUser.countByCompanyAndUser(queuedTaskInstance.task.company, queuedTaskInstance.user) == 0) {
                    queuedTaskInstance.errorMessage(field: 'user', code: 'queuedTask.no.combo', default: 'Invalid company and user combination')
                    valid = false
                }
            }

            if (valid && queuedTaskInstance.preferredStart &&
                    (queuedTaskInstance.preferredStart.getTime() < System.currentTimeMillis() - 60000L || queuedTaskInstance.preferredStart > new Date() + 365)) {
                queuedTaskInstance.errorMessage(field: 'preferredStart', code: 'queuedTask.preferredStart.invalid', default: 'Invalid preferred start date and time')
                valid = false
            }

            if (valid) valid = queuedTaskInstance.saveThis()
            if (valid) {
                flash.message = 'queuedTask.updated'
                flash.args = [queuedTaskInstance.toString()]
                flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} updated"
                redirect(action: queueShow, id: queuedTaskInstance.id)
            } else {
                render(view: 'queueEdit', model: [queuedTaskInstance: queuedTaskInstance])
            }
        } else {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: queue)
        }
    }

    def queueRerun = {
        def queuedTaskInstance = QueuedTask.get(params.id)
        if (queuedTaskInstance) {
            if (queuedTaskInstance.currentStatus == 'waiting' || queuedTaskInstance.currentStatus == 'running') {
                flash.message = 'queuedTask.no.rerun'
                flash.defaultMessage = 'Tasks that are waiting or running can not be rerun'
                redirect(action: queueShow, id: queuedTaskInstance.id)
            } else {
                def list = []
                queuedTaskInstance.parameters.each {p ->
                    list << [param: p.param, value: p.value]
                }

                if (utilService.taskService.submit(queuedTaskInstance.task, list, queuedTaskInstance.user)) {
                    flash.message = 'queuedTask.good.rerun'
                    flash.defaultMessage = 'Rerun of this task successfully added to the queue'
                    redirect(action: queue)
                } else {
                    flash.message = 'queuedTask.bad.rerun'
                    flash.defaultMessage = 'Unable to rerun this task'
                    redirect(action: queueShow, id: queuedTaskInstance.id)

                }
            }
        } else {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: queue)
        }
    }

    def usrList = {
        if (!['dateCreated', 'scheduled', 'preferredStart', 'startedAt', 'completedAt', 'completionMessage'].contains(params.sort)) {
            params.sort = 'dateCreated'
            params.order = 'desc'
        }
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def queueStatus = utilService.taskService.statistics()
        if (queueStatus) queueStatus.status = message(code: "queuedTask.queue.status.${queueStatus.status}", default: queueStatus.status)
        def list = QueuedTask.selectList(securityCode: utilService.currentCompany().securityCode, where: 'x.user = ?', params: utilService.currentUser())
        def total = QueuedTask.selectCount()
        [queuedTaskInstanceList: list, queuedTaskInstanceTotal: total, queueStatus: queueStatus]
    }

    def usrShow = {
        def queuedTaskInstance = QueuedTask.find('from QueuedTask as x where x.id = ? and x.user = ? and x.securityCode = ?',
                [params.id?.toLong(), utilService.currentUser(), utilService.currentCompany().securityCode])

        if (!queuedTaskInstance) {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: usrList)
        } else {
            return [queuedTaskInstance: queuedTaskInstance]
        }
    }

    def usrDelete = {
        def queuedTaskInstance = QueuedTask.find('from QueuedTask as x where x.id = ? and x.user = ? and x.securityCode = ?',
                [params.id?.toLong(), utilService.currentUser(), utilService.currentCompany().securityCode])
        if (queuedTaskInstance) {
            if (queuedTaskInstance.currentStatus == 'waiting') {
                try {
                    queuedTaskInstance.delete(flush: true)
                    flash.message = 'queuedTask.deleted'
                    flash.args = [queuedTaskInstance.toString()]
                    flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} deleted"
                    redirect(action: usrList)
                } catch (Exception e) {
                    flash.message = 'queuedTask.not.deleted'
                    flash.args = [queuedTaskInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: usrShow, id: params.id)
                }
            } else {
                flash.message = 'queuedTask.wait.delete'
                flash.defaultMessage = 'Only waiting tasks can be deleted'
                redirect(action: usrList)
            }
        } else {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: usrList)
        }
    }

    def usrEdit = {
        def queuedTaskInstance = QueuedTask.find('from QueuedTask as x where x.id = ? and x.user = ? and x.securityCode = ?',
                [params.id?.toLong(), utilService.currentUser(), utilService.currentCompany().securityCode])

        if (!queuedTaskInstance) {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: usrList)
        } else if (queuedTaskInstance.currentStatus != 'waiting') {
            flash.message = 'queuedTask.wait.edit'
            flash.defaultMessage = 'Only waiting tasks can be edited'
            redirect(action: usrList)
        } else {
            return [queuedTaskInstance: queuedTaskInstance, companyUserList: utilService.currentCompanyUserList()]
        }
    }

    def usrUpdate = {
        def queuedTaskInstance = QueuedTask.find('from QueuedTask as x where x.id = ? and x.user = ? and x.securityCode = ?',
                [params.id?.toLong(), utilService.currentUser(), utilService.currentCompany().securityCode])
        if (queuedTaskInstance) {
            if (queuedTaskInstance.currentStatus != 'waiting') {
                flash.message = 'queuedTask.wait.edit'
                flash.defaultMessage = 'Only waiting tasks can be edited'
                redirect(action: usrList)
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (queuedTaskInstance.version > version) {
                    queuedTaskInstance.errors.rejectValue('version', 'queuedTask.optimistic.locking.failure', 'Another user has updated this Queued Task while you were editing')
                    render(view: 'usrEdit', model: [queuedTaskInstance: queuedTaskInstance])
                    return
                }
            }

            // The completion message parameter is not actually required below, but Grails seems to be
            // having a problem when only one property is specified in the list
            queuedTaskInstance.properties['completionMessage', 'preferredStart'] = params
            def valid = !queuedTaskInstance.hasErrors()
            if (valid && queuedTaskInstance.preferredStart &&
                    (queuedTaskInstance.preferredStart.getTime() < System.currentTimeMillis() - 60000L || queuedTaskInstance.preferredStart > new Date() + 365)) {
                queuedTaskInstance.errorMessage(field: 'preferredStart', code: 'queuedTask.preferredStart.invalid', default: 'Invalid preferred start date and time')
                valid = false
            }

            if (valid) valid = queuedTaskInstance.saveThis()
            if (valid) {
                flash.message = 'queuedTask.updated'
                flash.args = [queuedTaskInstance.toString()]
                flash.defaultMessage = "Queued Task ${queuedTaskInstance.toString()} updated"
                redirect(action: usrShow, id: queuedTaskInstance.id)
            } else {
                render(view: 'usrEdit', model: [queuedTaskInstance: queuedTaskInstance])
            }
        } else {
            flash.message = 'queuedTask.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Queued Task not found with id ${params.id}"
            redirect(action: usrList)
        }
    }
}