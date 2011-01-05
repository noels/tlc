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
    <title><g:msg code="queuedTask.usr.list" default="User Task Queue"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="queuedTask.usr.list" default="User Task Queue"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div align="center"><g:msg code="generic.server.time" args="${[new Date()]}" default="The current date and time on the server is ${new Date()}."/>
    <g:if test="${queueStatus}">
        <g:msg code="queuedTask.usr.status" args="${[queueStatus.status]}" default="The task queue is currently ${queueStatus.status}."/>
    </g:if>
    <g:else>
        <g:msg code="queuedTask.queue.status.missing" default="Currently there is no task queue executor available. Please notify the system supervisor."/>
    </g:else>
    </div>
    <div class="criteria">
        <g:criteria include="dateCreated, currentStatus*, scheduled, preferredStart, startedAt, completedAt, completionMessage"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="dateCreated" title="Submitted At" titleKey="queuedTask.submittedAt"/>

                <th><g:msg code="queuedTask.task" default="Task"/></th>

                <g:sortableColumn property="currentStatus" title="Current Status" titleKey="queuedTask.currentStatus"/>

                <g:sortableColumn property="scheduled" title="Scheduled" titleKey="queuedTask.scheduled"/>

                <g:sortableColumn property="preferredStart" title="Preferred Start" titleKey="queuedTask.preferredStart"/>

                <g:sortableColumn property="startedAt" title="Started At" titleKey="queuedTask.startedAt"/>

                <g:sortableColumn property="completedAt" title="Completed At" titleKey="queuedTask.completedAt"/>

                <g:sortableColumn property="completionMessage" title="Completion Message" titleKey="queuedTask.completionMessage"/>

                <th><g:msg code="queuedTask.parameters" default="Parameters"/></th>

                <th><g:msg code="queuedTask.results" default="Results"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${queuedTaskInstanceList}" status="i" var="queuedTaskInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="usrShow" id="${queuedTaskInstance.id}">${display(bean: queuedTaskInstance, field: 'dateCreated', scale: 2)}</g:link></td>

                    <td><g:msg code="task.name.${queuedTaskInstance.task.code}" default="${queuedTaskInstance.task.name}"/></td>

                    <td><g:msg code="queuedTask.currentStatus.${queuedTaskInstance.currentStatus}" default="${queuedTaskInstance.currentStatus}"/></td>

                    <td>${display(bean: queuedTaskInstance, field: 'scheduled')}</td>

                    <td>${display(bean: queuedTaskInstance, field: 'preferredStart', scale: 2)}</td>

                    <td>${display(bean: queuedTaskInstance, field: 'startedAt', scale: 2)}</td>

                    <td>${display(bean: queuedTaskInstance, field: 'completedAt', scale: 2)}</td>

                    <td>${display(bean: queuedTaskInstance, field: 'completionMessage')}</td>

                    <td><g:drilldown controller="queuedTaskParam" action="usrList" value="${queuedTaskInstance.id}"/></td>

                    <td><g:drilldown controller="queuedTaskResult" action="usrList" value="${queuedTaskInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${queuedTaskInstanceTotal}"/>
    </div>
</div>
</body>
</html>
