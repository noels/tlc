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
<%@ page import="com.whollygrails.tlc.corp.CompanyUser" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="companyUser.add" default="Add User"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="display"><g:msg code="companyUser.list" default="Company User List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="companyUser.add" default="Add User"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemUserInstance}">
        <div class="errors">
            <g:listErrors bean="${systemUserInstance}"/>
        </div>
    </g:hasErrors>
    <div align="center" style="margin-bottom:5px;"><g:msg code="companyUser.add.message" default="The user should have already registered to use the system and should have supplied you with their (case sensitive) login id so that you may add them to this company."/></div>
    <g:form action="adding" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="loginId"><g:msg code="systemUser.loginId" default="Login Id" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:systemUserInstance,field:'loginId','errors')}">
                        <input initialField="true" type="text" maxlength="20" size="20" id="loginId" name="loginId" value="${display(bean:systemUserInstance,field:'loginId')}"/>&nbsp;<g:help code="systemUser.loginId"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'companyUser.add.button', 'default': 'Add')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
