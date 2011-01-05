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
    <title><g:msg code="account.list" default="Account List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="account.new" default="New Account" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="account.list" default="Account List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, name, active, status*, revaluationMethod*"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="account.code" />

                <g:sortableColumn property="name" title="Name" titleKey="account.name" />

                <th><g:msg code="account.currency" default="Currency" /></th>

                <g:sortableColumn property="revaluationMethod" title="Revaluation Method" titleKey="account.revaluationMethod" />

                <g:sortableColumn property="status" title="Status" titleKey="account.status" />

                <th><g:msg code="account.type" default="Type" /></th>

                <g:sortableColumn property="active" title="Active" titleKey="account.active" />

                <th><g:msg code="account.section" default="Section" /></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${accountInstanceList}" status="i" var="accountInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${accountInstance.id}">${display(bean:accountInstance, field:'code')}</g:link></td>

                    <td>${display(bean:accountInstance, field:'name')}</td>

                    <td>${msg(code: 'currency.name.' + accountInstance.currency.code, default: accountInstance.currency.name)}</td>

                    <td>${accountInstance.revaluationMethod ? msg(code: 'account.revaluationMethod.' + accountInstance.revaluationMethod, default: accountInstance.revaluationMethod) : ''}</td>

                    <td><g:msg code="account.status.${accountInstance.status}" default="${accountInstance.status}"/></td>

                    <td>${accountInstance.type ? msg(code: 'systemAccountType.name.' + accountInstance.type.code, default: accountInstance.type.name) : ''}</td>

                    <td>${display(bean:accountInstance, field:'active')}</td>

                    <td>${accountInstance?.section?.name?.encodeAsHTML()}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${accountInstanceTotal}" />
    </div>
</div>
</body>
</html>
