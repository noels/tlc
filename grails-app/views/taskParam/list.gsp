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
    <title><g:msg code="taskParam.list" default="Task Parameter List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="taskParam.new" default="New Task Parameter"/></g:link></span>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="taskParam.list.for" args="${[message(code: 'task.name.' + ddSource.code, default: ddSource.name)]}" default="Task Parameter List for Task ${message(code: 'task.name.' + ddSource.code, default: ddSource.name)}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="taskParam.list" default="Task Parameter List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="code, sequencer, dataType, dataScale, defaultValue, required"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="taskParam.code"/>

                <th><g:msg code="taskParam.name" default="Name"/></th>

                <g:sortableColumn property="sequencer" title="Sequencer" titleKey="taskParam.sequencer"/>

                <g:sortableColumn property="dataType" title="Data Type" titleKey="taskParam.dataType"/>

                <g:sortableColumn property="dataScale" title="Data Scale" titleKey="taskParam.dataScale"/>

                <g:sortableColumn property="defaultValue" title="Default Value" titleKey="taskParam.defaultValue"/>

                <g:sortableColumn property="required" title="Required" titleKey="taskParam.required"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${taskParamInstanceList}" status="i" var="taskParamInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${taskParamInstance.id}">${display(bean: taskParamInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="taskParam.name.${taskParamInstance.code}" default="${taskParamInstance.name}"/></td>

                    <td>${display(bean: taskParamInstance, field: 'sequencer')}</td>

                    <td><g:msg code="generic.dataType.${taskParamInstance.dataType}" default="${taskParamInstance.dataType}"/></td>

                    <td>${display(bean: taskParamInstance, field: 'dataScale')}</td>

                    <td>${display(bean: taskParamInstance, field: 'defaultValue')}</td>

                    <td>${display(bean: taskParamInstance, field: 'required')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${taskParamInstanceTotal}"/>
    </div>
</div>
</body>
</html>
