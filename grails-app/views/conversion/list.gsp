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
<%@ page import="com.whollygrails.tlc.corp.Conversion" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="conversion.list" default="Conversion List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="conversion.new" default="New Conversion" /></g:link></span>
    <span class="menuButton"><g:link class="test" action="test"><g:msg code="conversionTest.corp.title" default="Test Conversions"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="conversion.list" default="Conversion List" />
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, preAddition, multiplier, postAddition"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="conversion.code" />

                <th><g:msg code="conversion.name" default="Name"/></th>

                <th><g:msg code="conversion.source" default="Source"/></th>

                <th><g:msg code="conversion.target" default="Target"/></th>

                <g:sortableColumn property="preAddition" title="Pre Addition" titleKey="conversion.preAddition" />

                <g:sortableColumn property="multiplier" title="Multiplier" titleKey="conversion.multiplier" />

                <g:sortableColumn property="postAddition" title="Post Addition" titleKey="conversion.postAddition" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${conversionInstanceList}" status="i" var="conversionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${conversionInstance.id}">${display(bean:conversionInstance, field:'code')}</g:link></td>

                    <td><g:msg code="conversion.name.${conversionInstance.code}" default="${conversionInstance.name}"/></td>

                    <td><g:msg code="unit.name.${conversionInstance.source.code}" default="${conversionInstance.source.name}"/></td>

                    <td><g:msg code="unit.name.${conversionInstance.target.code}" default="${conversionInstance.target.name}"/></td>

                    <td>${display(bean:conversionInstance, field:'preAddition')}</td>

                    <td>${display(bean:conversionInstance, field:'multiplier')}</td>

                    <td>${display(bean:conversionInstance, field:'postAddition')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${conversionInstanceTotal}" />
    </div>
</div>
</body>
</html>
