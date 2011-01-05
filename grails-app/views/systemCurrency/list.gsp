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
<%@ page import="com.whollygrails.tlc.sys.SystemCurrency" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemCurrency.list" default="System Currency List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemCurrency.new" default="New System Currency"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemCurrency.list" default="System Currency List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, decimals, autoUpdate"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemCurrency.code"/>

                <th><g:msg code="systemCurrency.name" default="Name"/></th>

                <g:sortableColumn property="decimals" title="Decimals" titleKey="systemCurrency.decimals"/>

                <g:sortableColumn property="autoUpdate" title="Auto Update" titleKey="systemCurrency.autoUpdate"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemCurrencyInstanceList}" status="i" var="systemCurrencyInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemCurrencyInstance.id}">${display(bean: systemCurrencyInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="currency.name.${systemCurrencyInstance.code}" default="${systemCurrencyInstance.name}"/></td>

                    <td>${display(bean: systemCurrencyInstance, field: 'decimals')}</td>

                    <td>${display(bean: systemCurrencyInstance, field: 'autoUpdate')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemCurrencyInstanceTotal}"/>
    </div>
</div>
</body>
</html>
