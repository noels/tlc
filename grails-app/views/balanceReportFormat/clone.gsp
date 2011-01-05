<%--
 ~   Copyright 2010 Wholly Grails.
 ~
 ~   This file is part of the Three Ledger Core (TLC) software
 ~   from Wholly Grails.
 ~
 ~   TLC is free software: you can redistribute it and/or modify
 ~   it under the terms of the GNU General Public License as published by
 ~   the Free Software Foundation, either version 3 of the License, or
 ~   (at your option) any later version.
 ~
 ~   TLC is distributed in the hope that it will be useful,
 ~   but WITHOUT ANY WARRANTY; without even the implied warranty of
 ~   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ~   GNU General Public License for more details.
 ~
 ~   You should have received a copy of the GNU General Public License
 ~   along with TLC.  If not, see <http://www.gnu.org/licenses/>.
 --%>
<%@ page import="com.whollygrails.tlc.books.BalanceReportFormat" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="balanceReportFormat.clone" default="Clone Report Format" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="balanceReportFormat.list" default="Report Format List" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="balanceReportFormat.clone" default="Clone Report Format"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>
    <g:hasErrors bean="${balanceReportFormatInstance}">
        <div class="errors">
            <g:listErrors bean="${balanceReportFormatInstance}" />
        </div>
    </g:hasErrors>
    <g:form action="cloning" method="post" >
        <input type="hidden" name="id" value="${balanceReportFormatInstance?.id}" />
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="name"><g:msg code="balanceReportFormat.name" default="Name"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: balanceReportFormatInstance, field: 'name', 'errors')}">
                        <input initialField="true" type="text" maxlength="30" size="30" id="name" name="name" value="${display(bean: balanceReportFormatInstance, field: 'name')}"/>&nbsp;<g:help code="balanceReportFormat.name"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code:'create', 'default':'Create')}" /></span>
        </div>
    </g:form>
</div>
</body>
</html>
