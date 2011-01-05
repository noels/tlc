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
<%@ page import="com.whollygrails.tlc.books.Recurring" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="recurring.create" default="Create Recurring Bank Transaction" /></title>
    <g:yuiResources require="connection"/>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="recurring.list" default="Recurring Bank Transaction List" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="recurring.create" default="Create Recurring Bank Transaction"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>
    <g:hasErrors bean="${recurringInstance}">
        <div class="errors">
            <g:listErrors bean="${recurringInstance}" />
        </div>
    </g:hasErrors>
    <div id="ajaxErrorMessage" class="errors" style="visibility:hidden;"></div>
    <g:form method="post" >
        <input type="hidden" id="view" name="view" value="create"/>
        <g:render template="dialog" model="[recurringInstance: recurringInstance, bankAccountList: bankAccountList, documentTypeList: documentTypeList, currencyList: currencyList, settings: settings]" />
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="save" value="${msg(code:'create', 'default':'Create')}" /></span>
            <span class="button"><g:actionSubmit class="edit" action="lines" value="${msg(code:'document.more.lines', 'default':'More Lines')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
