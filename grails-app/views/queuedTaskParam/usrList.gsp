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
    <title><g:msg code="queuedTaskParam.list" default="Queued Task Parameter List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:if test="${ddSource}">
        <g:pageTitle code="queuedTaskParam.list.for" args="${[ddSource.toString()]}" default="Parameter List for Queued Task ${ddSource.toString()}" returns="true"/>
    </g:if>
    <g:else>
        <g:pageTitle code="queuedTaskParam.list" default="Queued Task Parameter List"/>
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

                <th><g:msg code="queuedTaskParam.param" default="Parameter"/></th>

                <g:sortableColumn property="value" title="Value" titleKey="queuedTaskParam.value"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${queuedTaskParamInstanceList}" status="i" var="queuedTaskParamInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="usrShow" id="${queuedTaskParamInstance.id}"><g:msg code="taskParam.name.${queuedTaskParamInstance.param.code}" default="${queuedTaskParamInstance.param.name}"/></g:link></td>

                    <td>${display(bean: queuedTaskParamInstance, field: 'value')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${queuedTaskParamInstanceTotal}"/>
    </div>
</div>
</body>
</html>
