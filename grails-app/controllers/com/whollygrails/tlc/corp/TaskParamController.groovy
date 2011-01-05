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

class TaskParamController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.sort = ['code', 'sequencer', 'dataType', 'dataScale', 'defaultValue', 'required'].contains(params.sort) ? params.sort : 'code'
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        def ddSource = utilService.source('task.list')
        [taskParamInstanceList: TaskParam.selectList(securityCode: utilService.currentCompany().securityCode), taskParamInstanceTotal: TaskParam.selectCount(), ddSource: ddSource]
    }

    def show = {
        def taskParamInstance = TaskParam.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!taskParamInstance) {
            flash.message = 'taskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Parameter not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [taskParamInstance: taskParamInstance]
        }
    }

    def delete = {
        def taskParamInstance = TaskParam.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (taskParamInstance) {
            try {
                utilService.deleteWithMessages(taskParamInstance, [prefix: "taskParam.name.${taskParamInstance.task.code}", code: taskParamInstance.code])
                flash.message = 'taskParam.deleted'
                flash.args = [taskParamInstance.toString()]
                flash.defaultMessage = "Task Parameter ${taskParamInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'taskParam.not.deleted'
                flash.args = [taskParamInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Task Parameter ${taskParamInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'taskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Parameter not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def taskParamInstance = TaskParam.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)

        if (!taskParamInstance) {
            flash.message = 'taskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Parameter not found with id ${params.id}"
            redirect(action:list)
        } else {
            return [taskParamInstance: taskParamInstance]
        }
    }

    def update = {
        def taskParamInstance = TaskParam.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (taskParamInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (taskParamInstance.version > version) {
                    taskParamInstance.errors.rejectValue('version', 'taskParam.optimistic.locking.failure', 'Another user has updated this Task Parameter while you were editing')
                    render(view: 'edit', model: [taskParamInstance: taskParamInstance])
                    return
                }
            }

            def oldCode = taskParamInstance.code
            taskParamInstance.properties['code', 'name', 'sequencer', 'dataType', 'dataScale', 'defaultValue', 'required'] = params
            if (utilService.saveWithMessages(taskParamInstance, [prefix: "taskParam.name.${taskParamInstance.task.code}", code: taskParamInstance.code, field: 'name', oldCode: oldCode])) {
                flash.message = 'taskParam.updated'
                flash.args = [taskParamInstance.toString()]
                flash.defaultMessage = "Task Parameter ${taskParamInstance.toString()} updated"
                redirect(action:show,id:taskParamInstance.id)
            } else {
                render(view: 'edit', model: [taskParamInstance: taskParamInstance])
            }
        } else {
            flash.message = 'taskParam.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Task Parameter not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def taskParamInstance = new TaskParam()
        taskParamInstance.task = utilService.reSource('task.list')
        return ['taskParamInstance': taskParamInstance]
    }

    def save = {
        def taskParamInstance = new TaskParam()
        taskParamInstance.properties['code', 'name', 'sequencer', 'dataType', 'dataScale', 'defaultValue', 'required'] = params
        taskParamInstance.task = utilService.reSource('task.list')
        if (utilService.saveWithMessages(taskParamInstance, [prefix: "taskParam.name.${taskParamInstance.task?.code}", code: taskParamInstance.code, field: 'name'])) {
            flash.message = 'taskParam.created'
            flash.args = [taskParamInstance.toString()]
            flash.defaultMessage = "Task Parameter ${taskParamInstance.toString()} created"
            redirect(action: show, id: taskParamInstance.id)
        } else {
            render(view: 'create', model: [taskParamInstance: taskParamInstance])
        }
    }
}