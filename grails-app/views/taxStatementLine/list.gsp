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
<%@ page import="com.whollygrails.tlc.corp.TaxStatementLine" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="taxStatementLine.list" default="Tax Statement Line List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="taxStatementLine.list" default="Tax Statement Line List" returns="true" params="${[id: taxStatementInstance.id]}"/>
    <div class="dialog">
        <table>
            <tbody>
            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taxStatement.authority" default="Authority"/>:</td>
                <td valign="top" class="value">${taxStatementInstance.authority.name.encodeAsHTML()}</td>

                <td valign="top" class="name"><g:msg code="taxStatement.statementDate" default="Statement Date"/>:</td>
                <td valign="top" class="value">${display(bean: taxStatementInstance, field: 'statementDate', scale: 1)}</td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taxStatementLine.currentStatement" default="Current"/>:</td>
                <td valign="top" class="value">${display(bean: taxStatementLineInstance, field: 'currentStatement')}</td>

                <td valign="top" class="name"><g:msg code="taxStatementLine.expenditure" default="Input"/>:</td>
                <td valign="top" class="value">${display(bean: taxStatementLineInstance, field: 'expenditure')}</td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taxStatementLine.taxCode" default="Tax Code"/>:</td>
                <td valign="top" class="value">${(taxStatementLineInstance.taxCode.code + ' - ' + taxStatementLineInstance.taxCode.name).encodeAsHTML()}</td>

                <td valign="top" class="name"><g:msg code="taxStatementLine.taxPercentage" default="Tax Rate"/>:</td>
                <td valign="top" class="value">${display(bean: taxStatementLineInstance, field: 'taxPercentage', scale: 3)}</td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="taxStatementLine.companyGoodsValue" default="Goods Value"/>:</td>
                <td valign="top" class="value"><g:drcr value="${goods}" scale="${decimals}" zeroIsUnmarked="true"/></td>

                <td valign="top" class="name"><g:msg code="taxStatementLine.companyTaxValue" default="Tax Value"/>:</td>
                <td valign="top" class="value"><g:drcr value="${tax}" scale="${decimals}" zeroIsUnmarked="true"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>
                <th><g:msg code="generic.document" default="Document"/></th>
                <th><g:msg code="generic.documentDate" default="Document Date"/></th>
                <th><g:msg code="generalTransaction.description" default="Description"/></th>
                <th class="right"><g:msg code="taxStatementLine.companyGoodsValue" default="Goods Value"/></th>
                <th class="right"><g:msg code="taxStatementLine.companyTaxValue" default="Tax Value"/></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${transactionInstanceList}" status="i" var="transactionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:format value="${transactionInstance.document.type.code + transactionInstance.document.code}"/></td>
                    <td><g:format value="${transactionInstance.document.documentDate}" scale="1"/></td>
                    <td>${display(bean: transactionInstance, field: 'description')}</td>
                    <g:if test="${taxStatementLineInstance.expenditure}">
                        <td class="right"><g:format value="${transactionInstance.companyTax}" scale="${decimals}"/></td>
                        <td class="right"><g:format value="${transactionInstance.companyValue}" scale="${decimals}"/></td>
                    </g:if>
                    <g:else>
                        <td class="right"><g:format value="${-transactionInstance.companyTax}" scale="${decimals}"/></td>
                        <td class="right"><g:format value="${-transactionInstance.companyValue}" scale="${decimals}"/></td>
                    </g:else>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${transactionInstanceTotal}"/>
    </div>
</div>
</body>
</html>
