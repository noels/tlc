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
    <title><g:msg code="${domainClass.propertyName}.list" default="${naturalName} List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="\${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="${domainClass.propertyName}.new" default="New ${naturalName}" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="${domainClass.propertyName}.list" default="${naturalName} List"/>
    <g:if test="\${flash.message}">
        <div class="message"><g:msg code="\${flash.message}" args="\${flash.args}" default="\${flash.defaultMessage}" /></div>
    </g:if>
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
        testables = ''
        props.each {p ->
            testables += (testables) ? ", ${p.name}" : "${p.name}"
        }
    %>
    <div class="criteria">
        <g:criteria include="${testables}"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>
            <%  props.eachWithIndex { p,i ->
                    if(i < 6) {
                        if(p.isAssociation()) { %>
                <th><g:msg code="${domainClass.propertyName}.${p.name}" default="${p.naturalName}" /></th>
            <%          } else { %>
                <g:sortableColumn property="${p.name}" title="${p.naturalName}" titleKey="${domainClass.propertyName}.${p.name}" />
            <%  }   }   } %>
            </tr>
            </thead>
            <tbody>
            <g:each in="\${${propertyName}List}" status="i" var="${propertyName}">
                <tr class="\${(i % 2) == 0 ? 'odd' : 'even'}">
                <%  props.eachWithIndex { p,i ->
                        if(i == 0) { %>
                    <td><g:link action="show" id="\${${propertyName}.id}">\${display(bean:${propertyName}, field:'${p.name}')}</g:link></td>
                <%      } else if(i < 6) { %>
                    <td>\${display(bean:${propertyName}, field:'${p.name}')}</td>
                <%  }   } %>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="\${${propertyName}Total}" />
    </div>
</div>
</body>
</html>
