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
    <title><g:msg code="supplier.enquire" default="Supplier Account Enquiry"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="supplier.enquire" default="Supplier Account Enquiry"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${supplierInstance}">
        <div class="errors">
            <g:listErrors bean="${supplierInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="enquire" method="post">
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="code"><g:msg code="supplier.enquire.code" default="Code"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap ${hasErrors(bean: supplierInstance, field: 'code', 'errors')}">
                        <input initialField="true" type="text" maxlength="20" size="20" id="code" name="code" value="${display(bean: supplierInstance, field: 'code')}"/>&nbsp;<g:help code="supplier.enquire.code"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="displayPeriod"><g:msg code="supplier.enquire.period" default="Period"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap">
                        <g:select optionKey="id" optionValue="code" from="${periodList}" name="displayPeriod" value="${displayPeriod?.id}" noSelection="['null': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="supplier.enquire.period"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="displayCurrency"><g:msg code="generic.displayCurrency" default="Display Currency"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap">
                        <g:domainSelect class="${displayCurrencyClass}" name="displayCurrency" options="${currencyList}" selected="${displayCurrency}" prefix="currency.name" code="code" default="name" noSelection="['null': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="generic.displayCurrency"/>
                    </td>
                    <td><span class="button"><input class="save" type="submit" value="${msg(code: 'generic.enquire', 'default': 'Enquire')}"/></span></td>
                    <td></td>
                </tr>
                <g:if test="${supplierInstance.id}">
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="supplier.name" default="Name"/>:</td>
                        <td valign="top" class="value" colspan="2">${display(bean: supplierInstance, field: 'name')}</td>

                        <td class="nowrap" valign="top"><span class="name"><g:msg code="supplier.active" default="Active"/>:</span>&nbsp;&nbsp;<span class="value">${display(bean: supplierInstance, field: 'active')}</span></td>

                        <td valign="top" class="name"><g:msg code="generic.account.currency" default="Account Currency"/>:</td>
                        <td valign="top" class="value">${msg(code: 'currency.name.' + supplierInstance.currency.code, default: supplierInstance.currency.name)}</td>

                        <td valign="top" class="name"><g:msg code="supplier.accountCurrentBalance" default="Current Balance"/>:</td>
                        <td valign="top" class="value nowrap">
                            <g:if test="${remittanceCount}">
                                <g:link action="remittanceEnquiry" params="${[supplierId: supplierInstance.id, displayPeriod: displayPeriod?.id, displayCurrency: displayCurrency?.id]}">
                                    <g:dr context="${supplierInstance}" field="balance" currency="${displayCurrency}" negate="true"/>
                                </g:link>
                            </g:if>
                            <g:else>
                                <g:dr context="${supplierInstance}" field="balance" currency="${displayCurrency}" negate="true"/>
                            </g:else>
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="supplier.country" default="Country"/>:</td>
                        <td valign="top" class="value" colspan="2"><g:msg code="country.name.${supplierInstance.country.code}" default="${supplierInstance.country.name}"/></td>

                        <td  class="nowrap" valign="top"><span class="name"><g:msg code="supplier.periodic" default="Periodic"/>:</span>&nbsp;&nbsp;<span class="value">${display(bean: supplierInstance, field: 'periodicSettlement')}</span></td>

                        <td valign="top" class="name"><g:msg code="supplier.settlementDays" default="Settlement Days"/>:</td>
                        <td valign="top" class="value">${display(bean: supplierInstance, field: 'settlementDays')}</td>

                        <td valign="top" class="name"><g:msg code="supplier.accountCreditLimit" default="Credit Limit"/>:</td>
                        <td valign="top" class="value nowrap"><g:amount context="${supplierInstance}" field="limit" currency="${displayCurrency}"/></td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="supplier.taxCode" default="Tax Code"/>:</td>
                        <td valign="top" class="value">${supplierInstance.taxCode ? msg(code: 'taxCode.name.' + supplierInstance.taxCode.code, default: supplierInstance.taxCode.name) : ''}</td>

                        <td valign="top" class="name"><g:msg code="supplier.taxId" default="Tax Id"/>:</td>
                        <td valign="top" class="value">${display(bean: supplierInstance, field: 'taxId')}</td>

                        <td valign="top" class="name"><g:msg code="supplier.turnovers" default="Purchases"/>:</td>
                        <td valign="top"><g:domainSelect name="dummy" options="${turnoverList}" selected="${displayTurnover}" displays="data" sort="false"/></td>

                        <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>
                        <td valign="top" class="value nowrap">${display(bean: supplierInstance, field: 'dateCreated', scale: 1)}</td>
                    </tr>
                </g:if>
                </tbody>
            </table>
        </div>
    </g:form>
    <g:if test="${supplierInstance.id}">
        <div class="list">
            <table>
                <thead>
                <tr>

                    <th><g:msg code="generic.document" default="Document"/></th>

                    <th><g:msg code="generic.documentDate" default="Document Date"/></th>

                    <th><g:msg code="generalTransaction.description" default="Description"/></th>

                    <th><g:msg code="document.dueDate" default="Due Date"/></th>

                    <th><g:msg code="generalTransaction.onHold" default="On Hold"/></th>

                    <th class="right"><g:msg code="generalTransaction.accountUnallocated" default="Unallocated"/></th>

                    <th class="right"><g:msg code="generic.debit" default="Debit"/></th>

                    <th class="right"><g:msg code="generic.credit" default="Credit"/></th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${transactionInstanceList}" status="i" var="transactionInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                        <td><g:enquiryLink target="${transactionInstance.document}" displayPeriod="${displayPeriod}" displayCurrency="${displayCurrency}"><g:format value="${transactionInstance.document.type.code + transactionInstance.document.code}"/></g:enquiryLink></td>

                        <td><g:format value="${transactionInstance.document.documentDate}" scale="1"/></td>

                        <td>${display(bean: transactionInstance, field: 'description')}</td>

                        <td><g:format value="${transactionInstance.document.dueDate}" scale="1"/></td>

                        <td><g:if test="${transactionInstance.onHold}">${display(bean: transactionInstance, field: 'onHold')}</g:if></td>

                        <td class="right"><g:enquiryLink target="${transactionInstance}" displayPeriod="${displayPeriod}" displayCurrency="${displayCurrency}"><g:drcr context="${supplierInstance}" line="${transactionInstance}" field="unallocated" currency="${displayCurrency}" zeroIsHTML="${'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'}"/></g:enquiryLink></td>

                        <td class="right"><g:debit context="${supplierInstance}" line="${transactionInstance}" field="value" currency="${displayCurrency}"/></td>

                        <td class="right"><g:credit context="${supplierInstance}" line="${transactionInstance}" field="value" currency="${displayCurrency}"/></td>

                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
        <div class="paginateButtons">
            <g:paginate total="${transactionInstanceTotal}" id="${supplierInstance.id}" params="${[displayCurrency: displayCurrency?.id, displayPeriod: displayPeriod?.id]}"/>
        </div>
    </g:if>
</div>
</body>
</html>
