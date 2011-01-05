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
<%@ page import="com.whollygrails.tlc.sys.SystemConversion" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemConversion.list" default="System Conversion List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemConversion.new" default="New System Conversion"/></g:link></span>
    <span class="menuButton"><g:link class="test" action="test"><g:msg code="conversionTest.sys.title" default="Test System Conversions"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemConversion.list" default="System Conversion List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, preAddition, multiplier, postAddition"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemConversion.code"/>

                <th><g:msg code="systemConversion.name" default="Name"/></th>

                <th><g:msg code="systemConversion.source" default="Source"/></th>

                <th><g:msg code="systemConversion.target" default="Target"/></th>

                <g:sortableColumn property="preAddition" title="Pre Addition" titleKey="systemConversion.preAddition"/>

                <g:sortableColumn property="multiplier" title="Multiplier" titleKey="systemConversion.multiplier"/>

                <g:sortableColumn property="postAddition" title="Post Addition" titleKey="systemConversion.postAddition"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemConversionInstanceList}" status="i" var="systemConversionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemConversionInstance.id}">${display(bean: systemConversionInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="conversion.name.${systemConversionInstance.code}" default="${systemConversionInstance.name}"/></td>

                    <td><g:msg code="unit.name.${systemConversionInstance.source.code}" default="${systemConversionInstance.source.name}"/></td>

                    <td><g:msg code="unit.name.${systemConversionInstance.target.code}" default="${systemConversionInstance.target.name}"/></td>

                    <td>${display(bean: systemConversionInstance, field: 'preAddition')}</td>

                    <td>${display(bean: systemConversionInstance, field: 'multiplier')}</td>

                    <td>${display(bean: systemConversionInstance, field: 'postAddition')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemConversionInstanceTotal}"/>
    </div>
</div>
</body>
</html>
