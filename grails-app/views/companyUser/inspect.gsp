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
    <title><g:msg code="companyUser.show" default="Show Company User"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="display"><g:msg code="companyUser.list" default="Company User List"/></g:link></span>
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
    <g:if test="${!companyUserInstance.user.administrator}">
        <div align="center" style="margin-top:5px;margin-bottom:10px;">
            <g:if test="${otherCompanies <= 0}">
                <g:msg code="companyUser.zero.message" default="This user does not belong to any other company. You may simply remove them as a member of this company, leaving their login id active for future use by another company, or you may delete their login id altogether."/>
            </g:if>
            <g:elseif test="${otherCompanies == 1}">
                <g:msg code="companyUser.one.message" default="This user belongs to 1 other company. You may remove them from membership of the current company but this will not remove them from the other company. Only a System Administrator can delete a user from multiple companies simultaneously."/>
            </g:elseif>
            <g:else>
                <g:msg code="companyUser.many.message" args="${[otherCompanies]}" default="This user belongs to ${otherCompanies} other companies. You may remove them from membership of the current company but this will not remove them from the other companies. Only a System Administrator can delete a user from multiple companies simultaneously."/>
            </g:else>
        </div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.loginId" default="Login Id"/>:</td>

                <td valign="top" class="value">${companyUserInstance.user.loginId.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.name" default="Name"/>:</td>

                <td valign="top" class="value">${companyUserInstance.user.name.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.lastLogin" default="Last Login"/>:</td>

                <td valign="top" class="value">${display(value: companyUserInstance.user.lastLogin, scale: 2)}</td>

            </tr>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${companyUserInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="remove" value="${msg(code:'companyUser.remove', 'default':'Remove')}"/></span>
            <g:if test="${(!companyUserInstance.user.administrator && otherCompanies <= 0)}">
                <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="terminate" value="${msg(code:'delete', 'default':'Delete')}"/></span>
            </g:if>
        </g:form>
    </div>
</div>
</body>
</html>
