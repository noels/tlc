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
<%@ page import="com.whollygrails.tlc.books.Recurring" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="recurring.show" default="Show Recurring Bank Transaction"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="recurring.list" default="Recurring Bank Transaction List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="recurring.new" default="New Recurring Bank Transaction"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="recurring.show" default="Show Recurring Bank Transaction"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                    <td valign="top" class="value">${display(bean: recurringInstance, field: 'id')}</td>

                </tr>
            </g:permit>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.account" default="Bank Account"/>:</td>

                <td valign="top" class="value">${recurringInstance?.account?.name?.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.currency" default="Currency"/>:</td>

                <td valign="top" class="value">${recurringInstance?.currency?.name?.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.type" default="Document Type"/>:</td>

                <td valign="top" class="value">${recurringInstance?.type?.name?.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.reference" default="Reference"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'reference')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.description" default="Description"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'description')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.totalTransactions" default="Total Transactions"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'totalTransactions')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.initialDate" default="Initial Date"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'initialDate', scale: 1)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.initialValue" default="Initial Value"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'initialValue', scale: settings.decimals)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.recursFrom" default="Recurs From"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'recursFrom', scale: 1)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.recurrenceType" default="Recurrence Type"/>:</td>

                <td valign="top" class="value"><g:msg code="${'recurring.recurrenceType.' + recurringInstance.recurrenceType}" default="${recurringInstance.recurrenceType}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.recurrenceInterval" default="Recurrence Interval"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'recurrenceInterval')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.lastDayOfMonth" default="Last Day Of Month"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'lastDayOfMonth')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.recurringValue" default="Recurring Value"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'recurringValue', scale: settings.decimals)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.finalValue" default="Final Value"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'finalValue', scale: settings.decimals)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.autoAllocate" default="Auto Allocate"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'autoAllocate')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.processedCount" default="Processed Count"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'processedCount')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="recurring.nextDue" default="Next Due"/>:</td>

                <td valign="top" class="value">${display(bean: recurringInstance, field: 'nextDue', scale: 1)}</td>

            </tr>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: recurringInstance, field: 'securityCode')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: recurringInstance, field: 'dateCreated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: recurringInstance, field: 'lastUpdated')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: recurringInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${recurringInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
