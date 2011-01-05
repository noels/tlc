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
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="remittanceLine.new" default="New Remittance Allocation"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="remittanceLine.list" default="Remittance Allocation List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="remittanceLine.new" default="New Remittance Allocation" help="remittance"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${remittanceLineInstance}">
        <div class="errors">
            <g:listErrors bean="${remittanceLineInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="save" method="post">
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="targetType.id"><g:msg code="document.allocation.type" default="Document Type"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap ${hasErrors(bean: remittanceLineInstance, field: 'targetType', 'errors')}">
                        <g:domainSelect initialField="true" name="targetType.id" options="${documentTypeList}" selected="${remittanceLineInstance.targetType}" displays="${['code', 'name']}"/>&nbsp;<g:help code="document.allocation.type"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="code"><g:msg code="document.allocation.code" default="Code"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap ${hasErrors(bean: remittanceLineInstance, field: 'code', 'errors')}">
                        <input type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean: remittanceLineInstance, field: 'code')}"/>&nbsp;<g:help code="document.allocation.code"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="payment"><g:msg code="remittanceLine.amount" default="Amount"/>:</label>
                    </td>
                    <td valign="top" class="value nowrap ${hasErrors(bean: remittanceLineInstance, field: 'payment', 'errors')}">
                        <input type="text" size="12" id="payment" name="payment" value="${display(bean: remittanceLineInstance, field: 'payment', scale: ddSource.supplier.currency.decimals)}"/>&nbsp;<g:help code="remittanceLine.amount"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'create', 'default': 'Create')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
