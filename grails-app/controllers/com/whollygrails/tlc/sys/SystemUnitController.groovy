package com.whollygrails.tlc.sys

class SystemUnitController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code', 'multiplier'].contains(params.sort) ? params.sort : 'code'
        def ddSource = utilService.source('systemMeasure.list')
        if (!ddSource) ddSource = utilService.source('systemScale.list')
        [systemUnitInstanceList: SystemUnit.selectList(), systemUnitInstanceTotal: SystemUnit.selectCount(), ddSource: ddSource]
    }

    def show = {
        def systemUnitInstance = SystemUnit.get(params.id)
        if (!systemUnitInstance) {
            flash.message = 'systemUnit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Unit not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemUnitInstance: systemUnitInstance]
        }
    }

    def delete = {
        def systemUnitInstance = SystemUnit.get(params.id)
        if (systemUnitInstance) {
            try {
                utilService.deleteWithMessages(systemUnitInstance, [prefix: 'unit.name', code: systemUnitInstance.code])
                utilService.cacheService.resetThis('conversion', 0L, systemUnitInstance.code)
                flash.message = 'systemUnit.deleted'
                flash.args = [systemUnitInstance.toString()]
                flash.defaultMessage = "System Unit ${systemUnitInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'systemUnit.not.deleted'
                flash.args = [systemUnitInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "System Unit ${systemUnitInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'systemUnit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Unit not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemUnitInstance = SystemUnit.get(params.id)
        if (!systemUnitInstance) {
            flash.message = 'systemUnit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Unit not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemUnitInstance: systemUnitInstance]
        }
    }

    def update = {
        def systemUnitInstance = SystemUnit.get(params.id)
        if (systemUnitInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemUnitInstance.version > version) {
                    systemUnitInstance.errors.rejectValue('version', 'systemUnit.optimistic.locking.failure', 'Another user has updated this System Unit while you were editing')
                    render(view: 'edit', model: [systemUnitInstance: systemUnitInstance])
                    return
                }
            }

            def oldCode = systemUnitInstance.code
            systemUnitInstance.properties['code', 'name', 'multiplier', 'measure', 'scale'] = params
            if (utilService.saveWithMessages(systemUnitInstance, [prefix: 'unit.name', code: systemUnitInstance.code, oldCode: oldCode, field: 'name'])) {
                utilService.cacheService.resetThis('conversion', 0L, systemUnitInstance.code)
                flash.message = 'systemUnit.updated'
                flash.args = [systemUnitInstance.toString()]
                flash.defaultMessage = "System Unit ${systemUnitInstance.toString()} updated"
                redirect(action: show, id: systemUnitInstance.id)
            } else {
                render(view: 'edit', model: [systemUnitInstance: systemUnitInstance])
            }
        } else {
            flash.message = 'systemUnit.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "System Unit not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def systemUnitInstance = new SystemUnit()
        def ddSource = utilService.reSource('systemMeasure.list')
        if (ddSource) {
            systemUnitInstance.measure = ddSource
        } else {
            ddSource = utilService.reSource('systemScale.list')
            if (ddSource) systemUnitInstance.scale = ddSource
        }

        return [systemUnitInstance: systemUnitInstance]
    }

    def save = {
        def systemUnitInstance = new SystemUnit()
        systemUnitInstance.properties['code', 'name', 'multiplier', 'measure', 'scale'] = params
        if (utilService.saveWithMessages(systemUnitInstance, [prefix: 'unit.name', code: systemUnitInstance.code, field: 'name'])) {
            utilService.cacheService.resetThis('conversion', 0L, systemUnitInstance.code)
            flash.message = 'systemUnit.created'
            flash.args = [systemUnitInstance.toString()]
            flash.defaultMessage = "System Unit ${systemUnitInstance.toString()} created"
            redirect(action: show, id: systemUnitInstance.id)
        } else {
            render(view: 'create', model: [systemUnitInstance: systemUnitInstance])
        }
    }
}