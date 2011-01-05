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
<%@ page import="com.whollygrails.tlc.books.Mnemonic" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="mnemonic.list" default="Mnemonic List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="mnemonic.new" default="New Mnemonic" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="mnemonic.list" default="Mnemonic List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, name, accountCodeFragment"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="mnemonic.code" />

                <g:sortableColumn property="name" title="Name" titleKey="mnemonic.name" />

                <g:sortableColumn property="accountCodeFragment" title="Account Code Fragment" titleKey="mnemonic.accountCodeFragment" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${mnemonicInstanceList}" status="i" var="mnemonicInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${mnemonicInstance.id}">${display(bean:mnemonicInstance, field:'code')}</g:link></td>

                    <td>${display(bean:mnemonicInstance, field:'name')}</td>

                    <td>${display(bean:mnemonicInstance, field:'accountCodeFragment')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${mnemonicInstanceTotal}" />
    </div>
</div>
</body>
</html>
