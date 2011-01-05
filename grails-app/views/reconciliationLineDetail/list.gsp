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
    <title><g:msg code="reconciliationLineDetail.list" args="${[reconciliationLineInstance.documentCode]}" default="Breakdown for Document ${reconciliationLineInstance.documentCode}"/></title>
    <g:yuiResources require="connection"/>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="reconciliationLineDetail.list" args="${[reconciliationLineInstance.documentCode]}" default="Breakdown for Document ${reconciliationLineInstance.documentCode}" returns="true" params="${[id: reconciliationInstance.id]}"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${reconciliationLineInstance}">
        <div class="errors">
            <g:listErrors bean="${reconciliationLineInstance}"/>
        </div>
    </g:hasErrors>
    <div id="ajaxErrorMessage" class="errors" style="visibility:hidden;"></div>
    <g:form controller="reconciliation" action="finalization" method="post">
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name" style="text-align:right;"><g:msg code="reconciliation.statementBalance" default="Statement Balance"/>:</td>
                    <td valign="top" class="value" style="text-align:right;width:120px;">${display(bean: reconciliationInstance, field: 'statementBalance', scale: decimals)}</td>
                    <td></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name" style="text-align:right;"><g:msg code="reconciliation.add.unreconciled" default="add Unreconciled Items"/>:</td>
                    <td valign="top" class="value" style="text-align:right;width:120px;text-decoration:underline;" id="unrec">${display(value: unreconciled)}</td>
                    <td></td>
                </tr>

                <tr class="prop">
                    <td></td>
                    <td valign="top" class="value" style="text-align:right;width:120px;" id="subtot">${display(value: subtotal)}</td>
                    <td></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name" style="text-align:right;"><g:msg code="reconciliation.less.bankAccountBalance" default="less Bank Account Balance"/>:</td>
                    <td valign="top" class="value" style="text-align:right;width:120px;text-decoration:underline;">${display(bean: reconciliationInstance, field: 'bankAccountBalance', scale: decimals)}</td>
                    <td></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name" style="text-align:right;"><g:msg code="reconciliation.difference" default="Difference"/>:</td>
                    <td valign="top" class="value" style="text-align:right;width:120px;text-decoration:underline;" id="diff">${display(value: difference)}</td>
                    <td style="visibility:${canFinalize ? 'visible' : 'hidden'};"><input id="fin" name="fin" type="submit" value="${msg(code:'reconciliation.finalize', 'default':'Finalize')}"/></td>
                </tr>
                </tbody>
            </table>
        </div>
    </g:form>
    <g:form method="post">
        <input type="hidden" id="responseMessage" name="responseMessage" value="${msg(code: 'generic.ajax.response', default: 'Unable to understand the response from the server')}"/>
        <input type="hidden" id="timeoutMessage" name="timeoutMessage" value="${msg(code: 'generic.ajax.timeout', default: 'Operation timed out waiting for a response from the server')}"/>
        <div class="list">
            <table>
                <thead>
                <tr>
                    <th><g:msg code="document.line.accountType" default="Ledger"/></th>
                    <th><g:msg code="document.line.accountCode" default="Account"/></th>
                    <th><g:msg code="document.sourceName" default="Name"/></th>
                    <th><g:msg code="document.description" default="Description"/></th>
                    <th><g:msg code="reconciliationLine.reconciled" default="Reconciled"/></th>
                    <th class="right"><g:msg code="reconciliationLine.payment" default="Payment"/></th>
                    <th class="right"><g:msg code="reconciliationLine.receipt" default="Receipt"/></th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${reconciliationLineDetailInstanceList}" status="i" var="reconciliationLineDetailInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:msg code="document.line.accountType.${reconciliationLineDetailInstance.type}" default="${reconciliationLineDetailInstance.type}"/></td>
                        <td>${display(bean: reconciliationLineDetailInstance, field: 'ledgerCode', scale: 1)}</td>
                        <td>${display(bean: reconciliationLineDetailInstance, field: 'ledgerName')}</td>
                        <td>${display(bean: reconciliationLineDetailInstance, field: 'description')}</td>
                        <td style="padding-top:1px;padding-bottom:0px;">
                            <g:checkBox name="line[${reconciliationLineDetailInstance.id}]" value="${reconciliationLineDetailInstance.reconciled}" onclick="setReconciled(this, '${createLink(controller: 'reconciliationLineDetail', action: 'reconcileDetail')}')"/>
                        </td>
                        <td class="right"><g:credit value="${reconciliationLineDetailInstance.bankAccountValue}" scale="${decimals}"/></td>
                        <td class="right"><g:debit value="${reconciliationLineDetailInstance.bankAccountValue}" scale="${decimals}"/></td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </g:form>
    <div class="paginateButtons">
        <g:paginate total="${reconciliationLineDetailInstanceTotal}" id="${reconciliationLineInstance.id}"/>
    </div>
</div>
</body>
</html>
