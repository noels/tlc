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
<%@ page import="com.whollygrails.tlc.sys.SystemDocumentType" %>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="code"><g:msg code="documentType.code" default="Code"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'code', 'errors')}">
                <input initialField="true" type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean: documentTypeInstance, field: 'code')}"/>&nbsp;<g:help code="documentType.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="documentType.name" default="Name"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'name', 'errors')}">
                <input type="text" maxlength="30" size="30" id="name" name="name" value="${display(bean: documentTypeInstance, field: 'name')}"/>&nbsp;<g:help code="documentType.name"/>
            </td>
        </tr>

        <g:if test="${documentTypeInstance.id}">
            <tr class="prop">
                <td valign="top" class="name">
                    <g:msg code="documentType.type" default="Type"/>:
                </td>
                <td valign="top" class="value">
                    <g:msg code="systemDocumentType.name.${documentTypeInstance.type.code}" default="${documentTypeInstance.type.name}"/>
                </td>
            </tr>
        </g:if>
        <g:else>
            <tr class="prop">
                <td valign="top" class="name">
                    <label for="type.id"><g:msg code="documentType.type" default="Type"/>:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'type', 'errors')}">
                    <g:domainSelect name="type.id" options="${SystemDocumentType.list()}" selected="${documentTypeInstance?.type}" prefix="systemDocumentType.name" code="code" default="name"/>&nbsp;<g:help code="documentType.type"/>
                </td>
            </tr>
        </g:else>

        <g:if test="${!documentTypeInstance.id || !['ACR', 'PRR'].contains(documentTypeInstance?.type?.code)}">
            <tr class="prop">
                <td valign="top" class="name">
                    <label for="nextSequenceNumber"><g:msg code="documentType.nextSequenceNumber" default="Next Sequence Number"/>:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'nextSequenceNumber', 'errors')}">
                    <input type="text" id="nextSequenceNumber" name="nextSequenceNumber" size="10" value="${display(bean: documentTypeInstance, field: 'nextSequenceNumber')}"/>&nbsp;<g:help code="documentType.nextSequenceNumber"/>
                </td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name">
                    <label for="autoGenerate"><g:msg code="documentType.autoGenerate" default="Auto Generate"/>:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'autoGenerate', 'errors')}">
                    <g:checkBox name="autoGenerate" value="${documentTypeInstance?.autoGenerate}"></g:checkBox>&nbsp;<g:help code="documentType.autoGenerate"/>
                </td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name">
                    <label for="allowEdit"><g:msg code="documentType.allowEdit" default="Allow Edit"/>:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'allowEdit', 'errors')}">
                    <g:checkBox name="allowEdit" value="${documentTypeInstance?.allowEdit}"></g:checkBox>&nbsp;<g:help code="documentType.allowEdit"/>
                </td>
            </tr>

            <g:if test="${!documentTypeInstance.id || documentTypeInstance.type.code == 'BP'}">
                <tr>
                    <td valign="top" colspan="2" class="name"><h2><g:msg code="documentType.autoPayments" default="Auto Payments"/></h2></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="autoBankAccount.id"><g:msg code="documentType.autoBankAccount" default="Bank Account"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'autoBankAccount', 'errors')}">
                        <g:select name="autoBankAccount.id" from="${bankAccountList}" value="${documentTypeInstance.autoBankAccount?.id}" optionKey="id" optionValue="name" noSelection="['null': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="documentType.autoBankAccount"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="autoForeignCurrency"><g:msg code="documentType.autoForeignCurrency" default="Foreign Currency"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'autoForeignCurrency', 'errors')}">
                        <g:checkBox name="autoForeignCurrency" value="${documentTypeInstance?.autoForeignCurrency}"></g:checkBox>&nbsp;<g:help code="documentType.autoForeignCurrency"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="autoMaxPayees"><g:msg code="documentType.autoMaxPayees" default="Maximum Payees"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'autoMaxPayees', 'errors')}">
                        <input type="text" id="autoMaxPayees" name="autoMaxPayees" size="5" value="${display(bean: documentTypeInstance, field: 'autoMaxPayees')}"/>&nbsp;<g:help code="documentType.autoMaxPayees"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="autoBankDetails"><g:msg code="documentType.autoBankDetails" default="Bank Details"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentTypeInstance, field: 'autoBankDetails', 'errors')}">
                        <g:checkBox name="autoBankDetails" value="${documentTypeInstance?.autoBankDetails}"></g:checkBox>&nbsp;<g:help code="documentType.autoBankDetails"/>
                    </td>
                </tr>
            </g:if>
        </g:if>

        </tbody>
    </table>
</div>
