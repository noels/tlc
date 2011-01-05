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
<%@ page import="com.whollygrails.tlc.sys.SystemCountry" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemCountry.list" default="System Country List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemCountry.new" default="New System Country"/></g:link></span>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="systemCountry.list.for" args="${[message(code: 'region.name.' + ddSource.code, default: ddSource.name)]}" default="System Country List for Region ${message(code: 'region.name.' + ddSource.code, default: ddSource.name)}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="systemCountry.list" default="System Country List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, flag"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemCountry.code"/>

                <th><g:msg code="systemCountry.name" default="Name"/></th>

                <g:sortableColumn property="flag" title="Flag" titleKey="systemCountry.flag"/>

                <th><g:msg code="systemCountry.currency" default="Currency"/></th>

                <th><g:msg code="systemCountry.language" default="Language"/></th>

                <th><g:msg code="systemCountry.region" default="Region"/></th>

                <th><g:msg code="systemCountry.addressFormat" default="Address Format"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemCountryInstanceList}" status="i" var="systemCountryInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemCountryInstance.id}">${display(bean: systemCountryInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="country.name.${systemCountryInstance.code}" default="${systemCountryInstance.name}"/></td>

                    <td>${display(bean: systemCountryInstance, field: 'flag')}</td>

                    <td><g:msg code="currency.name.${systemCountryInstance.currency.code}" default="${systemCountryInstance.currency.name}"/></td>

                    <td><g:msg code="language.name.${systemCountryInstance.language.code}" default="${systemCountryInstance.language.name}"/></td>

                    <td><g:msg code="region.name.${systemCountryInstance.region.code}" default="${systemCountryInstance.region.name}"/></td>

                    <td><g:msg code="systemAddressFormat.name.${systemCountryInstance.addressFormat.code}" default="${systemCountryInstance.addressFormat.name}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemCountryInstanceTotal}"/>
    </div>
</div>
</body>
</html>
