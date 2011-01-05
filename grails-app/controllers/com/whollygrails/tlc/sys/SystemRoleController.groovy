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
package com.whollygrails.tlc.sys

import com.whollygrails.tlc.corp.CompanyUser

class SystemRoleController {

    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin', display: 'coadmin', edits: 'coadmin', adjust: 'coadmin', listing: 'coadmin', members: 'coadmin',
            membership: 'coadmin', process: 'coadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', link: 'POST', adjust: 'POST', process: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code'].contains(params.sort) ? params.sort : 'code'
        def ddSource = utilService.source('companyUser.list')
        [systemRoleInstanceList: SystemRole.selectList(), systemRoleInstanceTotal: SystemRole.selectCount(), ddSource: ddSource]
    }

    def show = {
        def systemRoleInstance = SystemRole.get(params.id)
        if (!systemRoleInstance) {
            flash.message = 'systemRole.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Role not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemRoleInstance: systemRoleInstance]
        }
    }

    def delete = {
        def systemRoleInstance = SystemRole.get(params.id)
        if (systemRoleInstance) {
            if (systemRoleInstance.code == 'companyAdmin') {
                flash.message = 'systemRole.admin.delete'
                flash.defaultMessage = 'The companyAdmin role cannot be deleted'
                redirect(action: show, id: params.id)
            } else {
                try {
                    def valid = true
                    SystemRole.withTransaction {status ->

                        // Need to avoid concurrent modification exceptions
                        def temp = []
                        systemRoleInstance.users.each {
                            temp << it
                        }

                        temp.each {
                            systemRoleInstance.removeFromUsers(it)
                        }

                        temp = []
                        systemRoleInstance.activities.each {
                            temp << it
                        }

                        temp.each {
                            systemRoleInstance.removeFromActivities(it)
                        }

                        if (systemRoleInstance.save()) {
                            utilService.deleteWithMessages(systemRoleInstance, [prefix: 'role.name', code: systemRoleInstance.code], status)
                        } else {
                            status.setRollbackOnly()
                            systemRoleInstance.errorMessage(code: 'systemRole.remove', default: 'Unable to remove the members and activities from the role')
                            valid = false
                        }
                    }

                    if (valid) {
                        utilService.cacheService.clearThis('userActivity')
                        flash.message = 'systemRole.deleted'
                        flash.args = [systemRoleInstance.toString()]
                        flash.defaultMessage = "Role ${systemRoleInstance.toString()} deleted"
                        redirect(action: list)
                    } else {
                        redirect(action: show, id: params.id)
                    }
                } catch (Exception e) {
                    flash.message = 'systemRole.not.deleted'
                    flash.args = [systemRoleInstance.toString(), e.class.simpleName]
                    flash.defaultMessage = "Role ${systemRoleInstance.toString()} could not be deleted (${e.class.simpleName})"
                    redirect(action: show, id: params.id)
                }
            }
        } else {
            flash.message = 'systemRole.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Role not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def systemRoleInstance = SystemRole.get(params.id)
        if (!systemRoleInstance) {
            flash.message = 'systemRole.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Role not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [systemRoleInstance: systemRoleInstance]
        }
    }

    def update = {
        def systemRoleInstance = SystemRole.get(params.id)
        if (systemRoleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (systemRoleInstance.version > version) {
                    systemRoleInstance.errors.rejectValue('version', 'systemRole.optimistic.locking.failure', 'Another user has updated this Role while you were editing')
                    render(view: 'edit', model: [systemRoleInstance: systemRoleInstance])
                    return
                }
            }

            def oldCode = systemRoleInstance.code
            systemRoleInstance.properties['code', 'name'] = params
            if (oldCode == 'companyAdmin' && systemRoleInstance.code != oldCode) {
                systemRoleInstance.errorMessage(field: 'code', code: 'systemRole.admin.change', default: 'The companyAdmin role cannot have its code changed')
                render(view: 'edit', model: [systemRoleInstance: systemRoleInstance])
            } else {
                if (utilService.saveWithMessages(systemRoleInstance, [prefix: 'role.name', code: systemRoleInstance.code, oldCode: oldCode, field: 'name'])) {
                    utilService.cacheService.clearThis('userActivity')
                    flash.message = 'systemRole.updated'
                    flash.args = [systemRoleInstance.toString()]
                    flash.defaultMessage = "Role ${systemRoleInstance.toString()} updated"
                    redirect(action: show, id: systemRoleInstance.id)
                } else {
                    render(view: 'edit', model: [systemRoleInstance: systemRoleInstance])
                }
            }
        } else {
            flash.message = 'systemRole.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Role not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        return [systemRoleInstance: new SystemRole()]
    }

    def save = {
        def systemRoleInstance = new SystemRole()
        systemRoleInstance.properties['code', 'name'] = params
        if (utilService.saveWithMessages(systemRoleInstance, [prefix: 'role.name', code: systemRoleInstance.code, field: 'name'])) {
            utilService.cacheService.clearThis('userActivity')
            flash.message = 'systemRole.created'
            flash.args = [systemRoleInstance.toString()]
            flash.defaultMessage = "Role ${systemRoleInstance.toString()} created"
            redirect(action: show, id: systemRoleInstance.id)
        } else {
            render(view: 'create', model: [systemRoleInstance: systemRoleInstance])
        }
    }

    def links = {
        def ddSource = utilService.reSource('companyUser.list')
        [allRoles: SystemRole.list(), userRoles: SystemRole.selectList(action: 'list'), ddSource: ddSource]
    }

    def link = {
        def ddSource = utilService.reSource('companyUser.list')
        def userRoles = SystemRole.selectList(action: 'list')
        def roles = []
        if (params.linkages) roles = params.linkages instanceof String ? [params.linkages.toLong()] : params.linkages*.toLong() as List
        def modified = false
        for (role in userRoles) {
            if (!roles.contains(role.id)) {
                ddSource.removeFromRoles(role)
                modified = true
            }
        }

        for (role in roles) {
            def found = false
            for (r in userRoles) {
                if (r.id == role) {
                    found = true
                    break
                }
            }

            if (!found) {
                ddSource.addToRoles(SystemRole.get(role))
                modified = true
            }
        }

        if (modified) {
            if (ddSource.save(flush: true)) {  // With deep validation
                utilService.cacheService.resetThis('userActivity', ddSource.securityCode, "${ddSource.user.id}")
                flash.message = 'generic.links.changed'
                flash.defaultMessage = 'The links were successfully updated'
            } else {
                flash.message = 'generic.links.failed'
                flash.defaultMessage = 'Error updating the links'
            }
        } else {
            flash.message = 'generic.links.unchanged'
            flash.defaultMessage = 'No links were changed'
        }

        redirect(action: list)
    }

    def display = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code'].contains(params.sort) ? params.sort : 'code'
        def ddSource = utilService.source('companyUser.display')
        [systemRoleInstanceList: SystemRole.selectList(), systemRoleInstanceTotal: SystemRole.selectCount(), ddSource: ddSource]
    }

    def edits = {
        def ddSource = utilService.reSource('companyUser.display', [origin: 'display'])
        [allRoles: SystemRole.list(), userRoles: SystemRole.selectList(action: 'display'), ddSource: ddSource]
    }

    def adjust = {
        def ddSource = utilService.reSource('companyUser.display', [origin: 'display'])
        def userRoles = SystemRole.selectList(action: 'display')
        def roles = []
        if (params.linkages) roles = params.linkages instanceof String ? [params.linkages.toLong()] : params.linkages*.toLong() as List
        def modified = false

        // Work through the existing roles
        for (role in userRoles) {

            // If the existing role is not in the new roles, remove it
            if (!roles.contains(role.id)) {
                ddSource.removeFromRoles(role)
                modified = true
            }
        }

        // Work through the new roles
        for (role in roles) {
            def found = false

            // Check if the new role is in the exiting roles
            for (r in userRoles) {
                if (r.id == role) {
                    found = true
                    break
                }
            }

            // Add the new role if it wasn't in the existing roles
            if (!found) {
                ddSource.addToRoles(SystemRole.get(role))
                modified = true
            }
        }

        if (modified) {
            if (ddSource.save(flush: true)) {      // With deep validation
                utilService.cacheService.resetThis('userActivity', ddSource.securityCode, "${ddSource.user.id}")
                flash.message = 'systemRole.roles.changed'
                flash.defaultMessage = 'User roles updated'
            } else {
                flash.message = 'systemRole.roles.failed'
                flash.defaultMessage = 'Error updating the roles'
            }
        } else {
            flash.message = 'systemRole.roles.unchanged'
            flash.defaultMessage = 'No roles were changed'
        }

        redirect(action: display)
    }

    def listing = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['code'].contains(params.sort) ? params.sort : 'code'
        [systemRoleInstanceList: SystemRole.selectList(), systemRoleInstanceTotal: SystemRole.selectCount()]
    }

    def members = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['loginId', 'name'].contains(params.sort) ? params.sort : 'name'
        def ddSource = utilService.source('systemRole.listing')
        def memberList = SystemUser.findAll('from SystemUser as su where su.id in (select cu.user.id from CompanyUser as cu join cu.roles as r where cu.company = ? and r = ?) order by su.name', [utilService.currentCompany(), ddSource])
        def memberTotal = SystemUser.executeQuery('select count(*) from SystemUser as su where su.id in (select cu.user.id from CompanyUser as cu join cu.roles as r where cu.company = ? and r = ?)', [utilService.currentCompany(), ddSource])[0]
        [memberList: memberList, memberTotal: memberTotal, ddSource: ddSource]
    }

    def membership = {
        def ddSource = utilService.reSource('systemRole.listing', [origin: 'members'])
        def memberList = SystemUser.findAll('from SystemUser as su where su.id in (select cu.user.id from CompanyUser as cu join cu.roles as r where cu.company = ? and r = ?) order by su.name', [utilService.currentCompany(), ddSource])
        def userList = SystemUser.findAll('from SystemUser as su where su.id in (select cu.user.id from CompanyUser as cu where cu.company = ?) order by su.name', [utilService.currentCompany()])
        [userList: userList, memberList: memberList, ddSource: ddSource]
    }

    def process = {
        def company = utilService.currentCompany()
        def ddSource = utilService.reSource('systemRole.listing', [origin: 'members'])
        def memberList = SystemUser.findAll('from SystemUser as su where su.id in (select cu.user.id from CompanyUser as cu join cu.roles as r where cu.company = ? and r = ?) order by su.name', [company, ddSource])
        def members = []
        if (params.linkages) members = params.linkages instanceof String ? [params.linkages.toLong()] : params.linkages*.toLong() as List
        def modified = []

        // Work through the existing membership
        for (member in memberList) {

            // If the existing member is not in the new membership, remove them
            if (!members.contains(member.id)) {
                ddSource.removeFromUsers(CompanyUser.findByCompanyAndUser(company, member, [cache: true]))
                modified << member
            }
        }

        // Work through the new membership
        for (member in members) {
            def found = false

            // Check if the new group is in the exiting groups
            for (m in memberList) {
                if (m.id == member) {
                    found = true
                    break
                }
            }

            // Add the new group if it wasn't in the existing groups
            if (!found) {
                def user = SystemUser.get(member)
                if (user) {
                    ddSource.addToUsers(CompanyUser.findByCompanyAndUser(company, user, [cache: true]))
                    modified << user
                }
            }
        }

        if (modified) {
            if (ddSource.save(flush: true)) {      // With deep validation
                modified.each {
                    utilService.cacheService.resetThis('userActivity', company.securityCode, it.id.toString())
                }

                flash.message = 'systemRole.members.changed'
                flash.defaultMessage = 'Role membership updated'
            } else {
                flash.message = 'systemRole.members.failed'
                flash.defaultMessage = 'Error updating the role membership'
            }
        } else {
            flash.message = 'systemRole.members.unchanged'
            flash.defaultMessage = 'No changes were made to the role membership'
        }

        redirect(action: 'members')
    }
}