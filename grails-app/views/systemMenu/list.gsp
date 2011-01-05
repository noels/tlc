<%--
 ~  Copyright 2010 Wholly Grails.
 ~
 ~  This file is part of the Three Ledger Core (TLC) software
 ~  from Wholly Grails.
 ~
 ~  TLC is free software: you can redistribute it and/or modify
 ~  it under the terms of the GNU General Public License as published by
 ~  the Free Software Foundation, either version 3 of the License, or
 ~  (at your option) any later version.
 ~
 ~  TLC is distributed in the hope that it will be useful,
 ~  but WITHOUT ANY WARRANTY; without even the implied warranty of
 ~  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ~  GNU General Public License for more details.
 ~
 ~  You should have received a copy of the GNU General Public License
 ~  along with TLC.  If not, see <http://www.gnu.org/licenses/>.
 --%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemMenu.list" default="Menu Option List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemMenu.new" default="New Menu Option"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemMenu.list" default="Menu Option List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="path, sequencer, type*, command, parameters"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="path" title="Path" titleKey="systemMenu.path"/>

                <th><g:msg code="systemMenu.title" default="Title"/></th>

                <g:sortableColumn property="sequencer" title="Sequencer" titleKey="systemMenu.sequencer"/>

                <th><g:msg code="systemMenu.type" default="Type"/></th>

                <g:sortableColumn property="command" title="Command" titleKey="systemMenu.command"/>

                <g:sortableColumn property="parameters" title="Parameters" titleKey="systemMenu.parameters"/>

                <th><g:msg code="systemMenu.activity" default="Activity"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemMenuInstanceList}" status="i" var="systemMenuInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemMenuInstance.id}">${display(bean: systemMenuInstance, field: 'path')}</g:link></td>

                    <td><g:msg code="menu.option.${systemMenuInstance.path}" default="${systemMenuInstance.title}"/></td>

                    <td>${display(bean: systemMenuInstance, field: 'sequencer')}</td>

                    <td><g:msg code="systemMenu.type.${systemMenuInstance.type}" default="${systemMenuInstance.type}"/></td>

                    <td>${display(bean: systemMenuInstance, field: 'command')}</td>

                    <g:if test="${(systemMenuInstance.type == 'submenu' && systemMenuInstance.parameters)}">
                        <td><g:msg code="menu.submenu.${systemMenuInstance.path}" default="${systemMenuInstance.parameters}"/></td>
                    </g:if>
                    <g:else>
                        <td>${display(bean: systemMenuInstance, field: 'parameters')}</td>
                    </g:else>

                    <td>${display(bean: systemMenuInstance, field: 'activity')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemMenuInstanceTotal}"/>
    </div>
</div>
</body>
</html>
