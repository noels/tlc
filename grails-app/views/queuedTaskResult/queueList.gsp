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
    <title><g:msg code="queuedTaskResult.list" default="Queued Task Result List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="queuedTaskResult.list.for" args="${[ddSource.toString()]}" default="Result List for Queued Task ${ddSource.toString()}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="queuedTaskResult.list" default="Queued Task Result List"/>
    </g:else>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="criteria">
        <g:criteria include="value"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <th><g:msg code="queuedTaskResult.result" default="Result"/></th>

                <g:sortableColumn property="value" title="Value" titleKey="queuedTaskResult.value"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${queuedTaskResultInstanceList}" status="i" var="queuedTaskResultInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="queueShow" id="${queuedTaskResultInstance.id}"><g:msg code="taskResult.name.${queuedTaskResultInstance.result.code}" default="${queuedTaskResultInstance.result.name}"/></g:link></td>

                    <td>${display(bean: queuedTaskResultInstance, field: 'value')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${queuedTaskResultInstanceTotal}"/>
    </div>
</div>
</body>
</html>
