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
<%@ page import="com.whollygrails.tlc.corp.ExchangeCurrency; com.whollygrails.tlc.corp.TaxCode; com.whollygrails.tlc.books.AccessCode; com.whollygrails.tlc.sys.SystemCountry" %>
<SCRIPT language="JavaScript">
    function setRevaluation() {
        document.getElementById('revaluationMethod').value = (document.getElementById('currency.id').value == ${companyCurrencyId}) ? '' : 'standard';
        return true;
    }
</SCRIPT>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="code"><g:msg code="customer.code" default="Code" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'code','errors')}">
                <input initialField="true" type="text" maxlength="20" size="20" id="code" name="code" value="${display(bean:customerInstance,field:'code')}"/>&nbsp;<g:help code="customer.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="customer.name" default="Name" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'name','errors')}">
                <input type="text" maxlength="50" size="30" id="name" name="name" value="${display(bean:customerInstance,field:'name')}"/>&nbsp;<g:help code="customer.name"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="country.id"><g:msg code="customer.country" default="Country" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'country','errors')}">
                <g:domainSelect name="country.id" options="${SystemCountry.list()}" selected="${customerInstance?.country}" prefix="country.name" code="code" default="name"/>&nbsp;<g:help code="customer.country"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="currency.id"><g:msg code="customer.currency" default="Currency" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'currency','errors')}">
                <g:domainSelect name="currency.id" options="${currencyList}" selected="${customerInstance?.currency}" prefix="currency.name" code="code" default="name" onchange="setRevaluation()"/>&nbsp;<g:help code="customer.currency"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="revaluationMethod"><g:msg code="customer.revaluationMethod" default="Revaluation Method"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: customerInstance, field: 'revaluationMethod', 'errors')}">
                <g:select id="revaluationMethod" name="revaluationMethod" from="${customerInstance.constraints.revaluationMethod.inList}" value="${customerInstance.revaluationMethod}" valueMessagePrefix="customer.revaluationMethod" noSelection="['': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="customer.revaluationMethod"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="taxId"><g:msg code="customer.taxId" default="Tax Id" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'taxId','errors')}">
                <input type="text" maxlength="20" size="20" id="taxId" name="taxId" value="${display(bean:customerInstance,field:'taxId')}"/>&nbsp;<g:help code="customer.taxId"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="taxCode.id"><g:msg code="customer.taxCode" default="Tax Code" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'taxCode','errors')}">
                <g:domainSelect name="taxCode.id" options="${taxList}" selected="${customerInstance?.taxCode}" prefix="taxCode.name" code="code" default="name" noSelection="['null': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="customer.taxCode"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="accountCreditLimit"><g:msg code="customer.accountCreditLimit" default="Credit Limit" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'accountCreditLimit','errors')}">
                <input type="text" id="accountCreditLimit" name="accountCreditLimit" size="20" value="${display(bean:customerInstance,field:'accountCreditLimit', scale: 0)}" />&nbsp;<g:help code="customer.accountCreditLimit"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="settlementDays"><g:msg code="customer.settlementDays" default="Settlement Days" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'settlementDays','errors')}">
                <input type="text" maxlength="3" size="5" id="settlementDays" name="settlementDays" value="${display(bean:customerInstance,field:'settlementDays')}"/>&nbsp;<g:help code="customer.settlementDays"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="periodicSettlement"><g:msg code="customer.periodicSettlement" default="Periodic Settlement" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'periodicSettlement','errors')}">
                <g:checkBox name="periodicSettlement" value="${customerInstance.periodicSettlement}"></g:checkBox>&nbsp;<g:help code="customer.periodicSettlement"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="active"><g:msg code="customer.active" default="Active"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: customerInstance, field: 'active', 'errors')}">
                <g:checkBox name="active" value="${customerInstance?.active}"></g:checkBox>&nbsp;<g:help code="customer.active"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="accessCode.id"><g:msg code="customer.accessCode" default="Access Code" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:customerInstance,field:'accessCode','errors')}">
                <g:select optionKey="id" optionValue="name" from="${accessList}" name="accessCode.id" value="${customerInstance?.accessCode?.id}" />&nbsp;<g:help code="customer.accessCode"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
