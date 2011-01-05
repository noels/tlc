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
    <title><g:msg code="task.list" default="Task List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="task.new" default="New Task"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="task.list" default="Task List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div align="center"><g:msg code="generic.server.time" args="${[new Date()]}" default="The current date and time on the server is ${new Date()}."/></div>
    <div class="criteria">
        <g:criteria include="code, executable, allowOnDemand, schedule, nextScheduledRun, retentionDays, systemOnly"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="task.code"/>

                <th><g:msg code="task.name" default="Name"/></th>

                <g:sortableColumn property="executable" title="Executable" titleKey="task.executable"/>

                <g:sortableColumn property="allowOnDemand" title="Allow On Demand" titleKey="task.allowOnDemand"/>

                <th><g:msg code="task.activity" default="Activity"/></th>

                <g:sortableColumn property="schedule" title="Schedule" titleKey="task.schedule"/>

                <g:sortableColumn property="nextScheduledRun" title="Next Scheduled Run" titleKey="task.nextScheduledRun"/>

                <th><g:msg code="task.user" default="User"/></th>

                <g:sortableColumn property="retentionDays" title="Retention Days" titleKey="task.retentionDays"/>

                <g:permit activity="sysadmin">
                    <g:sortableColumn property="systemOnly" title="System Only" titleKey="task.systemOnly"/>
                </g:permit>

                <th><g:msg code="task.parameters" default="Parameters"/></th>

                <th><g:msg code="task.results" default="Results"/></th>

                <g:permit activity="sysadmin">
                    <th><g:msg code="task.propagate" default="Propagate"/>&nbsp;<g:help code="task.propagate"/></th>
                </g:permit>

            </tr>
            </thead>
            <tbody>
            <g:each in="${taskInstanceList}" status="i" var="taskInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${taskInstance.id}">${display(bean: taskInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="task.name.${taskInstance.code}" default="${taskInstance.name}"/></td>

                    <td>${display(bean: taskInstance, field: 'executable')}</td>

                    <td>${display(bean: taskInstance, field: 'allowOnDemand')}</td>

                    <td>${taskInstance?.activity?.code?.encodeAsHTML()}</td>

                    <td>${display(bean: taskInstance, field: 'schedule')}</td>

                    <td>${display(bean: taskInstance, field: 'nextScheduledRun', scale: 2)}</td>

                    <td>${taskInstance?.user?.name?.encodeAsHTML()}</td>

                    <td>${display(bean: taskInstance, field: 'retentionDays')}</td>

                    <g:permit activity="sysadmin">
                        <td>${display(bean: taskInstance, field: 'systemOnly')}</td>
                    </g:permit>

                    <td><g:drilldown controller="taskParam" value="${taskInstance.id}"/></td>

                    <td><g:drilldown controller="taskResult" value="${taskInstance.id}"/></td>

                    <g:permit activity="sysadmin">
                        <g:if test="${!taskInstance.systemOnly && taskInstance.activity?.code != 'sysadmin'}">
                            <td><g:form method="post" action="propagate" id="${taskInstance.id}"><input type="submit" value="${msg(code: 'task.propagate', default: 'Propagate')}"/></g:form></td>
                        </g:if>
                        <g:else>
                            <td></td>
                        </g:else>
                    </g:permit>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${taskInstanceTotal}"/>
    </div>
</div>
</body>
</html>
