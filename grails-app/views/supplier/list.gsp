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
<%@ page import="com.whollygrails.tlc.books.Supplier" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="supplier.list" default="Supplier List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="import" action="imports"><g:msg code="supplier.imports" default="Import Suppliers" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="supplier.new" default="New Supplier" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="supplier.list" default="Supplier List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, name, accountCreditLimit, accountCurrentBalance, settlementDays, taxId, periodicSettlement, active, nextAutoPaymentDate, revaluationMethod*"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="supplier.code" />

                <g:sortableColumn property="name" title="Name" titleKey="supplier.name" />

                <g:sortableColumn property="accountCurrentBalance" title="Current Balance" titleKey="supplier.accountCurrentBalance" class="right"/>

                <g:sortableColumn property="accountCreditLimit" title="Credit Limit" titleKey="supplier.accountCreditLimit" class="right"/>

                <g:sortableColumn property="settlementDays" title="Settlement Days" titleKey="supplier.settlementDays" class="right"/>

                <g:sortableColumn property="periodicSettlement" title="Periodic Settlement" titleKey="supplier.periodicSettlement"/>

                <g:sortableColumn property="nextAutoPaymentDate" title="Next Auto-Payment Date" titleKey="supplier.nextAutoPaymentDate"/>

                <g:sortableColumn property="active" title="Active" titleKey="supplier.active" />

                <th><g:msg code="supplier.currency" default="Currency" /></th>

                <g:sortableColumn property="revaluationMethod" title="Revaluation Method" titleKey="supplier.revaluationMethod" />

                <g:sortableColumn property="taxId" title="Tax Id" titleKey="supplier.taxId" />

                <th><g:msg code="supplier.taxCode" default="Tax Code" /></th>

                <th><g:msg code="supplier.accessCode" default="Access Code" /></th>

                <th><g:msg code="supplier.country" default="Country" /></th>

                <th><g:msg code="supplier.addresses" default="Addresses"/></th>

                <th><g:msg code="supplier.transactions" default="Transactions"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${supplierInstanceList}" status="i" var="supplierInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${supplierInstance.id}">${display(bean:supplierInstance, field:'code')}</g:link></td>

                    <td>${display(bean:supplierInstance, field:'name')}</td>

                    <td class="right">${display(bean:supplierInstance, field:'accountCurrentBalance', scale: supplierInstance.currency.decimals)}</td>

                    <td class="right">${display(bean:supplierInstance, field:'accountCreditLimit', scale: 0)}</td>

                    <td class="right">${display(bean:supplierInstance, field:'settlementDays')}</td>

                    <td>${display(bean:supplierInstance, field:'periodicSettlement')}</td>

                    <td>${display(bean:supplierInstance, field:'nextAutoPaymentDate', scale: 1)}</td>

                    <td>${display(bean:supplierInstance, field:'active')}</td>

                    <td>${supplierInstance.currency.code.encodeAsHTML()}</td>

                    <td>${supplierInstance.revaluationMethod ? msg(code: 'supplier.revaluationMethod.' + supplierInstance.revaluationMethod, default: supplierInstance.revaluationMethod) : ''}</td>

                    <td>${display(bean:supplierInstance, field:'taxId')}</td>

                    <td>${supplierInstance.taxCode?.code?.encodeAsHTML()}</td>

                    <td>${supplierInstance.accessCode.code.encodeAsHTML()}</td>

                    <td><g:msg code="country.name.${supplierInstance.country.code}" default="${supplierInstance.country.name}"/></td>

                    <td><g:drilldown controller="supplierAddress" action="list" value="${supplierInstance.id}"/></td>

                    <td><g:drilldown controller="supplier" action="transactions" value="${supplierInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${supplierInstanceTotal}" />
    </div>
</div>
</body>
</html>
