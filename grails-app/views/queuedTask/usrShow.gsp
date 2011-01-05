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
    <title><g:msg code="queuedTask.show" default="Show Queued Task"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="usrList"><g:msg code="queuedTask.usr.list" default="User Task Queue"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="queuedTask.show" default="Show Queued Task"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div align="center"><g:msg code="generic.server.time" args="${[new Date()]}" default="The current date and time on the server is ${new Date()}."/></div>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'id')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.submittedAt" default="Submitted At"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'dateCreated', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.task" default="Task"/>:</td>

                <td valign="top" class="value"><g:msg code="task.name.${queuedTaskInstance.task.code}" default="${queuedTaskInstance.task.name}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.currentStatus" default="Current Status"/>:</td>

                <td valign="top" class="value"><g:msg code="queuedTask.currentStatus.${queuedTaskInstance.currentStatus}" default="${queuedTaskInstance.currentStatus}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.scheduled" default="Scheduled"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'scheduled')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.preferredStart" default="Preferred Start"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'preferredStart', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.startedAt" default="Started At"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'startedAt', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.completedAt" default="Completed At"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'completedAt', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTask.completionMessage" default="Completion Message"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'completionMessage')}</td>

            </tr>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'securityCode')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'dateCreated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'lastUpdated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
        <g:if test="${queuedTaskInstance?.currentStatus == 'waiting'}">
            <div class="buttons">
            <g:form>
                <input type="hidden" name="id" value="${queuedTaskInstance?.id}"/>
                <span class="button"><g:actionSubmit class="edit" action="usrEdit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
                <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="usrDelete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
            </g:form>
            </div>
        </g:if>
</div>
</body>
</html>
