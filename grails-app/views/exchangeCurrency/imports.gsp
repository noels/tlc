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
<%@ page import="com.whollygrails.tlc.corp.ExchangeCurrency; com.whollygrails.tlc.sys.SystemCurrency" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="exchangeCurrency.imports" default="Import Predefined Currency"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="exchangeCurrency.list" default="Currency List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="exchangeCurrency.new" default="New Currency"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="exchangeCurrency.imports" default="Import Predefined Currency"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div align="center" style="margin-top: 5px;margin-bottom: 15px;">
        <p><g:msg code="exchangeCurrency.imports.message" default="The system has many currencies already defined for you. Use the Import Predefined Currency facility to save time and effort."/></p>
    </div>
    <g:form action="importing" method="post">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name">
                    <label for="systemCurrency.id"><g:msg code="exchangeCurrency.imports.currency" default="Predefined Currency"/>:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: exchangeCurrencyInstance, field: 'code', 'errors')}">
                    <g:domainSelect initialField="true" name="systemCurrency.id" options="${SystemCurrency.list()}" prefix="currency.name" code="code" default="name"/>&nbsp;<g:help code="exchangeCurrency.imports.currency"/>
                </td>
            </tr>

            </tbody>
        </table>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'exchangeCurrency.imports.button', 'default': 'Import')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
