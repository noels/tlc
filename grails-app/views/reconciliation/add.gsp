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
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="reconciliation.add" default="Add Document"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="edit" id="${reconciliationInstance.id}"><g:msg code="reconciliation.edit" default="Edit Reconciliation"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="reconciliation.add" default="Add Document"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="list">
        <table>
            <thead>
            <tr>
                <th><g:msg code="reconciliationLine.date" default="Date"/></th>
                <th><g:msg code="generic.document" default="Document"/></th>
                <th><g:msg code="reconciliationLine.reference" default="Reference"/></th>
                <th><g:msg code="reconciliationLine.details" default="Details"/></th>
                <th class="right"><g:msg code="reconciliationLine.payment" default="Payment"/></th>
                <th class="right"><g:msg code="reconciliationLine.receipt" default="Receipt"/></th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${transactionInstanceList}" status="i" var="transactionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${display(value: transactionInstance.document.documentDate, scale: 1)}</td>
                    <td>${display(value: transactionInstance.document.type.code + transactionInstance.document.code)}</td>
                    <td>${display(value: transactionInstance.document.reference)}</td>
                    <td>${display(bean: transactionInstance, field: 'description')}</td>
                    <td class="right"><g:credit value="${transactionInstance.generalValue}" scale="${decimals}"/></td>
                    <td class="right"><g:debit value="${transactionInstance.generalValue}" scale="${decimals}"/></td>
                    <td>
                        <g:form action="adding" method="post">
                            <input type="hidden" name="reconciliation" value="${reconciliationInstance.id}"/>
                            <input type="hidden" name="id" value="${transactionInstance.id}"/>
                            <input type="submit" value="${msg(code: 'reconciliation.add', default: 'Add')}"/>
                        </g:form>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate action="add" total="${transactionInstanceTotal}" params="${[reconciliation: reconciliationInstance.id]}"/>
    </div>
</div>
</body>
</html>
