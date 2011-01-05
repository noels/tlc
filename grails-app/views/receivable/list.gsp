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
<%@ page import="com.whollygrails.tlc.books.TemplateDocument" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="templateDocument.arj.list" default="Accounts Receivable Journal Template List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="templateDocument.new" default="New Template" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="templateDocument.arj.list" default="Accounts Receivable Journal Template List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>
    <div class="list">
        <table>
            <thead>
            <tr>

                <th><g:msg code="templateDocument.type" default="Type" /></th>

                <th><g:msg code="templateDocument.description" default="Description" /></th>

                <th><g:msg code="templateDocument.reference" default="Reference" /></th>

                <th><g:msg code="templateDocument.currency" default="Currency" /></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${templateDocumentInstanceList}" status="i" var="templateDocumentInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${templateDocumentInstance.id}">${display(bean:templateDocumentInstance, field:'type')}</g:link></td>

                    <td>${display(bean:templateDocumentInstance, field:'description')}</td>

                    <td>${display(bean:templateDocumentInstance, field:'reference')}</td>

                    <td>${msg(code: 'currency.name.' + templateDocumentInstance.currency.code, default: templateDocumentInstance.currency.name)}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${templateDocumentInstanceTotal}" />
    </div>
</div>
</body>
</html>
