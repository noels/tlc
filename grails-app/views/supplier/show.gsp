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
<%@ page import="com.whollygrails.tlc.books.Supplier" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="supplier.show" default="Show Supplier"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="supplier.list" default="Supplier List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="supplier.new" default="New Supplier"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="supplier.show" default="Show Supplier"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                    <td valign="top" class="value">${display(bean: supplierInstance, field: 'id')}</td>

                </tr>
            </g:permit>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.code" default="Code"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'code')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.name" default="Name"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'name')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.country" default="Country"/>:</td>

                <td valign="top" class="value"><g:msg code="country.name.${supplierInstance.country.code}" default="${supplierInstance.country.name}"/></td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.currency" default="Currency"/>:</td>

                <td valign="top" class="value"><g:msg code="currency.name.${supplierInstance.currency.code}" default="${supplierInstance.currency.name}"/></td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.revaluationMethod" default="Revaluation Method"/>:</td>

                <td valign="top" class="value">${supplierInstance.revaluationMethod ? msg(code: 'supplier.revaluationMethod.' + supplierInstance.revaluationMethod, default: supplierInstance.revaluationMethod) : ''}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.taxId" default="Tax Id"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'taxId')}</td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.taxCode" default="Tax Code"/>:</td>

                <td valign="top" class="value">${supplierInstance.taxCode ? msg(code: 'taxCode.name.' + supplierInstance.taxCode.code, default: supplierInstance.taxCode.name) : ''}</td>
            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.accountCurrentBalance" default="Current Balance"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'accountCurrentBalance', scale: supplierInstance.currency.decimals)}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.accountCreditLimit" default="Credit Limit"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'accountCreditLimit', scale: 0)}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.settlementDays" default="Settlement Days"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'settlementDays')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.periodicSettlement" default="Periodic Settlement"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'periodicSettlement')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.active" default="Active"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'active')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.accessCode" default="Access Code"/>:</td>

                <td valign="top" class="value">${supplierInstance.accessCode?.encodeAsHTML()}</td>

            </tr>

            <tr>
                <td valign="top" colspan="2" class="name"><h2><g:msg code="documentType.autoPayments" default="Auto Payments"/></h2></td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.schedule" default="Auto-Payment Schedule"/>:</td>

                <td valign="top" class="value">${supplierInstance.schedule ? msg(code: 'paymentSchedule.name.' + supplierInstance.schedule.code, default: supplierInstance.schedule.name) : ''}</td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.documentType" default="Auto-Payment Document Type"/>:</td>

                <td valign="top" class="value"><g:display value="${supplierInstance.documentType?.name}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.bankSortCode" default="Bank Sort Code"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'bankSortCode')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.bankAccountName" default="Bank Account Name"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'bankAccountName')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.bankAccountNumber" default="Bank Account Number"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'bankAccountNumber')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="supplier.nextAutoPaymentDate" default="Next Auto-Payment Date"/>:</td>

                <td valign="top" class="value">${display(bean: supplierInstance, field: 'nextAutoPaymentDate', scale: 1)}</td>

            </tr>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: supplierInstance, field: 'securityCode')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: supplierInstance, field: 'dateCreated')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: supplierInstance, field: 'lastUpdated')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: supplierInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${supplierInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <g:if test="${!hasTransactions}">
                <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
            </g:if>
        </g:form>
    </div>
</div>
</body>
</html>
