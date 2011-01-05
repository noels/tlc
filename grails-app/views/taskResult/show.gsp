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
    <title><g:msg code="taskResult.show" default="Show Task Result"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="taskResult.list" default="Task Result List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="taskResult.new" default="New Task Result"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="taskResult.show" default="Show Task Result"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                    <td valign="top" class="value">${display(bean: taskResultInstance, field: 'id')}</td>

                </tr>
            </g:permit>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taskResult.code" default="Code"/>:</td>

                <td valign="top" class="value">${display(bean: taskResultInstance, field: 'code')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taskResult.name" default="Name"/>:</td>

                <td valign="top" class="value"><g:msg code="taskResult.name.${taskResultInstance.code}" default="${taskResultInstance.name}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taskResult.sequencer" default="Sequencer"/>:</td>

                <td valign="top" class="value">${display(bean: taskResultInstance, field: 'sequencer')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taskResult.dataType" default="Data Type"/>:</td>

                <td valign="top" class="value"><g:msg code="generic.dataType.${taskResultInstance.dataType}" default="${taskResultInstance.dataType}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taskResult.dataScale" default="Data Scale"/>:</td>

                <td valign="top" class="value">${display(bean: taskResultInstance, field: 'dataScale')}</td>

            </tr>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: taskResultInstance, field: 'securityCode')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: taskResultInstance, field: 'dateCreated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: taskResultInstance, field: 'lastUpdated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: taskResultInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${taskResultInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
