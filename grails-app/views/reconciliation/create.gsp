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
    <title><g:msg code="reconciliation.create" default="Create Reconciliation"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list" params="${[bankAccount: reconciliationInstance.bankAccount.id]}"><g:msg code="reconciliation.list" default="Reconciliation List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="reconciliation.create.for" args="${[reconciliationInstance.bankAccount.name, reconciliationInstance.bankAccount.currency.code]}" default="Create Reconciliation in ${reconciliationInstance.bankAccount.currency.code} for ${reconciliationInstance.bankAccount.name}"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${reconciliationInstance}">
        <div class="errors">
            <g:listErrors bean="${reconciliationInstance}"/>
        </div>
    </g:hasErrors>
    <div style="margin:10px;text-align:center;font-size:12px;font-weight:bold;">
        <g:msg code="generic.task.submit" default="Click the Submit button to run the report."/>
    </div>
    <g:form action="save" method="post">
        <input type="hidden" name="bankAccount" value="${reconciliationInstance.bankAccount.id}"/>
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td colspan="2" style="padding-top:15px;padding-bottom:15px;"><g:msg code="reconciliation.warn" default="Be sure to enter the correct statement date and balance otherwise you will have to delete the reconciliation and recreate it."/></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="statementDate"><g:msg code="reconciliation.statementDate" default="Statement Date"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: reconciliationInstance, field: 'statementDate', 'errors')}">
                        <input initialField="true" type="text" name="statementDate" id="statementDate" size="20" value="${display(bean: reconciliationInstance, field: 'statementDate', scale: 1)}"/>&nbsp;<g:help code="reconciliation.statementDate"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="statementBalance"><g:msg code="reconciliation.statementBalance" default="Statement Balance"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: reconciliationInstance, field: 'statementBalance', 'errors')}">
                        <input type="text" id="statementBalance" name="statementBalance" size="20" value="${display(bean: reconciliationInstance, field: 'statementBalance', scale: reconciliationInstance.bankAccount.currency.decimals)}"/>&nbsp;<g:help code="reconciliation.statementBalance"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="preferredStart"><g:msg code="queuedTask.demand.delay" default="Delay Until"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <input type="text" size="20" id="preferredStart" name="preferredStart" value=""/>&nbsp;<g:help code="queuedTask.demand.delay"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'generic.submit', 'default': 'Submit')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
