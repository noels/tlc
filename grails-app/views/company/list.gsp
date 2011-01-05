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
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="company.list" default="Company List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="company.new" default="New Company"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="company.list" default="Company List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="name, systemOnly"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="name" title="Name" titleKey="company.name"/>

                <th><g:msg code="company.country" default="Country"/></th>

                <th><g:msg code="company.language" default="Language"/></th>

                <th><g:msg code="company.currency" default="Currency"/></th>

                <th><g:msg code="company.displayTaxCode" default="Tax Code"/></th>

                <g:sortableColumn property="systemOnly" title="System Only" titleKey="company.systemOnly"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${companyInstanceList}" status="i" var="companyInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${companyInstance.id}">${display(bean: companyInstance, field: 'name')}</g:link></td>

                    <td>${msg(code: 'country.name.' + companyInstance.country.code, default: companyInstance.country.name)}</td>

                    <td>${msg(code: 'language.name.' + companyInstance.language.code, default: companyInstance.language.name)}</td>

                    <td>${msg(code: 'currency.name.' + companyInstance.displayCurrency?.code, default: companyInstance.displayCurrency?.name)}</td>

                    <td>${msg(code: 'taxCode.name.' + companyInstance.displayTaxCode.code, default: companyInstance.displayTaxCode.name)}</td>

                    <td>${display(bean: companyInstance, field: 'systemOnly')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${companyInstanceTotal}"/>
    </div>
</div>
</body>
</html>
