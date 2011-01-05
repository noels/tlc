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
<%@ page import="com.whollygrails.tlc.sys.SystemRegion" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemRegion.list" default="System Region List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemRegion.new" default="New System Region"/></g:link></span>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="systemRegion.list.for" args="${[message(code: 'geo.name.' + ddSource.code, default: ddSource.name)]}" default="System Region List for Geo ${message(code: 'geo.name.' + ddSource.code, default: ddSource.name)}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="systemRegion.list" default="System Region List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemRegion.code"/>

                <th><g:msg code="systemRegion.name" default="Name"/></th>

                <th><g:msg code="systemRegion.geo" default="Geo"/></th>

                <th><g:msg code="systemRegion.countries" default="Countries"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemRegionInstanceList}" status="i" var="systemRegionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemRegionInstance.id}">${display(bean: systemRegionInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="region.name.${systemRegionInstance.code}" default="${systemRegionInstance.name}"/></td>

                    <td><g:msg code="geo.name.${systemRegionInstance.geo.code}" default="${systemRegionInstance.geo.name}"/></td>

                    <td><g:drilldown controller="systemCountry" value="${systemRegionInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemRegionInstanceTotal}"/>
    </div>
</div>
</body>
</html>
