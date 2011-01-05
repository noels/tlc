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
<%@ page import="com.whollygrails.tlc.corp.TaxStatement" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="taxStatement.list" default="Tax Statement List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="taxStatement.new" default="New Tax Statement"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="taxStatement.list" default="Tax Statement List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="statementDate, description"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="statementDate" title="Statement Date" titleKey="taxStatement.statementDate"/>

                <th><g:msg code="taxStatement.authority" default="Tax Authority"/></th>

                <g:sortableColumn property="description" title="Description" titleKey="taxStatement.description"/>

                <th><g:msg code="taxStatement.document" default="Document"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${taxStatementInstanceList}" status="i" var="taxStatementInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${taxStatementInstance.id}">${display(bean: taxStatementInstance, field: 'statementDate', scale: 1)}</g:link></td>

                    <td>${taxStatementInstance.authority.name.encodeAsHTML()}</td>

                    <td>${display(bean: taxStatementInstance, field: 'description')}</td>

                    <g:if test="${taxStatementInstance.finalized}">
                        <td>${taxStatementInstance.document ? (taxStatementInstance.document.type.code + taxStatementInstance.document.code).encodeAsHTML() : msg(code: 'generic.not.applicable', default: 'n/a')}</td>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${taxStatementInstanceTotal}"/>
    </div>
</div>
</body>
</html>
