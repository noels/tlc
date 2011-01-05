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
<%@ page import="com.whollygrails.tlc.books.Year" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="year.list" default="Year List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="year.new" default="New Year" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="year.list" default="Year List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, validFrom, validTo"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="year.code" />

                <g:sortableColumn property="validFrom" title="Valid From" titleKey="year.validFrom" />

                <g:sortableColumn property="validTo" title="Valid To" titleKey="year.validTo" />

                <th><g:msg code="year.periods" default="Periods"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${yearInstanceList}" status="i" var="yearInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${yearInstance.id}">${display(bean:yearInstance, field:'code')}</g:link></td>

                    <td>${display(bean:yearInstance, field:'validFrom', scale: 1)}</td>

                    <td>${display(bean:yearInstance, field:'validTo', scale: 1)}</td>

                    <td><g:drilldown controller="period" value="${yearInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${yearInstanceTotal}" />
    </div>
</div>
</body>
</html>
