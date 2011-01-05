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
    <title><g:msg code="accessGroup.list" default="Access Group List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="edits"><g:msg code="accessGroup.edits" default="Edit Access Groups"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="accessGroup.display.for" args="${[ddSource.user.name]}" default="Access Group List for User ${ddSource.user.name}" returns="true"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="code, name"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="accessGroup.code"/>

                <g:sortableColumn property="name" title="Name" titleKey="accessGroup.name"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${accessGroupInstanceList}" status="i" var="accessGroupInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>${display(bean: accessGroupInstance, field: 'code')}</td>

                    <td>${display(bean: accessGroupInstance, field: 'name')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${accessGroupInstanceTotal}"/>
    </div>
</div>
</body>
</html>
