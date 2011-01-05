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
    <title><g:msg code="customer.enquire" default="Customer Account Enquiry"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="customer.enquire" default="Customer Account Enquiry"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${customerInstance}">
        <div class="errors">
            <g:listErrors bean="${customerInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="enquire" method="post">
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="code"><g:msg code="customer.enquire.code" default="Code"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap ${hasErrors(bean: customerInstance, field: 'code', 'errors')}">
                        <input initialField="true" type="text" maxlength="20" size="20" id="code" name="code" value="${display(bean: customerInstance, field: 'code')}"/>&nbsp;<g:help code="customer.enquire.code"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="displayPeriod"><g:msg code="customer.enquire.period" default="Period"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap">
                        <g:select optionKey="id" optionValue="code" from="${periodList}" name="displayPeriod" value="${displayPeriod?.id}" noSelection="['null': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="customer.enquire.period"/>
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
                <g:if test="${customerInstance.id}">
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="customer.name" default="Name"/>:</td>
                        <td valign="top" class="value" colspan="2">${display(bean: customerInstance, field: 'name')}</td>

                        <td class="nowrap" valign="top"><span class="name"><g:msg code="customer.active" default="Active"/>:</span>&nbsp;&nbsp;<span class="value">${display(bean: customerInstance, field: 'active')}</span></td>

                        <td valign="top" class="name"><g:msg code="generic.account.currency" default="Account Currency"/>:</td>
                        <td valign="top" class="value">${msg(code: 'currency.name.' + customerInstance.currency.code, default: customerInstance.currency.name)}</td>

                        <td valign="top" class="name"><g:msg code="customer.accountCurrentBalance" default="Current Balance"/>:</td>
                        <td valign="top" class="value nowrap">
                            <g:if test="${statementCount}">
                                <g:link action="statementEnquiry" params="${[customerId: customerInstance.id, displayPeriod: displayPeriod?.id, displayCurrency: displayCurrency?.id]}">
                                    <g:cr context="${customerInstance}" field="balance" currency="${displayCurrency}"/>
                                </g:link>
                            </g:if>
                            <g:else>
                                <g:cr context="${customerInstance}" field="balance" currency="${displayCurrency}"/>
                            </g:else>
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="customer.country" default="Country"/>:</td>
                        <td valign="top" class="value" colspan="2"><g:msg code="country.name.${customerInstance.country.code}" default="${customerInstance.country.name}"/></td>

                        <td class="nowrap" valign="top"><span class="name"><g:msg code="customer.periodic" default="Periodic"/>:</span>&nbsp;&nbsp;<span class="value">${display(bean: customerInstance, field: 'periodicSettlement')}</span></td>

                        <td valign="top" class="name"><g:msg code="customer.settlementDays" default="Settlement Days"/>:</td>
                        <td valign="top" class="value">${display(bean: customerInstance, field: 'settlementDays')}</td>

                        <td valign="top" class="name"><g:msg code="customer.accountCreditLimit" default="Credit Limit"/>:</td>
                        <td valign="top" class="value nowrap"><g:amount context="${customerInstance}" field="limit" currency="${displayCurrency}"/></td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="customer.taxCode" default="Tax Code"/>:</td>
                        <td valign="top" class="value">${customerInstance.taxCode ? msg(code: 'taxCode.name.' + customerInstance.taxCode.code, default: customerInstance.taxCode.name) : ''}</td>

                        <td valign="top" class="name"><g:msg code="customer.taxId" default="Tax Id"/>:</td>
                        <td valign="top" class="value">${display(bean: customerInstance, field: 'taxId')}</td>

                        <td valign="top" class="name"><g:msg code="customer.turnovers" default="Sales"/>:</td>
                        <td valign="top"><g:domainSelect name="dummy" options="${turnoverList}" selected="${displayTurnover}" displays="data" sort="false"/></td>

                        <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>
                        <td valign="top" class="value nowrap">${display(bean: customerInstance, field: 'dateCreated', scale: 1)}</td>
                    </tr>
                </g:if>
                </tbody>
            </table>
        </div>
    </g:form>
    <g:if test="${customerInstance.id}">
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

                        <td class="right"><g:enquiryLink target="${transactionInstance}" displayPeriod="${displayPeriod}" displayCurrency="${displayCurrency}"><g:drcr context="${customerInstance}" line="${transactionInstance}" field="unallocated" currency="${displayCurrency}" zeroIsHTML="${'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'}"/></g:enquiryLink></td>

                        <td class="right"><g:debit context="${customerInstance}" line="${transactionInstance}" field="value" currency="${displayCurrency}"/></td>

                        <td class="right"><g:credit context="${customerInstance}" line="${transactionInstance}" field="value" currency="${displayCurrency}"/></td>

                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
        <div class="paginateButtons">
            <g:paginate total="${transactionInstanceTotal}" id="${customerInstance.id}" params="${[displayCurrency: displayCurrency?.id, displayPeriod: displayPeriod?.id]}"/>
        </div>
    </g:if>
</div>
</body>
</html>
