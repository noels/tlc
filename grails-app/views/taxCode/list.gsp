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
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="taxCode.list" default="Tax Code List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="taxCode.new" default="New Tax Code"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="taxCode.list" default="Tax Code List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="code"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="taxCode.code"/>

                <th><g:msg code="taxCode.name" default="Name"/></th>

                <th><g:msg code="taxCode.authority" default="Tax Authority"/></th>

                <th><g:msg code="taxCode.rates" default="Rates"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${taxCodeInstanceList}" status="i" var="taxCodeInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${taxCodeInstance.id}">${display(bean: taxCodeInstance, field: 'code')}</g:link></td>

                    <td><g:msg code="taxCode.name.${taxCodeInstance.code}" default="${taxCodeInstance.name}"/></td>

                    <td>${taxCodeInstance.authority.name.encodeAsHTML()}</td>

                    <td><g:drilldown controller="taxRate" value="${taxCodeInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${taxCodeInstanceTotal}"/>
    </div>
</div>
</body>
</html>
