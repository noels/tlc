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
    <title><g:msg code="companyUser.show" default="Show Company User"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="companyUser.list" default="Company User List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="companyUser.new" default="New Company User"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="companyUser.show" default="Show Company User"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${companyUserInstance}">
        <div class="errors">
            <g:listErrors bean="${companyUserInstance}"/>
        </div>
    </g:hasErrors>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                <td valign="top" class="value">${display(bean: companyUserInstance, field: 'id')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="companyUser.user" default="User"/>:</td>

                <td valign="top" class="value">${companyUserInstance.user.name.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="companyUser.company" default="Company"/>:</td>

                <td valign="top" class="value">${companyUserInstance.company.name.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="companyUser.lastUsed" default="Last Used"/>:</td>

                <td valign="top" class="value">${display(bean: companyUserInstance, field: 'lastUsed', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                <td valign="top" class="value">${display(bean: companyUserInstance, field: 'securityCode')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                <td valign="top" class="value">${display(bean: companyUserInstance, field: 'dateCreated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                <td valign="top" class="value">${display(bean: companyUserInstance, field: 'lastUpdated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                <td valign="top" class="value">${display(bean: companyUserInstance, field: 'version')}</td>

            </tr>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${companyUserInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
