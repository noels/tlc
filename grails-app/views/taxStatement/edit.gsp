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
<%@ page import="com.whollygrails.tlc.corp.TaxStatement" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="taxStatement.edit" default="Edit Tax Statement"/></title>
    <g:yuiResources require="connection"/>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="taxStatement.list" default="Tax Statement List"/></g:link></span>
    <span class="menuButton"><g:link class="print" action="print" id="${taxStatementInstance?.id}"><g:msg code="generic.print" default="Print"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="taxStatement.new" default="New Tax Statement"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="taxStatement.edit" default="Edit Tax Statement"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${taxStatementInstance}">
        <div class="errors">
            <g:listErrors bean="${taxStatementInstance}"/>
        </div>
    </g:hasErrors>
    <g:if test="${taxStatementInstance.finalized}">
        <div style="text-align:center;margin-bottom:15px;"><g:msg code="taxStatement.isFinalized" default="This tax statement has been finalized and cannot be edited. It is displayed for viewing purposes only."/></div>
    </g:if>
    <g:elseif test="${!settings.totalTax}">
        <div style="text-align:center;margin-bottom:15px;"><g:msg code="taxStatement.no.value" default="This statement has a tax liability of zero and when you finalize it, no journal will be needed."/></div>
    </g:elseif>
    <g:else>
        <div id="ajaxErrorMessage" class="errors" style="visibility:hidden;"></div>
    </g:else>
    <g:form method="post">
        <input type="hidden" name="id" value="${taxStatementInstance?.id}"/>
        <input type="hidden" name="version" value="${taxStatementInstance?.version}"/>
        <input type="hidden" id="sourceNumber" name="sourceNumber" value="${display(bean: documentInstance, field: 'code')}"/>
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="taxStatement.authority" default="Tax Authority"/>:</td>
                    <td valign="top" class="value">${taxStatementInstance?.authority?.name?.encodeAsHTML()}</td>

                    <td valign="top" class="name"><g:msg code="taxStatement.statementDate" default="Statement Date"/>:</td>
                    <td valign="top" class="value">${display(bean: taxStatementInstance, field: 'statementDate', scale: 1)}</td>
                </tr>

                <g:if test="${taxStatementInstance.finalized}">
                    <tr class="prop">
                        <td valign="top" class="name"><g:msg code="taxStatement.description" default="Description"/>:</td>
                        <td valign="top" class="value">${display(bean: taxStatementInstance, field: 'description')}</td>

                        <td valign="top" class="name"><g:msg code="taxStatement.document" default="Document"/>:</td>
                        <g:if test="${taxStatementInstance.document}">
                            <td valign="top" class="value"><g:enquiryLink target="${taxStatementInstance.document}"><g:format value="${taxStatementInstance.document.type.code + taxStatementInstance.document.code}"/></g:enquiryLink></td>
                        </g:if>
                        <g:else>
                            <td valign="top" class="value"><g:msg code="generic.not.applicable" default="n/a"/></td>
                        </g:else>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name"></td>
                        <td valign="top" class="value"></td>

                        <g:if test="${settings.totalTax <= 0.0}">
                            <td valign="top" class="name"><g:msg code="taxStatement.totalPayable" default="Total Payable"/>:</td>
                            <td valign="top" class="value"><g:format value="${-settings.totalTax}" scale="${settings.decimals}"/></td>
                        </g:if>
                        <g:else>
                            <td valign="top" class="name"><g:msg code="taxStatement.totalRefund" default="Total Refund"/>:</td>
                            <td valign="top" class="value"><g:format value="${settings.totalTax}" scale="${settings.decimals}"/></td>
                        </g:else>
                    </tr>
                </g:if>
                <g:elseif test="${settings.totalTax}">
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="description"><g:msg code="taxStatement.description" default="Description"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'description', 'errors')}">
                            <input initialField="true" type="text" maxlength="50" size="45" id="description" name="description" value="${display(bean: taxStatementInstance, field: 'description')}"/>&nbsp;<g:help code="taxStatement.description"/>
                        </td>

                        <td valign="top" class="name">
                            <label for="period.id"><g:msg code="document.period" default="Accounting Period"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'period', 'errors')}">
                            <g:select optionKey="id" optionValue="code" from="${periodList}" name="period.id" value="${documentInstance?.period?.id}"/>&nbsp;<g:help code="document.period"/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="type.id"><g:msg code="document.type" default="Document Type"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'type', 'errors')}">
                            <g:domainSelect onchange="typeChanged()" onblur="getCode(this, '${createLink(controller: 'document', action: 'code')}', 'lines[0].accountCode')" name="type.id" options="${documentTypeList}" selected="${documentInstance?.type}" displays="${['code', 'name']}" noSelection="['': msg(code: 'generic.select', default: '-- select --')]"/>&nbsp;<g:help code="document.type"/>
                        </td>

                        <td valign="top" class="name">
                            <label for="code"><g:msg code="document.journal.code" default="Code"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'code', 'errors')}">
                            <input ${settings.codeEdit ? '' : 'disabled="true"'} type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean: documentInstance, field: 'code')}"/>&nbsp;<g:help code="document.journal.code"/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="lines[0].accountCode"><g:msg code="taxStatement.accountCode" default="GL Account"/>:</label>
                        </td>
                        <td colspan="3" class="value nowrap ${hasErrors(bean: documentLine, field: 'accountCode', 'errors')}">
                            <input type="text" maxLength="87" size="30" onchange="getAccount(this, '${createLink(controller: 'document', action: 'account')}', 'journal')" id="lines[0].accountCode" name="lines[0].accountCode" value="${display(bean: documentLine, field: 'accountCode')}"/>&nbsp;<g:help code="taxStatement.accountCode"/>
                            <input disabled="true" type="text" size="76" id="lines[0].displayName" name="lines[0].displayName" value="${display(bean: documentLine, field: 'accountName')}"/>
                            <input type="hidden" id="lines[0].accountName" name="lines[0].accountName" value="${display(bean: documentLine, field: 'accountName')}"/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="reference"><g:msg code="document.journal.reference" default="Reference"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'reference', 'errors')}">
                            <input type="text" maxLength="30" size="20" id="reference" name="reference" value="${display(bean: documentInstance, field: 'reference')}"/>&nbsp;<g:help code="document.journal.reference"/>
                        </td>

                        <g:if test="${settings.totalTax < 0.0}">
                            <td valign="top" class="name"><g:msg code="taxStatement.totalPayable" default="Total Payable"/>:</td>
                            <td valign="top" class="value"><g:format value="${-settings.totalTax}" scale="${settings.decimals}"/></td>
                        </g:if>
                        <g:else>
                            <td valign="top" class="name"><g:msg code="taxStatement.totalRefund" default="Total Refund"/>:</td>
                            <td valign="top" class="value"><g:format value="${settings.totalTax}" scale="${settings.decimals}"/></td>
                        </g:else>
                    </tr>
                </g:elseif>
                <g:else>
                    <tr class="prop">
                        <td valign="top" class="name"></td>
                        <td valign="top" class="value"></td>

                        <td valign="top" class="name"><g:msg code="taxStatement.totalPayable" default="Total Payable"/>:</td>
                        <td valign="top" class="value"><g:format value="${settings.totalTax}" scale="${settings.decimals}"/></td>
                    </tr>
                </g:else>
                </tbody>
            </table>
        </div>
        <div class="list entry">
            <table>
                <thead>
                <tr>
                    <g:if test="${settings.hasPriorInput || settings.hasPriorOutput}">
                        <th class="center"><g:msg code="taxStatementLine.currentStatement" default="Current"/></th>
                    </g:if>
                    <th><g:msg code="taxStatementLine.taxCode" default="Tax Code"/></th>
                    <th><g:msg code="taxCode.name" default="Name"/></th>
                    <th class="right"><g:msg code="taxStatementLine.taxPercentage" default="Tax Rate"/></th>
                    <th class="right"><g:msg code="taxStatementLine.companyGoodsValue" default="Goods Value"/></th>
                    <th class="right"><g:msg code="taxStatementLine.inputTax" default="Input Tax"/></th>
                    <th class="right"><g:msg code="taxStatementLine.outputTax" default="Output Tax"/></th>
                    <th><g:msg code="taxStatement.lines" default="Lines"/></th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${taxStatementLineList}" status="i" var="taxStatementLine">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <g:if test="${settings.hasPriorInput || settings.hasPriorOutput}">
                            <td class="center">${display(bean: taxStatementLine, field: 'currentStatement')}</td>
                        </g:if>
                        <td>${display(bean: taxStatementLine, field: 'taxCode')}</td>
                        <td><g:msg code="taxCode.name.${taxStatementLine.taxCode.code}" default="${taxStatementLine.taxCode.name}"/></td>
                        <td class="right">${display(bean: taxStatementLine, field: 'taxPercentage', scale: 3)}</td>
                        <td class="right"><g:drcr value="${taxStatementLine.companyGoodsValue}" scale="${settings.decimals}"/></td>
                        <g:if test="${taxStatementLine.expenditure}">
                            <td class="right"><g:format value="${taxStatementLine.companyTaxValue}" scale="${settings.decimals}"/></td>
                            <td></td>
                        </g:if>
                        <g:else>
                            <td></td>
                            <td class="right"><g:format value="${-taxStatementLine.companyTaxValue}" scale="${settings.decimals}"/></td>
                        </g:else>
                        <td><g:drilldown controller="taxStatementLine" domain="TaxStatementLine" ddAction="edit" value="${taxStatementLine.id}"/></td>
                    </tr>
                </g:each>
                <tr>
                    <g:if test="${settings.hasPriorInput || settings.hasPriorOutput}">
                        <th></th>
                    </g:if>
                    <th></th>
                    <th></th>
                    <th></th>
                    <th class="right"><g:msg code="document.sourceTotals" default="Totals"/>:</th>
                    <th class="right"><g:format value="${settings.totalInputTax}" scale="${settings.decimals}"/></th>
                    <th class="right"><g:format value="${-settings.totalOutputTax}" scale="${settings.decimals}"/></th>
                </tr>
                </tbody>
            </table>
        </div>
        <g:if test="${!taxStatementInstance.finalized}">
            <div class="buttons">
                <span class="button"><g:actionSubmit class="save" action="Update" value="${msg(code:'taxStatement.finalize', 'default':'Finalize')}"/></span>
                <span class="button"><g:actionSubmit class="delete" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
            </div>
        </g:if>
    </g:form>
</div>
</body>
</html>
