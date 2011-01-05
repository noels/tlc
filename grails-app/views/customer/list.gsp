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
<%@ page import="com.whollygrails.tlc.books.Customer" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="customer.list" default="Customer List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="import" action="imports"><g:msg code="customer.imports" default="Import Customers" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="customer.new" default="New Customer" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="customer.list" default="Customer List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, name, accountCreditLimit, accountCurrentBalance, settlementDays, taxId, periodicSettlement, active, revaluationMethod*"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="customer.code" />

                <g:sortableColumn property="name" title="Name" titleKey="customer.name" />

                <g:sortableColumn property="accountCurrentBalance" title="Current Balance" titleKey="customer.accountCurrentBalance" class="right"/>

                <g:sortableColumn property="accountCreditLimit" title="Credit Limit" titleKey="customer.accountCreditLimit" class="right"/>

                <g:sortableColumn property="settlementDays" title="Settlement Days" titleKey="customer.settlementDays" class="right"/>

                <g:sortableColumn property="periodicSettlement" title="Periodic Settlement" titleKey="customer.periodicSettlement"/>

                <g:sortableColumn property="active" title="Active" titleKey="customer.active" />

                <th><g:msg code="customer.currency" default="Currency" /></th>

                <g:sortableColumn property="revaluationMethod" title="Revaluation Method" titleKey="customer.revaluationMethod" />

                <g:sortableColumn property="taxId" title="Tax Id" titleKey="customer.taxId" />

                <th><g:msg code="customer.taxCode" default="Tax Code" /></th>

                <th><g:msg code="customer.accessCode" default="Access Code" /></th>

                <th><g:msg code="customer.country" default="Country" /></th>

                <th><g:msg code="customer.addresses" default="Addresses"/></th>

                <th><g:msg code="customer.transactions" default="Transactions"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${customerInstanceList}" status="i" var="customerInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${customerInstance.id}">${display(bean:customerInstance, field:'code')}</g:link></td>

                    <td>${display(bean:customerInstance, field:'name')}</td>

                    <td class="right">${display(bean:customerInstance, field:'accountCurrentBalance', scale: customerInstance.currency.decimals)}</td>

                    <td class="right">${display(bean:customerInstance, field:'accountCreditLimit', scale: 0)}</td>

                    <td class="right">${display(bean:customerInstance, field:'settlementDays')}</td>

                    <td>${display(bean:customerInstance, field:'periodicSettlement')}</td>

                    <td>${display(bean:customerInstance, field:'active')}</td>

                    <td>${customerInstance.currency.code.encodeAsHTML()}</td>

                    <td>${customerInstance.revaluationMethod ? msg(code: 'customer.revaluationMethod.' + customerInstance.revaluationMethod, default: customerInstance.revaluationMethod) : ''}</td>

                    <td>${display(bean:customerInstance, field:'taxId')}</td>

                    <td>${customerInstance.taxCode?.code?.encodeAsHTML()}</td>

                    <td>${customerInstance.accessCode.code.encodeAsHTML()}</td>

                    <td><g:msg code="country.name.${customerInstance.country.code}" default="${customerInstance.country.name}"/></td>

                    <td><g:drilldown controller="customerAddress" action="list" value="${customerInstance.id}"/></td>

                    <td><g:drilldown controller="customer" action="transactions" value="${customerInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${customerInstanceTotal}" />
    </div>
</div>
</body>
</html>
