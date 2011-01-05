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
    <title><g:msg code="queuedTaskParam.show" default="Show Queued Task Parameter"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="usrList"><g:msg code="queuedTaskParam.list" default="Queued Task Parameter List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="queuedTaskParam.show" default="Show Queued Task Parameter"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskParamInstance, field: 'id')}</td>

                </tr>
            </g:permit>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTaskParam.param" default="Parameter"/>:</td>

                <td valign="top" class="value"><g:msg code="taskParam.name.${queuedTaskParamInstance.param.code}" default="${queuedTaskParamInstance.param.name}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="queuedTaskParam.value" default="Value"/>:</td>

                <td valign="top" class="value">${display(bean: queuedTaskParamInstance, field: 'value')}</td>

            </tr>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskParamInstance, field: 'securityCode')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskParamInstance, field: 'dateCreated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskParamInstance, field: 'lastUpdated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: queuedTaskParamInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:if test="${queuedTaskParamInstance?.queued?.currentStatus == 'waiting'}">
            <g:form>
                <input type="hidden" name="id" value="${queuedTaskParamInstance?.id}"/>
                <span class="button"><g:actionSubmit class="edit" action="usrEdit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            </g:form>
        </g:if>
    </div>
</div>
</body>
</html>
