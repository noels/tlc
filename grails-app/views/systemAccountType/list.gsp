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
<%@ page import="com.whollygrails.tlc.sys.SystemAccountType" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemAccountType.list" default="System Account Type List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemAccountType.new" default="New System Account Type" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemAccountType.list" default="System Account Type List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, sectionType*, singleton, changeable, allowInvoices, allowCash, allowProvisions, allowJournals"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemAccountType.code" />

                <th><g:msg code="systemAccountType.name" default="Name"/></th>

                <g:sortableColumn property="sectionType" title="Section Type" titleKey="systemAccountType.sectionType" />

                <g:sortableColumn property="singleton" title="Singleton" titleKey="systemAccountType.singleton" />

                <g:sortableColumn property="changeable" title="Changeable" titleKey="systemAccountType.changeable" />

                <g:sortableColumn property="allowInvoices" title="Allow Invoices" titleKey="systemAccountType.allowInvoices" />

                <g:sortableColumn property="allowCash" title="Allow Cash" titleKey="systemAccountType.allowCash" />

                <g:sortableColumn property="allowProvisions" title="Allow Provisions" titleKey="systemAccountType.allowProvisions" />

                <g:sortableColumn property="allowJournals" title="Allow Journals" titleKey="systemAccountType.allowJournals" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemAccountTypeInstanceList}" status="i" var="systemAccountTypeInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemAccountTypeInstance.id}">${display(bean:systemAccountTypeInstance, field:'code')}</g:link></td>

                    <td><g:msg code="systemAccountType.name.${systemAccountTypeInstance.code}" default="${systemAccountTypeInstance.name}"/></td>

                    <td><g:msg code="systemAccountType.sectionType.${systemAccountTypeInstance.sectionType}" default="${systemAccountTypeInstance.sectionType}"/></td>

                    <td>${display(bean: systemAccountTypeInstance, field: 'singleton')}</td>

                    <td>${display(bean: systemAccountTypeInstance, field: 'changeable')}</td>

                    <td>${display(bean: systemAccountTypeInstance, field: 'allowInvoices')}</td>

                    <td>${display(bean: systemAccountTypeInstance, field: 'allowCash')}</td>

                    <td>${display(bean: systemAccountTypeInstance, field: 'allowProvisions')}</td>

                    <td>${display(bean: systemAccountTypeInstance, field: 'allowJournals')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemAccountTypeInstanceTotal}" />
    </div>
</div>
</body>
</html>
