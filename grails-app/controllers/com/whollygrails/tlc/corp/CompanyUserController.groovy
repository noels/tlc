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

class CompanyUserController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin', select: 'login', attach: 'login', change: 'attached', proceed: 'attached', display: 'coadmin', add: 'coadmin',
            adding: 'coadmin', inspect: 'coadmin', remove: 'coadmin', terminate: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', adding: 'POST', remove: 'POST', terminate: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.remove('max')    // Make this an unlimited list
        params.remove('offset')
        params.remove('sort')   // No sorting available
        params.remove('order')
        def ddSource = utilService.source('systemUser.list')
        def companyUserInstanceList = CompanyUser.selectList()
        companyUserInstanceList.sort {it.company.name}
        [companyUserInstanceList: companyUserInstanceList, ddSource: ddSource]
    }

    def show = {
        def companyUserInstance = CompanyUser.get(params.id)
        if (!companyUserInstance) {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [companyUserInstance: companyUserInstance]
        }
    }

    def delete = {
        def companyUserInstance = CompanyUser.get(params.id)
        if (companyUserInstance) {
            if (canBeRemoved(companyUserInstance)) {
                try {
                    companyUserInstance.delete(flush: true)
                    utilService.cacheService.resetThis('userActivity', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userAccessGroup', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userAccount', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userCustomer', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userSupplier', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    flash.message = 'companyUser.deleted'
                    flash.args = [companyUserInstance.toString()]
                    flash.defaultMessage = "Company User ${companyUserInstance.toString()} deleted"
                    redirect(action: list)
                } catch (Exception e) {
                    flash.message = 'companyUser.not.deleted'
                    flash.args = [companyUserInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Company User ${companyUserInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            } else {
                render(view: 'show', model: [companyUserInstance: companyUserInstance])
            }
        } else {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def companyUserInstance = CompanyUser.get(params.id)
        if (!companyUserInstance) {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [companyUserInstance: companyUserInstance]
        }
    }

    def update = {
        def companyUserInstance = CompanyUser.get(params.id)
        if (companyUserInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (companyUserInstance.version > version) {
                    companyUserInstance.errors.rejectValue('version', 'companyUser.optimistic.locking.failure', 'Another user has updated this Company User while you were editing')
                    render(view: 'edit', model: [companyUserInstance: companyUserInstance])
                    return
                }
            }

            def oldSecurityCode = companyUserInstance.securityCode
            companyUserInstance.properties['company', 'lastUsed'] = params
            if (!companyUserInstance.hasErrors() && companyUserInstance.saveThis()) {
                if (companyUserInstance.securityCode != oldSecurityCode) {
                    utilService.cacheService.resetThis('userActivity', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userAccessGroup', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userAccount', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userCustomer', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userSupplier', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                }

                flash.message = 'companyUser.updated'
                flash.args = [companyUserInstance.toString()]
                flash.defaultMessage = "Company User ${companyUserInstance.toString()} updated"
                redirect(action: show, id: companyUserInstance.id)
            } else {
                render(view: 'edit', model: [companyUserInstance: companyUserInstance])
            }
        } else {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def companyUserInstance = new CompanyUser()
        companyUserInstance.user = utilService.reSource('systemUser.list')
        return [companyUserInstance: companyUserInstance]
    }

    def save = {
        def companyUserInstance = new CompanyUser()
        companyUserInstance.properties['company', 'lastUsed'] = params
        companyUserInstance.user = utilService.reSource('systemUser.list')
        if (companyUserInstance.company.systemOnly && !companyUserInstance.user.administrator) {
            companyUserInstance.errorMessage(code: 'companyUser.not.admin', default: 'Only system administrators can be added to the system company')
        }

        if (!companyUserInstance.hasErrors() && companyUserInstance.saveThis()) {
            utilService.cacheService.resetThis('userActivity', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
            utilService.cacheService.resetThis('userAccessGroup', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
            utilService.cacheService.resetThis('userAccount', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
            utilService.cacheService.resetThis('userCustomer', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
            utilService.cacheService.resetThis('userSupplier', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
            flash.message = 'companyUser.created'
            flash.args = [companyUserInstance.toString()]
            flash.defaultMessage = "Company User ${companyUserInstance.toString()} created"
            redirect(action: show, id: companyUserInstance.id)
        } else {
            render(view: 'create', model: [companyUserInstance: companyUserInstance])
        }
    }

    def select = {
        def companyUserInstanceList = CompanyUser.findAllByUser(utilService.currentUser())
        companyUserInstanceList.sort {it.company.name}
        return [companyUserInstanceList: companyUserInstanceList]
    }

    def attach = {
        def companyUserInstance = CompanyUser.get(params.id)
        if (companyUserInstance && companyUserInstance.user.id == utilService.currentUser()?.id) {
            utilService.setNextStep(null)
            utilService.newCurrentCompany(companyUserInstance.company.id)
            redirect(controller: 'systemMenu', action: 'display')
        } else {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: select)
        }
    }

    def change = {
        def companyUserInstanceList = CompanyUser.findAllByUserAndCompanyNotEqual(utilService.currentUser(), utilService.currentCompany())
        companyUserInstanceList.sort {it.company.name}

        return [companyUserInstanceList: companyUserInstanceList]
    }

    def proceed = {
        def companyUserInstance = CompanyUser.get(params.id)
        if (companyUserInstance && companyUserInstance.user.id == utilService.currentUser()?.id) {
            if (companyUserInstance.company.id == utilService.currentCompany().id) {
                flash.message = 'companyUser.bad.change'
                flash.defaultMessage = 'You cannot change to the same company'
                redirect(action: change)
            } else {
                utilService.newCurrentCompany(companyUserInstance.company.id)
                flash.message = 'companyUser.good.change'
                flash.defaultMessage = 'Company changed'
                redirect(controller: 'systemMenu', action: 'display')
            }
        } else {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: change)
        }
    }

    def display = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['loginId', 'name', 'lastLogin'].contains(params.sort) ? params.sort : 'loginId'
        def company = utilService.currentCompany()
        def users = SystemUser.selectList(where: 'x.id in (select y.user.id from CompanyUser as y where y.company = ?)', params: company)
        def companyUserInstanceList = []
        for (user in users) {
            def usr = CompanyUser.findByCompanyAndUser(company, user, [cache: true])
            if (usr) companyUserInstanceList << usr
        }

        [companyUserInstanceList: companyUserInstanceList, companyUserInstanceTotal: CompanyUser.selectCount()]
    }

    def add = {}

    def adding = {
        def systemUserInstance = SystemUser.findByLoginId(params.loginId)
        if (!systemUserInstance) {
            systemUserInstance = new SystemUser(loginId: params.loginId)
            if (!params.loginId) {
                systemUserInstance.errorMessage(field: 'loginId', code: 'companyUser.missing.loginId', default: 'Please enter a login id')
            } else {
                systemUserInstance.errorMessage(field: 'loginId', code: 'companyUser.no.loginId', args: [params.loginId], default: "No user found with login id of '${params.loginId}'")
            }

            render(view: 'add', model: [systemUserInstance: systemUserInstance])
        } else if (CompanyUser.countByCompanyAndUser(utilService.currentCompany(), systemUserInstance) > 0) {
            systemUserInstance.errorMessage(field: 'loginId', code: 'companyUser.bad.loginId', args: [params.loginId], default: "User ${params.loginId} is already a member of this company")
            render(view: 'add', model: [systemUserInstance: systemUserInstance])
        } else {
            def companyUserInstance = new CompanyUser(company: utilService.currentCompany(), user: systemUserInstance)
            if (companyUserInstance.company.systemOnly && !companyUserInstance.user.administrator) {
                companyUserInstance.user = null // Force an error
                systemUserInstance.errorMessage(code: 'companyUser.not.admin', default: 'Only system administrators can be added to the system company')
            }

            if (!companyUserInstance.hasErrors() && companyUserInstance.saveThis()) {
                utilService.cacheService.resetThis('userActivity', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                utilService.cacheService.resetThis('userAccessGroup', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                utilService.cacheService.resetThis('userAccount', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                utilService.cacheService.resetThis('userCustomer', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                utilService.cacheService.resetThis('userSupplier', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                flash.message = 'companyUser.added'
                flash.args = [params.loginId]
                flash.defaultMessage = "User ${params.loginId} has been added to this company. You now need to assign roles to them and add them to data access groups."
                redirect(action: display)
            } else {
                render(view: 'add', model: [systemUserInstance: systemUserInstance])
            }
        }
    }

    def inspect = {
        def companyUserInstance = CompanyUser.findByIdAndCompany(params.id, utilService.currentCompany())
        if (!companyUserInstance) {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: display)
        } else {
            return [companyUserInstance: companyUserInstance, otherCompanies: CompanyUser.countByUser(companyUserInstance.user) - 1]
        }
    }

    def remove = {
        def companyUserInstance = CompanyUser.findByIdAndCompany(params.id, utilService.currentCompany())
        if (companyUserInstance) {
            if (canBeRemoved(companyUserInstance)) {
                try {
                    companyUserInstance.delete(flush: true)
                    utilService.cacheService.resetThis('userActivity', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userAccessGroup', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userAccount', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userCustomer', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    utilService.cacheService.resetThis('userSupplier', companyUserInstance.securityCode, "${companyUserInstance.user.id}")
                    flash.message = 'companyUser.removed'
                    flash.args = [companyUserInstance.user.loginId]
                    flash.defaultMessage = "Company User ${companyUserInstance.user.loginId} removed from this company"
                    redirect(action: display)
                } catch (Exception e) {
                    flash.message = 'companyUser.not.removed'
                    flash.args = [companyUserInstance.user.loginId, e.class.simpleName]
                    flash.defaultMessage = "Company User ${companyUserInstance.user.loginId} could not be removed from this company (${e.class.simpleName})"
                    redirect(action: inspect, id: params.id)
                }
            } else {
                render(view: 'inspect', model: [companyUserInstance: companyUserInstance, otherCompanies: CompanyUser.countByUser(companyUserInstance.user) - 1])
            }
        } else {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: display)
        }
    }

    def terminate = {
        def companyUserInstance = CompanyUser.findByIdAndCompany(params.id, utilService.currentCompany())
        if (companyUserInstance) {
            if (canBeRemoved(companyUserInstance)) {
                def systemUserInstance = companyUserInstance.user
                if (systemUserInstance.administrator) {
                    flash.message = 'companyUser.is.admin'
                    flash.args = [companyUserInstance.toString()]
                    flash.defaultMessage = "Company User ${companyUserInstance.toString()} is a system administrator and cannot be deleted"
                    redirect(action: inspect, id: params.id)
                } else {
                    try {
                        systemUserInstance.delete(flush: true)
                        utilService.cacheService.resetThis('userActivity', utilService.cacheService.COMPANY_INSENSITIVE, "${systemUserInstance.id}")
                        utilService.cacheService.resetThis('userAccessGroup', utilService.cacheService.COMPANY_INSENSITIVE, "${systemUserInstance.id}")
                        utilService.cacheService.resetThis('userAccount', utilService.cacheService.COMPANY_INSENSITIVE, "${systemUserInstance.id}")
                        utilService.cacheService.resetThis('userCustomer', utilService.cacheService.COMPANY_INSENSITIVE, "${systemUserInstance.id}")
                        utilService.cacheService.resetThis('userSupplier', utilService.cacheService.COMPANY_INSENSITIVE, "${systemUserInstance.id}")
                        flash.message = 'systemUser.deleted'
                        flash.args = [systemUserInstance.toString()]
                        flash.defaultMessage = "User ${systemUserInstance.toString()} deleted"
                        redirect(action: display)
                    } catch (Exception e) {
                        flash.message = 'systemUser.not.deleted'
                        flash.args = [systemUserInstance.toString(), e.class.simpleName]
                        flash.defaultMessage = "User ${systemUserInstance.toString()} could not be deleted (${e.class.simpleName})"
                        redirect(action: inspect, id: params.id)
                    }
                }
            } else {
                render(view: 'inspect', model: [companyUserInstance: companyUserInstance, otherCompanies: CompanyUser.countByUser(companyUserInstance.user) - 1])
            }
        } else {
            flash.message = 'companyUser.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Company User not found with id ${params.id}"
            redirect(action: display)
        }
    }

// --------------------------------------------- Support Methods ---------------------------------------------

    private canBeRemoved(companyUserInstance) {

        // Check not attempting to remove themselves from the current company
        if (companyUserInstance.user.id == utilService.currentUser().id && companyUserInstance.company.id == utilService.currentCompany().id) {
            companyUserInstance.errorMessage(code: 'companyUser.self',
                    default: 'You cannot remove yourself from the company')
            return false
        }

        // Check if owns task definitions in this company
        if (Task.countByCompanyAndUser(companyUserInstance.company, companyUserInstance.user) > 0) {
            companyUserInstance.errorMessage(code: 'systemUser.owns.tasks', args: [companyUserInstance.user.name],
                    default: "User ${companyUserInstance.user.name} owns task definitions. These tasks must be re-assigned to another user before continuing.")
            return false
        }

        def qry = 'select count(*) from QueuedTask as qt join qt.task as t where qt.user.id = ? and qt.currentStatus = ? and t.company.id = ?'

        // Check if owns queued tasks in this company that are awaiting execution
        if (QueuedTask.executeQuery(qry, [companyUserInstance.user.id, 'waiting', companyUserInstance.company.id])[0] > 0) {
            companyUserInstance.errorMessage(code: 'systemUser.waiting.tasks', args: [companyUserInstance.user.name],
                    default: "User ${companyUserInstance.user.name} has tasks in the queue awaiting execution. These tasks must be deleted, executed or re-assigned before continuing.")
            return false
        }

        // Make sure they are not trying to remove a system administrator from the system company
        if (companyUserInstance.user.administrator && companyUserInstance.company.systemOnly) {
            companyUserInstance.errorMessage(code: 'companyUser.admin.system', default: 'You cannot remove a system administrator from the system company')
            return false
        }

        // Look for at least two company administrators
        def coAdmins = CompanyUser.findAll('from CompanyUser as x where x.id in (select cu.id from SystemRole as r join r.users as cu where r.code = ? and cu.company.id = ?)',
                ['companyAdmin', companyUserInstance.company.id], [max: 2])

        // If there is only one company administrator and it's this user, complain
        if (coAdmins.size() == 1 && coAdmins[0].id == companyUserInstance.id) {
            companyUserInstance.errorMessage(code: 'systemUser.last.company.admin', args: [companyUserInstance.user.name, companyUserInstance.company.name],
                    default: "User ${companyUserInstance.user.name} is the last administrator in company ${companyUserInstance.company.name} and may not be deleted")
            return false
        }

        return true
    }
}
