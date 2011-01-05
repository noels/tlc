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
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="document.allocations" default="Allocation Enquiry"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="document.allocations" default="Allocation Enquiry" help="document.allocations"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${lineInstance}">
        <div class="errors">
            <g:listErrors bean="${lineInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="allocations" method="post">
        <input type="hidden" name="id" value="${lineInstance?.id}"/>
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <g:msg code="generic.document" default="Document"/>:
                    </td>
                    <td valign="top" class="value">
                        <g:enquiryLink target="${lineInstance.document}" displayPeriod="${displayPeriod}" displayCurrency="${displayCurrency}"><g:format value="${lineInstance.document.type.code + lineInstance.document.code}"/></g:enquiryLink>
                    </td>

                    <td valign="top" class="name">
                        <g:msg code="document.description" default="Description"/>:
                    </td>
                    <td valign="top" class="value nowrap">
                        ${display(bean: lineInstance, field: 'description')}
                    </td>

                    <td valign="top" class="name">
                        <label for="displayCurrency"><g:msg code="generic.displayCurrency" default="Display Currency"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap">
                        <g:domainSelect class="${displayCurrencyClass}" name="displayCurrency" options="${currencyList}" selected="${displayCurrency}" prefix="currency.name" code="code" default="name" noSelection="['null': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="generic.displayCurrency"/>
                    </td>

                    <td><span class="button"><input class="save" type="submit" value="${msg(code: 'generic.enquire', 'default': 'Enquire')}"/></span></td>
                </tr>
                <g:if test="${lineInstance.id}">
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="document.customer" default="Customer"/>:</td>
                        <td valign="top" class="value"><g:enquiryLink target="${lineInstance.customer}" displayPeriod="${lineInstance.document.period}" displayCurrency="${displayCurrency}">${lineInstance.customer.code.encodeAsHTML()}</g:enquiryLink></td>

                        <td valign="top" class="name"><g:msg code="customer.name" default="Name"/>:</td>
                        <td valign="top" class="value nowrap">${lineInstance.customer.name.encodeAsHTML()}</td>

                        <td valign="top" class="name"><g:msg code="generic.accountCurrency" default="Account Currency"/>:</td>
                        <td valign="top" class="value">${msg(code: 'currency.name.' + lineInstance.customer.currency.code, default: lineInstance.customer.currency.name)}</td>
                    </tr>
                </g:if>
                </tbody>
            </table>
        </div>
    </g:form>
    <g:if test="${lineInstance.id}">
        <div class="list">
            <table>
                <thead>
                <tr>
                    <th><g:msg code="generic.document" default="Document"/></th>
                    <th class="right"><g:msg code="generic.debit" default="Debit"/></th>
                    <th class="right"><g:msg code="generic.credit" default="Credit"/></th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${allocationInstanceList}" status="i" var="allocationInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:enquiryLink target="${allocationInstance.target}" displayCurrency="${displayCurrency}"><g:format value="${allocationInstance.code}"/></g:enquiryLink></td>
                        <td class="right"><g:format value="${allocationInstance.debit}"/></td>
                        <td class="right"><g:format value="${allocationInstance.credit}"/></td>
                    </tr>
                </g:each>
                <tr>
                    <th class="right"><g:format value="${totalInstance.code}"/>:</th>
                    <th class="right"><g:format value="${totalInstance.debit}"/></th>
                    <th class="right"><g:format value="${totalInstance.credit}"/></th>
                </tr>
                </tbody>
            </table>
        </div>
    </g:if>
</div>
</body>
</html>
