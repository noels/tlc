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
    <title><g:msg code="remittanceLine.list" default="Remittance Allocation List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="remittanceLine.new" default="New Remittance Allocation"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="remittanceLine.list.for" args="${[ddSource.supplier.name]}" default="Remittance Allocation List for Supplier ${ddSource.supplier.name}" returns="true" help="remittance"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="type, code, documentDate, dueDate, reference"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="documentDate" title="Document Date" titleKey="generic.documentDate" />

                <g:sortableColumn property="type" title="Document" titleKey="generic.generic.document" />

                <g:sortableColumn property="reference" title="Reference" titleKey="document.supplier.reference" />

                <g:sortableColumn property="dueDate" title="Due Date" titleKey="document.dueDate" />

                <th class="right"><g:msg code="remittanceLine.allocation" default="Allocation"/></th>

                <th><g:msg code="remittanceLine.new.amount" default="New Amount"/>&nbsp;<g:help code="remittanceLine.new.amount"/></th>

                <th><g:msg code="update" default="Update"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${remittanceLineInstanceList}" status="i" var="remittanceLineInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <g:form method="post" action="update" id="${remittanceLineInstance.id}">
                        <td>${display(bean: remittanceLineInstance, field: 'documentDate', scale: 1)}</td>

                        <td>${display(value: remittanceLineInstance.type + remittanceLineInstance.code)}</td>

                        <td>${display(bean: remittanceLineInstance, field: 'reference')}</td>

                        <td>${display(bean: remittanceLineInstance, field: 'dueDate', scale: 1)}</td>

                        <td class="right">${display(value: -remittanceLineInstance.accountUnallocated, scale: ddSource.supplier.currency.decimals)}</td>

                        <td>
                            <input type="text" size="15" id="payment" name="payment" value="${remittanceLineInstance.payment}"/>
                            <input type="hidden" name="max" value="${params.max}"/>
                            <input type="hidden" name="offset" value="${params.offset}"/>
                            <input type="hidden" name="sort" value="${params.sort}"/>
                            <input type="hidden" name="order" value="${params.order}"/>
                        </td>

                        <td><input type="submit" value="${msg(code: 'update', default: 'Update')}"/></td>
                    </g:form>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${remittanceLineInstanceTotal}"/>
    </div>
</div>
</body>
</html>
