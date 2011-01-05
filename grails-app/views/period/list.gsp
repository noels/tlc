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
<%@ page import="com.whollygrails.tlc.books.Period" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="period.list" default="Period List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="period.new" default="New Period"/></g:link></span>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="period.list.for" args="${[ddSource.code]}" default="Period List for Year ${ddSource.code}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="period.list" default="Period List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, validFrom, status*, validTo"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="period.code"/>

                <g:sortableColumn property="validFrom" title="Valid From" titleKey="period.validFrom"/>

                <g:sortableColumn property="validTo" title="Valid To" titleKey="period.validTo"/>

                <g:sortableColumn property="status" title="Status" titleKey="period.status"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${periodInstanceList}" status="i" var="periodInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${periodInstance.id}">${display(bean: periodInstance, field: 'code')}</g:link></td>

                    <td>${display(bean: periodInstance, field: 'validFrom', scale: 1)}</td>

                    <td>${display(bean: periodInstance, field: 'validTo', scale: 1)}</td>

                    <td><g:msg code="period.status.${periodInstance.status}" default="${periodInstance.status}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${periodInstanceTotal}"/>
    </div>
</div>
</body>
</html>
