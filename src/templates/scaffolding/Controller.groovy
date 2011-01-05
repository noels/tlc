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
<% import org.codehaus.groovy.grails.orm.hibernate.support.ClosureEventTriggeringInterceptor as Events %>
<%=packageName ? "package ${packageName}\n\n" : ''%>class ${className}Controller {
    <%  excludedProps = ['id', 'securityCode', 'dateCreated', 'lastUpdated', 'version',
        Events.ONLOAD_EVENT,
        Events.BEFORE_DELETE_EVENT,
        Events.BEFORE_INSERT_EVENT,
        Events.BEFORE_UPDATE_EVENT,
        Events.AFTER_DELETE_EVENT,
        Events.AFTER_INSERT_EVENT,
        Events.AFTER_UPDATE_EVENT]
    props = domainClass.properties.findAll { !excludedProps.contains(it.name) && it.type != Set.class }
    Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
    editables = ''
    sortables = ''
    defaultSortable = ''
    props.each {p ->
        editables += (editables) ? ", '${p.name}'" : "'${p.name}'"
        if (!p.isAssociation()) {
            if (sortables) {
                sortables += ", '${p.name}'"
            } else {
                sortables = "'${p.name}'"
                defaultSortable = "'${p.name}'"
            }
        }
    }
    naturalName = org.codehaus.groovy.grails.commons.GrailsClassUtils.getNaturalName(domainClass.propertyName)
%>
    // Injected services
    def utilService

    // Security settings
    def activities = [default: 'sysadmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = [${sortables}].contains(params.sort) ? params.sort : ${defaultSortable}
        // def ddSource = utilService.source('???.list')
        [${propertyName}List: ${className}.selectList(securityCode: utilService.currentCompany().securityCode), ${propertyName}Total: ${className}.selectCount()] // ddSource: ddSource
    }

    def show = {
        def ${propertyName} = ${className}.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!${propertyName}) {
            flash.message = '${domainClass.propertyName}.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "${naturalName} not found with id \${params.id}"
            redirect(action: list)
        } else {
            return [${propertyName}: ${propertyName}]
        }
    }

    def delete = {
        def ${propertyName} = ${className}.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (${propertyName}) {
            try {
                ${propertyName}.delete(flush: true)
                flash.message = '${domainClass.propertyName}.deleted'
                flash.args = [${propertyName}.toString()]
                flash.defaultMessage = "${naturalName} \${${propertyName}.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = '${domainClass.propertyName}.not.deleted'
                flash.args = [${propertyName}.toString(), e.class.simpleName]
                flash.defaultMessage = "${naturalName} \${${propertyName}.toString()} could not be deleted (\${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = '${domainClass.propertyName}.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "${naturalName} not found with id \${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def ${propertyName} = ${className}.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!${propertyName}) {
            flash.message = '${domainClass.propertyName}.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "${naturalName} not found with id \${params.id}"
            redirect(action: list)
        } else {
            return [${propertyName}: ${propertyName}]
        }
    }

    def update = {
        def ${propertyName} = ${className}.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (${propertyName}) {
            if (params.version) {
                def version = params.version.toLong()
                if (${propertyName}.version > version) {
                    ${propertyName}.errors.rejectValue('version', '${domainClass.propertyName}.optimistic.locking.failure', 'Another user has updated this ${naturalName} while you were editing')
                    render(view: 'edit', model: [${propertyName}: ${propertyName}])
                    return
                }
            }

            ${propertyName}.properties[${editables}] = params
            // utilService.verify(${propertyName}, ['???'])             // Ensure correct references
            if (!${propertyName}.hasErrors() && ${propertyName}.saveThis()) {
                flash.message = '${domainClass.propertyName}.updated'
                flash.args = [${propertyName}.toString()]
                flash.defaultMessage = "${naturalName} \${${propertyName}.toString()} updated"
                redirect(action: show, id: ${propertyName}.id)
            } else {
                render(view: 'edit', model: [${propertyName}: ${propertyName}])
            }
        } else {
            flash.message = '${domainClass.propertyName}.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "${naturalName} not found with id \${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def ${propertyName} = new ${className}()
        // ${propertyName}.company = utilService.currentCompany()   // Ensure correct company
        // ${propertyName}.??? = utilService.reSource('???.list')   // Ensure correct parent
        return [${propertyName}: ${propertyName}]
    }

    def save = {
        def ${propertyName} = new ${className}()
        ${propertyName}.properties[${editables}] = params
        // ${propertyName}.company = utilService.currentCompany()   // Ensure correct company
        // ${propertyName}.??? = utilService.reSource('???.list')   // Ensure correct parent
        // utilService.verify(${propertyName}, ['???'])             // Ensure correct references
        if (!${propertyName}.hasErrors() && ${propertyName}.saveThis()) {
            flash.message = '${domainClass.propertyName}.created'
            flash.args = [${propertyName}.toString()]
            flash.defaultMessage = "${naturalName} \${${propertyName}.toString()} created"
            redirect(action: show, id: ${propertyName}.id)
        } else {
            render(view: 'create', model: [${propertyName}: ${propertyName}])
        }
    }
}