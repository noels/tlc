<% import org.codehaus.groovy.grails.orm.hibernate.support.ClosureEventTriggeringInterceptor as Events %>
${'<%--'}
${' ~   Copyright 2010 Wholly Grails.'}
${' ~'}
${' ~   This file is part of the Three Ledger Core (TLC) software'}
${' ~   from Wholly Grails.'}
${' ~'}
${' ~   TLC is free software: you can redistribute it and/or modify'}
${' ~   it under the terms of the GNU General Public License as published by'}
${' ~   the Free Software Foundation, either version 3 of the License, or'}
${' ~   (at your option) any later version.'}
${' ~'}
${' ~   TLC is distributed in the hope that it will be useful,'}
${' ~   but WITHOUT ANY WARRANTY; without even the implied warranty of'}
${' ~   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the'}
${' ~   GNU General Public License for more details.'}
${' ~'}
${' ~   You should have received a copy of the GNU General Public License'}
${' ~   along with TLC.  If not, see <http://www.gnu.org/licenses/>.'}
${' --%>'}
<%=packageName%>
<% naturalName = org.codehaus.groovy.grails.commons.GrailsClassUtils.getNaturalName(domainClass.propertyName) %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="${domainClass.propertyName}.show" default="Show ${naturalName}" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="\${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="${domainClass.propertyName}.list" default="${naturalName} List" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="${domainClass.propertyName}.new" default="New ${naturalName}" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="${domainClass.propertyName}.show" default="Show ${naturalName}"/>
    <g:if test="\${flash.message}">
        <div class="message"><g:msg code="\${flash.message}" args="\${flash.args}" default="\${flash.defaultMessage}" /></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>
            <%  excludedProps = [Events.ONLOAD_EVENT,
                                 Events.BEFORE_DELETE_EVENT,
                                 Events.BEFORE_INSERT_EVENT,
                                 Events.BEFORE_UPDATE_EVENT,
                                 Events.AFTER_DELETE_EVENT,
                                 Events.AFTER_INSERT_EVENT,
                                 Events.AFTER_UPDATE_EVENT]
                genericProps = ['id', 'securityCode', 'dateCreated', 'lastUpdated', 'version']
                props = domainClass.properties.findAll { !excludedProps.contains(it.name) }
                Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
                props.each { p -> %>
            <% if (p.name == 'id' || p.name == 'securityCode') { %><g:permit activity="sysadmin"><% } %>
            <tr class="prop">
                <td valign="top" class="name"><g:msg code="${genericProps.contains(p.name) ? 'generic' : domainClass.propertyName}.${p.name}" default="${p.naturalName}" />:</td>
                <% if (p.isEnum()) { %>
                <td valign="top" class="value">\${${propertyName}?.${p.name}?.encodeAsHTML()}</td>
                <% } else if (p.oneToMany) { %>
                <%  } else if (p.manyToOne || p.oneToOne) { %>
                <td valign="top" class="value">\${${propertyName}?.${p.name}?.encodeAsHTML()}</td>
                <%  } else  { %>
                <td valign="top" class="value">\${display(bean:${propertyName}, field:'${p.name}')}</td>
                <%  } %>
            </tr>
            <% if (p.name == 'id' || p.name == 'version') { %></g:permit><% } %>
            <%  } %>
            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="\${${propertyName}?.id}" />
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="\${msg(code:'edit', 'default':'Edit')}" /></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('\${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="\${msg(code:'delete', 'default':'Delete')}" /></span>
        </g:form>
    </div>
</div>
</body>
</html>
