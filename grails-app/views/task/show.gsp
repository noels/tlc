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
    <title><g:msg code="task.show" default="Show Task"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="task.list" default="Task List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="task.new" default="New Task"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="task.show" default="Show Task"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div align="center"><g:msg code="generic.server.time" args="${[new Date()]}" default="The current date and time on the server is ${new Date()}."/></div>
    <div class="dialog">
        <table>
            <tbody>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                    <td valign="top" class="value">${display(bean: taskInstance, field: 'id')}</td>

                </tr>
            </g:permit>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.code" default="Code"/>:</td>

                <td valign="top" class="value">${display(bean: taskInstance, field: 'code')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.name" default="Name"/>:</td>

                <td valign="top" class="value"><g:msg code="task.name.${taskInstance.code}" default="${taskInstance.name}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.executable" default="Executable"/>:</td>

                <td valign="top" class="value">${display(bean: taskInstance, field: 'executable')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.allowOnDemand" default="Allow On Demand"/>:</td>

                <td valign="top" class="value">${display(bean: taskInstance, field: 'allowOnDemand')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.activity" default="Activity"/>:</td>

                <td valign="top" class="value">${taskInstance?.activity?.code?.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.schedule" default="Schedule"/>:</td>

                <td valign="top" class="value">${display(bean: taskInstance, field: 'schedule')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.nextScheduledRun" default="Next Scheduled Run"/>:</td>

                <td valign="top" class="value">${display(bean: taskInstance, field: 'nextScheduledRun', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.user" default="User"/>:</td>

                <td valign="top" class="value">${taskInstance?.user?.name?.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="task.retentionDays" default="Retention Days"/>:</td>

                <td valign="top" class="value">${display(bean: taskInstance, field: 'retentionDays')}</td>

            </tr>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="task.systemOnly" default="System Only"/>:</td>

                    <td valign="top" class="value">${display(bean: taskInstance, field: 'systemOnly')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: taskInstance, field: 'securityCode')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: taskInstance, field: 'dateCreated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: taskInstance, field: 'lastUpdated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: taskInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${taskInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
