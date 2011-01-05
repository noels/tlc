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
<%@ page import="com.whollygrails.tlc.corp.ExchangeRate" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="exchangeRate.test.title" default="Test Exchange Rates"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="exchangeCurrency.list" default="Currency List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="exchangeRate.test.title" default="Test Exchange Rates"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${testInstance}">
        <div class="errors">
            <g:listErrors bean="${testInstance}"/>
        </div>
    </g:hasErrors>
    <g:form method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="fromCurrency.id"><g:msg code="exchangeRate.test.fromCurrency" default="From Currency"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: testInstance, field: 'fromCurrency', 'errors')}">
                        <g:domainSelect initialField="true" name="fromCurrency.id" options="${currencyList}" selected="${testInstance?.fromCurrency}" prefix="currency.name" code="code" default="name"/>&nbsp;<g:help code="exchangeRate.test.fromCurrency"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="toCurrency.id"><g:msg code="exchangeRate.test.toCurrency" default="To Currency"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: testInstance, field: 'toCurrency', 'errors')}">
                        <g:domainSelect name="toCurrency.id" options="${currencyList}" selected="${testInstance?.toCurrency}" prefix="currency.name" code="code" default="name"/>&nbsp;<g:help code="exchangeRate.test.toCurrency"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="conversionDate"><g:msg code="exchangeRate.test.conversionDate" default="Conversion Date"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: testInstance, field: 'conversionDate', 'errors')}">
                        <input type="text" id="conversionDate" name="conversionDate" size="20" value="${display(bean: testInstance, field: 'conversionDate', scale: 1)}"/>&nbsp;<g:help code="exchangeRate.test.conversionDate"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="value"><g:msg code="exchangeRate.test.value" default="Value"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: testInstance, field: 'value', 'errors')}">
                        <input type="text" id="value" name="value" size="20" value="${display(bean: testInstance, field: 'value')}"/>&nbsp;<g:help code="exchangeRate.test.value"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <g:msg code="conversionTest.result" default="Result"/>:
                    </td>
                    <td valign="top" class="value">
                        ${testInstance.result?.encodeAsHTML()}
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="testing" value="${msg(code:'exchangeRate.test.test', 'default':'Test')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
