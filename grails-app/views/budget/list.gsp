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
    <title><g:msg code="budget.list" default="Budget List"/></title>
    <g:yuiResources require="connection"/>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="search" action="filterSettings" params="${[target: 'list']}"><g:msg code="generic.filter" default="Filter"/></g:link></span>
    <g:if test="${accountInstanceList}">
        <span class="menuButton"><g:link class="print" action="print"><g:msg code="generic.print" default="Print" /></g:link></span>
    </g:if>
</div>
<div class="body">
    <g:pageTitle code="budget.list" default="Budget List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div id="ajaxErrorMessage" class="errors" style="visibility:hidden;"></div>
    <div class="center" style="margin-bottom:10px;"><g:msg code="reconciliation.currency.note" args="${[currencyCode]}" default="(All values shown in ${currencyCode})"/></div>
    <div class="list">
        <g:form>
            <input type="hidden" id="responseMessage" name="responseMessage" value="${msg(code: 'generic.ajax.response', default: 'Unable to understand the response from the server')}"/>
            <input type="hidden" id="timeoutMessage" name="timeoutMessage" value="${msg(code: 'generic.ajax.timeout', default: 'Operation timed out waiting for a response from the server')}"/>
            <table>
                <thead>
                <tr>

                    <g:sortableColumn property="code" title="Code" titleKey="account.code"/>

                    <g:sortableColumn property="name" title="Name" titleKey="account.name"/>

                    <g:sortableColumn property="active" title="Active" titleKey="account.active"/>

                    <g:sortableColumn property="status" title="Status" titleKey="account.status"/>

                    <g:each in="${periodInstanceList}" status="i" var="periodInstance">
                        <th class="right">${display(bean: periodInstance, field: 'code')}</th>
                    </g:each>

                </tr>
                </thead>
                <tbody>
                <g:each in="${accountInstanceList}" status="i" var="accountInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                        <td>${display(bean: accountInstance, field: 'code')}</td>

                        <td>${display(bean: accountInstance, field: 'name')}</td>

                        <td>${display(bean: accountInstance, field: 'active')}</td>

                        <td><g:msg code="account.status.${accountInstance.status}" default="${accountInstance.status}"/></td>

                        <g:each in="${periodInstanceList}" status="j" var="periodInstance">
                            <td><input class="right" initialField="${j == 0 && i == 0}" type="text" size="${fieldWidth}" id="${generalBalanceInstanceList[(i * periodInstanceList.size()) + j]}" name="${generalBalanceInstanceList[(i * periodInstanceList.size()) + j]}" value="${format(value: generalBalanceInstanceList[(i * periodInstanceList.size()) + j].companyBudget * ((accountInstance.status == 'cr') ? -1 : 1), scale: 0, grouped: true)}" onchange="changeBudget(this, '${createLink(controller: 'document', action: 'budget')}')"/></td>
                        </g:each>

                    </tr>
                </g:each>
                </tbody>
            </table>
        </g:form>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${accountInstanceTotal}"/>
    </div>
</div>
</body>
</html>
