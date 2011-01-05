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
    <title><g:msg code="${domainClass.propertyName}.create" default="Create ${naturalName}" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="\${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="${domainClass.propertyName}.list" default="${naturalName} List" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="${domainClass.propertyName}.create" default="Create ${naturalName}"/>
    <g:if test="\${flash.message}">
        <div class="message"><g:msg code="\${flash.message}" args="\${flash.args}" default="\${flash.defaultMessage}" /></div>
    </g:if>
    <g:hasErrors bean="\${${propertyName}}">
        <div class="errors">
            <g:listErrors bean="\${${propertyName}}" />
        </div>
    </g:hasErrors>
    <g:form action="save" method="post" <%= multiPart ? ' enctype="multipart/form-data"' : '' %>>
        <g:render template="dialog" model="[${propertyName}: ${propertyName}]" />
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
<div class="dialog">
    <table>
        <tbody>
        <%  excludedProps = ['id', 'securityCode', 'dateCreated', 'lastUpdated', 'version',
                             Events.ONLOAD_EVENT,
                             Events.BEFORE_DELETE_EVENT,
                             Events.BEFORE_INSERT_EVENT,
                             Events.BEFORE_UPDATE_EVENT,
                             Events.AFTER_DELETE_EVENT,
                             Events.AFTER_INSERT_EVENT,
                             Events.AFTER_UPDATE_EVENT]
            props = domainClass.properties.findAll { !excludedProps.contains(it.name) }
            Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
            ftt = true
            props.each { p ->
                if (p.type != Set.class) {
                    cp = domainClass.constrainedProperties[p.name]
                    display = (cp ? cp.display : true)
                    if (display) {
                        if (ftt) {%>
        ${'<%-- ***** First data entry field on the page should be given an initialField="true" attribute ***** --%>'}<% ftt = false }%>
        <tr class="prop">
            <td valign="top" class="name">
                <label for="${p.name}"><g:msg code="${domainClass.propertyName}.${p.name}" default="${p.naturalName}" />:</label>
            </td>
            <td valign="top" class="value \${hasErrors(bean:${propertyName},field:'${p.name}','errors')}">
                ${renderEditor(p)}&nbsp;<g:help code="${domainClass.propertyName}.${p.name}"/>
            </td>
        </tr>
        <%  }   }   } %>
        </tbody>
    </table>
</div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="\${msg(code:'create', 'default':'Create')}" /></span>
        </div>
    </g:form>
</div>
</body>
</html>
