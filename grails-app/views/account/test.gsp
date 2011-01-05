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
<%@ page import="com.whollygrails.tlc.books.Account" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="account.test" default="Test Account Auto-Creation"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="account.test" default="Test Account Auto-Creation"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${accountInstance}">
        <div class="errors">
            <g:listErrors bean="${accountInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="testing" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="code"><g:msg code="account.code" default="Code"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'code', 'errors')}">
                        <input initialField="true" type="text" maxlength="87" size="30" id="code" name="code" value="${display(bean: accountInstance, field: 'code')}"/>&nbsp;<g:help code="account.codetest"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.name" default="Name" />:</td>

                    <td valign="top" class="value">${display(bean:accountInstance, field:'name')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.section" default="Section" />:</td>

                    <td valign="top" class="value">${accountInstance?.section?.name?.encodeAsHTML()}</td>

                </tr>
                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'account.test.button', 'default': 'Test')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
