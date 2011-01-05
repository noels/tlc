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
<%@ page import="com.whollygrails.tlc.books.CodeElement" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="codeElement.list" default="Code Element List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <g:if test="${codeElementInstanceTotal < 8}">
        <span class="menuButton"><g:link class="create" action="create"><g:msg code="codeElement.new" default="New Code Element"/></g:link></span>
    </g:if>
</div>
<div class="body">
    <g:pageTitle code="codeElement.list" default="Code Element List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="elementNumber, name, dataType*, dataLength"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="elementNumber" title="Element Number" titleKey="codeElement.elementNumber"/>

                <g:sortableColumn property="name" title="Name" titleKey="codeElement.name"/>

                <th><g:msg code="codeElement.dataType" default="Data Type"/></th>

                <g:sortableColumn property="dataLength" title="Data Length" titleKey="codeElement.dataLength"/>

                <th><g:msg code="codeElement.values" default="Values"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${codeElementInstanceList}" status="i" var="codeElementInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${codeElementInstance.id}">${display(bean: codeElementInstance, field: 'elementNumber')}</g:link></td>

                    <td>${display(bean: codeElementInstance, field: 'name')}</td>

                    <td><g:msg code="codeElement.dataType.${codeElementInstance.dataType}" default="${codeElementInstance.dataType}"/></td>

                    <td>${display(bean: codeElementInstance, field: 'dataLength')}</td>

                    <td><g:drilldown controller="codeElementValue" value="${codeElementInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${codeElementInstanceTotal}"/>
    </div>
</div>
</body>
</html>
