<%--
~   Copyright 2010 Wholly Grails.
~
~   This file is part of the Three Ledger Core (TLC) software
~   from Wholly Grails.
~
~   TLC is free software: you can redistribute it and/or modify
~   it under the terms of the GNU General Public License as published by
~   the Free Software Foundation, either version 3 of the License, or
~   (at your option) any later version.
~
~   TLC is distributed in the hope that it will be useful,
~   but WITHOUT ANY WARRANTY; without even the implied warranty of
~   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
~   GNU General Public License for more details.
~
~   You should have received a copy of the GNU General Public License
~   along with TLC.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@ page import="com.whollygrails.tlc.books.Reconciliation" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="reconciliation.list" default="Bank Reconciliation List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <g:if test="${allFinalized}">
        <span class="menuButton"><g:link class="create" action="create" params="${[bankAccount: bankAccount.id]}"><g:msg code="reconciliation.new" default="New Reconciliation"/></g:link></span>
    </g:if>
</div>
<div class="body">
    <g:if test="${bankAccount.id}">
        <g:pageTitle code="reconciliation.list.for" args="${[bankAccount.name]}" default="Bank Reconciliation List for ${bankAccount.name}"/>
    </g:if>
    <g:else>
        <g:pageTitle code="reconciliation.list" default="Bank Reconciliation List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>

    <div class="criteria">
        <g:form action="list" method="post" name="bankform">
            <input type="hidden" name="changed" value="true"/>
            <g:msg code="reconciliation.bankAccount" default="Bank Account"/>
            <g:domainSelect name="bankAccount" options="${bankAccountList}" selected="${bankAccount}" displays="${['code', 'name']}" sort="false" noSelection="['': msg(code: 'generic.select', default: '-- select --')]" onchange="document.bankform.submit();"/>&nbsp;<g:help code="reconciliation.bankAccount"/>
        </g:form>
    </div>
    <g:if test="${bankAccount.id}">
        <div class="center" style="margin-bottom:10px;">
            <g:msg code="reconciliation.currency.note" args="${[bankAccount.currency.code]}" default="(All values shown in ${bankAccount.currency.code})"/>
        </div>
    </g:if>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="statementDate" title="Statement Date" titleKey="reconciliation.statementDate"/>

                <g:sortableColumn property="statementBalance" title="Statement Balance" titleKey="reconciliation.statementBalance"/>

                <g:sortableColumn property="bankAccountBalance" title="Bank Account Balance" titleKey="reconciliation.bankAccountBalance"/>

                <g:sortableColumn property="finalizedDate" title="Finalized Date" titleKey="reconciliation.finalizedDate"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${reconciliationInstanceList}" status="i" var="reconciliationInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="${reconciliationInstance.finalizedDate ? 'display' : 'show'}" id="${reconciliationInstance.id}">${display(bean: reconciliationInstance, field: 'statementDate', scale: 1)}</g:link></td>

                    <td>${display(bean: reconciliationInstance, field: 'statementBalance', scale: bankAccount.currency.decimals)}</td>

                    <td>${display(bean: reconciliationInstance, field: 'bankAccountBalance', scale: bankAccount.currency.decimals)}</td>

                    <td>${display(bean: reconciliationInstance, field: 'finalizedDate', scale: 1)}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${reconciliationInstanceTotal}" params="${[bankAccount: bankAccount.id]}"/>
    </div>
</div>
</body>
</html>
