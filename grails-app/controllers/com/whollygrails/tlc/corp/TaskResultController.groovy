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

class TaskResultController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.sort = ['code', 'sequencer', 'dataType', 'dataScale'].contains(params.sort) ? params.sort : 'code'
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def ddSource = utilService.source('task.list')
        [taskResultInstanceList: TaskResult.selectList(securityCode: utilService.currentCompany().securityCode), taskResultInstanceTotal: TaskResult.selectCount(), ddSource: ddSource]
    }

    def show = {
        def taskResultInstance = TaskResult.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!taskResultInstance) {
            flash.message = 'taskResult.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Result not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [taskResultInstance : taskResultInstance]
        }
    }

    def delete = {
        def taskResultInstance = TaskResult.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (taskResultInstance) {
            try {
                utilService.deleteWithMessages(taskResultInstance, [prefix: "taskResult.name.${taskResultInstance.task.code}", code: taskResultInstance.code])
                flash.message = 'taskResult.deleted'
                flash.args = [taskResultInstance.toString()]
                flash.defaultMessage = "Task Result ${taskResultInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'taskResult.not.deleted'
                flash.args = [taskResultInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Task Result ${taskResultInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'taskResult.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Result not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def taskResultInstance = TaskResult.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!taskResultInstance) {
            flash.message = 'taskResult.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Result not found with id ${params.id}"
            redirect(action:list)
        } else {
            return [taskResultInstance: taskResultInstance]
        }
    }

    def update = {
        def taskResultInstance = TaskResult.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if(taskResultInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (taskResultInstance.version > version) {
                    taskResultInstance.errors.rejectValue('version', 'taskResult.optimistic.locking.failure', 'Another user has updated this Task Result while you were editing')
                    render(view: 'edit', model: [taskResultInstance: taskResultInstance])
                    return
                }
            }

            def oldCode = taskResultInstance.code
            taskResultInstance.properties['code', 'name', 'sequencer', 'dataType', 'dataScale'] = params
            if (utilService.saveWithMessages(taskResultInstance, [prefix: "taskResult.name.${taskResultInstance.task.code}", code: taskResultInstance.code, field: 'name', oldCode: oldCode])) {
                flash.message = 'taskResult.updated'
                flash.args = [taskResultInstance.toString()]
                flash.defaultMessage = "Task Result ${taskResultInstance.toString()} updated"
                redirect(action:show,id:taskResultInstance.id)
            } else {
                render(view: 'edit', model: [taskResultInstance: taskResultInstance])
            }
        } else {
            flash.message = 'taskResult.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Result not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def taskResultInstance = new TaskResult()
        taskResultInstance.task = utilService.reSource('task.list')
        return ['taskResultInstance': taskResultInstance]
    }

    def save = {
        def taskResultInstance = new TaskResult()
        taskResultInstance.properties['code', 'name', 'sequencer', 'dataType', 'dataScale'] = params
        taskResultInstance.task = utilService.reSource('task.list')
        if (utilService.saveWithMessages(taskResultInstance, [prefix: "taskResult.name.${taskResultInstance.task?.code}", code: taskResultInstance.code, field: 'name'])) {
            flash.message = 'taskResult.created'
            flash.args = [taskResultInstance.toString()]
            flash.defaultMessage = "Task Result ${taskResultInstance.toString()} created"
            redirect(action: show, id: taskResultInstance.id)
        } else {
            render(view: 'create', model: [taskResultInstance: taskResultInstance])
        }
    }
}