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
    <title><g:msg code="operation.title" default="Operating State"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="operation.title" default="Operating State"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemActionInstance}">
        <div class="errors">
            <g:listErrors bean="${systemActionInstance}"/>
        </div>
    </g:hasErrors>
    <div align="center">
        <g:if test="${queueStatus}">
            <g:msg code="queuedTask.usr.status" args="${[queueStatus.status]}" default="The task queue is currently ${queueStatus.status}."/>
        </g:if>
        <g:else>
            <g:msg code="queuedTask.queue.status.missing" default="Currently there is no task queue executor available. Please notify the system supervisor."/>
        </g:else>
    </div>
    <p>&nbsp;</p>
    <g:form method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="state"><g:msg code="operation.state" default="Operating State"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'state', 'errors')}">
                        <g:select initialField="true" id="state" name="state" from="${operationInstance.constraints.state.inList}" value="${operationInstance.state}" valueMessagePrefix="operation.state"/>&nbsp;<g:help code="operation.state"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="operate" value="${msg(code:'update', 'default':'Update')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
