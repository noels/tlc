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
<%@ page import="com.whollygrails.tlc.sys.SystemTrace" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemTrace.list" default="Trace List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemTrace.list" default="Trace List" />
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="id, dateCreated, databaseAction*, domainName, domainId, domainVersion, domainData"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="id" title="Id" titleKey="generic.id" />

                <g:sortableColumn property="dateCreated" title="Date Created" titleKey="generic.dateCreated" />

                <th><g:msg code="systemTrace.domainSecurityCode" default="Company" /></th>

                <g:sortableColumn property="databaseAction" title="Database Action" titleKey="systemTrace.databaseAction" />

                <g:sortableColumn property="domainName" title="Domain Name" titleKey="systemTrace.domainName" />

                <g:sortableColumn property="domainData" title="Domain Data" titleKey="systemTrace.domainData" />

                <g:sortableColumn property="domainId" title="Domain Id" titleKey="systemTrace.domainId" />

                <g:sortableColumn property="domainVersion" title="Domain Version" titleKey="systemTrace.domainVersion" />

                <th><g:msg code="systemTrace.userId" default="User" /></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemTraceInstanceList}" status="i" var="systemTraceInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemTraceInstance.id}">${display(bean:systemTraceInstance, field:'id')}</g:link></td>

                    <td>${display(bean:systemTraceInstance, field:'dateCreated')}</td>

                    <td>${display(bean:systemTraceInstance, field:'companyDecode')}</td>

                    <td><g:msg code="systemTrace.databaseAction.${systemTraceInstance.databaseAction}" default="${systemTraceInstance.databaseAction}"/></td>

                    <td>${display(bean:systemTraceInstance, field:'domainName')}</td>

                    <td>${display(bean:systemTraceInstance, field:'domainData')}</td>

                    <td>${display(bean:systemTraceInstance, field:'domainId')}</td>

                    <td>${display(bean:systemTraceInstance, field:'domainVersion')}</td>

                    <td>${display(bean:systemTraceInstance, field:'userDecode')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemTraceInstanceTotal}" />
    </div>
</div>
</body>
</html>
