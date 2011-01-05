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
<%@ page import="com.whollygrails.tlc.sys.SystemDocumentType" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemDocumentType.list" default="System Document Type List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemDocumentType.new" default="New System Document Type" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemDocumentType.list" default="System Document Type List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, metaType*, analysisIsDebit, customerAllocate, supplierAllocate"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemDocumentType.code" />

                <th><g:msg code="systemDocumentType.name" default="Name"/></th>

                <th><g:msg code="systemDocumentType.activity" default="Activity"/></th>

                <th><g:msg code="systemDocumentType.metaType" default="Meta Type"/></th>

                <g:sortableColumn property="analysisIsDebit" title="Analysis Is Debit" titleKey="systemDocumentType.analysisIsDebit" />

                <g:sortableColumn property="customerAllocate" title="Customer Allocatable" titleKey="systemDocumentType.customerAllocate" />

                <g:sortableColumn property="supplierAllocate" title="Supplier Allocatable" titleKey="systemDocumentType.supplierAllocate" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemDocumentTypeInstanceList}" status="i" var="systemDocumentTypeInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemDocumentTypeInstance.id}">${display(bean:systemDocumentTypeInstance, field:'code')}</g:link></td>

                    <td><g:msg code="systemDocumentType.name.${systemDocumentTypeInstance.code}" default="${systemDocumentTypeInstance.name}"/></td>

                    <td>${display(bean: systemDocumentTypeInstance, field: 'activity')}</td>

                    <td><g:msg code="systemDocumentType.metaType.${systemDocumentTypeInstance.metaType}" default="${systemDocumentTypeInstance.metaType}"/></td>

                    <td>${display(bean: systemDocumentTypeInstance, field: 'analysisIsDebit')}</td>

                    <td>${display(bean: systemDocumentTypeInstance, field: 'customerAllocate')}</td>

                    <td>${display(bean: systemDocumentTypeInstance, field: 'supplierAllocate')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemDocumentTypeInstanceTotal}" />
    </div>
</div>
</body>
</html>
