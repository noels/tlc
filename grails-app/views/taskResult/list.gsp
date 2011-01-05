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
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="taskResult.list" default="Task Result List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="taskResult.new" default="New Task Result"/></g:link></span>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="taskResult.list.for" args="${[message(code: 'task.name.' + ddSource.code, default: ddSource.name)]}" default="Task Result List for Task ${message(code: 'task.name.' + ddSource.code, default: ddSource.name)}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="taskResult.list" default="Task Result List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="code, sequencer, dataType, dataScale"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="taskResult.code"/>

                <th><g:msg code="taskResult.name" default="Name"/></th>

                <g:sortableColumn property="sequencer" title="Sequencer" titleKey="taskResult.sequencer"/>

                <g:sortableColumn property="dataType" title="Data Type" titleKey="taskResult.dataType"/>

                <g:sortableColumn property="dataScale" title="Data Scale" titleKey="taskResult.dataScale"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${taskResultInstanceList}" status="i" var="taskResultInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${taskResultInstance.id}">${display(bean: taskResultInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="taskResult.name.${taskResultInstance.code}" default="${taskResultInstance.name}"/></td>

                    <td>${display(bean: taskResultInstance, field: 'sequencer')}</td>

                    <td><g:msg code="generic.dataType.${taskResultInstance.dataType}" default="${taskResultInstance.dataType}"/></td>

                    <td>${display(bean: taskResultInstance, field: 'dataScale')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${taskResultInstanceTotal}"/>
    </div>
</div>
</body>
</html>
