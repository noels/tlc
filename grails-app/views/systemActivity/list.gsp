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
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemActivity.list" default="System Activity List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemActivity.new" default="New System Activity"/></g:link></span>
    <g:if test="${ddSource}">
        <span class="menuButton"><g:link class="links" action="links"><g:msg code="generic.define.links" default="Define Links"/></g:link></span>
    </g:if>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="systemActivity.list.for" args="${[message(code: 'role.name.' + ddSource.code, default: ddSource.name)]}" default="Activity List for Role ${message(code: 'role.name.' + ddSource.code, default: ddSource.name)}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="systemActivity.list" default="System Activity List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="code, systemOnly"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemActivity.code"/>

                <g:sortableColumn property="systemOnly" title="System Only" titleKey="systemActivity.systemOnly"/>

                <th><g:msg code="systemActivity.actions" default="Actions"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemActivityInstanceList}" status="i" var="systemActivityInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemActivityInstance.id}">${display(bean: systemActivityInstance, field: 'code')}</g:link></td>

                    <td>${display(bean: systemActivityInstance, field: 'systemOnly')}</td>

                    <td><g:drilldown controller="systemAction" action="list" value="${systemActivityInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemActivityInstanceTotal}"/>
    </div>
</div>
</body>
</html>
