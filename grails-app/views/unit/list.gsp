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
<%@ page import="com.whollygrails.tlc.corp.Unit; com.whollygrails.tlc.corp.Measure; com.whollygrails.tlc.corp.Scale" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="unit.list" default="Unit List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="unit.new" default="New Unit" /></g:link></span>
</div>
<div class="body">
    <g:if test="${(ddSource && ddSource instanceof Measure)}">
        <g:pageTitle code="unit.list.for.measure" args="${[message(code: 'measure.name.' + ddSource.code, default: ddSource.name)]}" default="Unit List for Measure ${message(code: 'measure.name.' + ddSource.code, default: ddSource.name)}" returns="true"/>
    </g:if>
    <g:elseif test="${(ddSource && ddSource instanceof Scale)}">
        <g:pageTitle code="unit.list.for.scale" args="${[message(code: 'scale.name.' + ddSource.code, default: ddSource.name)]}" default="Unit List for Scale ${message(code: 'scale.name.' + ddSource.code, default: ddSource.name)}" returns="true"/>
    </g:elseif>
    <g:else>
        <g:pageTitle code="unit.list" default="Unit List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, multiplier"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="unit.code" />

                <th><g:msg code="unit.name" default="Name" /></th>

                <th><g:msg code="unit.measure" default="Measure" /></th>

                <th><g:msg code="unit.scale" default="Scale" /></th>

                <g:sortableColumn property="multiplier" title="Multiplier" titleKey="unit.multiplier" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${unitInstanceList}" status="i" var="unitInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${unitInstance.id}">${display(bean:unitInstance, field:'code')}</g:link></td>

                    <td><g:msg code="unit.name.${unitInstance.code}" default="${unitInstance.name}"/></td>

                    <td><g:msg code="measure.name.${unitInstance.measure.code}" default="${unitInstance.measure.name}"/></td>

                    <td><g:msg code="scale.name.${unitInstance.scale.code}" default="${unitInstance.scale.name}"/></td>

                    <td>${display(bean:unitInstance, field:'multiplier')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${unitInstanceTotal}" />
    </div>
</div>
</body>
</html>
