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
<%@ page import="com.whollygrails.tlc.corp.ExchangeCurrency" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="exchangeCurrency.list" default="Currency List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="exchangeCurrency.new" default="New Currency" /></g:link></span>
    <span class="menuButton"><g:link class="import" action="imports"><g:msg code="exchangeCurrency.imports" default="Import Predefined Currency" /></g:link></span>
    <span class="menuButton"><g:link class="test" action="test"><g:msg code="exchangeRate.test.title" default="Test Exchange Rates"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="exchangeCurrency.list" default="Currency List" />
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>
    <div align="center">
        <p><g:msg code="exchangeCurrency.bases" args="${baseCurrencies}" default="The base currency of the system is ${baseCurrencies[0]}. The company currency is ${baseCurrencies[1]}."/></p>
    </div>
    <div class="criteria">
        <g:criteria include="code, decimals, autoUpdate"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="exchangeCurrency.code" />

                <th><g:msg code="exchangeCurrency.name" default="Name"/></th>

                <g:sortableColumn property="decimals" title="Decimals" titleKey="exchangeCurrency.decimals" />

                <g:sortableColumn property="autoUpdate" title="Auto Update" titleKey="exchangeCurrency.autoUpdate" />

                <th><g:msg code="exchangeCurrency.currentRateDate" default="Current Rate Valid From"/></th>

                <th class="right"><g:msg code="exchangeCurrency.currentRateValue" default="Current Rate"/></th>

                <th><g:msg code="exchangeRate.do.update" default="Update Rate"/></th>

                <th><g:msg code="exchangeCurrency.exchangeRates" default="Exchange Rates"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${exchangeCurrencyInstanceList}" status="i" var="exchangeCurrencyInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${exchangeCurrencyInstance.id}">${display(bean:exchangeCurrencyInstance, field:'code')}</g:link></td>

                    <td><g:msg code="currency.name.${exchangeCurrencyInstance.code}" default="${exchangeCurrencyInstance.name}"/></td>

                    <td>${display(bean:exchangeCurrencyInstance, field:'decimals')}</td>

                    <td>${display(bean:exchangeCurrencyInstance, field:'autoUpdate')}</td>

                    <td>${display(bean:exchangeCurrencyInstance, field:'currentRateDate', scale: 1)}</td>

                    <td class="right">${display(bean:exchangeCurrencyInstance, field:'currentRateValue', scale: 6)}</td>

                    <g:if test="${exchangeCurrencyInstance.currentRateUpdatable}">
                        <td><g:form method="post" action="updateRate" id="${exchangeCurrencyInstance.id}"><input type="submit" value="${msg(code: 'update', default: 'Update')}"/></g:form></td>
                    </g:if>
                    <g:else>
                        <td><g:msg code="generic.not.applicable" default="n/a"/></td>
                    </g:else>

                    <td><g:drilldown controller="exchangeRate" value="${exchangeCurrencyInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${exchangeCurrencyInstanceTotal}" />
    </div>
    <g:form method="post">
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="updateRates" value="${msg(code:'exchangeRate.all.button', 'default':'Update All Rates')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
