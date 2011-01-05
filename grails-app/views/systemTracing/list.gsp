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
<%@ page import="com.whollygrails.tlc.sys.SystemTracing" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemTracing.list" default="Tracing List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemTracing.new" default="New Tracing" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemTracing.list" default="Tracing List" />
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="domainName, insertSecurityCode*, updateSecurityCode*, deleteSecurityCode*, insertRetentionDays, updateRetentionDays, deleteRetentionDays, systemOnly"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="domainName" title="Domain Name" titleKey="systemTracing.domainName" />

                <th><g:msg code="systemTracing.insertSecurityCode" default="Insert Trace Setting"/>></th>

                <th><g:msg code="systemTracing.updateSecurityCode" default="Update Trace Setting"/>></th>

                <th><g:msg code="systemTracing.deleteSecurityCode" default="Delete Trace Setting"/>></th>

                <g:sortableColumn property="insertRetentionDays" title="Insert Retention Days" titleKey="systemTracing.insertRetentionDays" />

                <g:sortableColumn property="updateRetentionDays" title="Update Retention Days" titleKey="systemTracing.updateRetentionDays" />

                <g:sortableColumn property="deleteRetentionDays" title="Delete Retention Days" titleKey="systemTracing.deleteRetentionDays" />

                <g:sortableColumn property="systemOnly" title="System Only" titleKey="systemTracing.systemOnly" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemTracingInstanceList}" status="i" var="systemTracingInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemTracingInstance.id}">${display(bean:systemTracingInstance, field:'domainName')}</g:link></td>

                    <td>${display(bean:systemTracingInstance, field:'insertDecode')}</td>

                    <td>${display(bean:systemTracingInstance, field:'updateDecode')}</td>

                    <td>${display(bean:systemTracingInstance, field:'deleteDecode')}</td>

                    <td>${display(bean:systemTracingInstance, field:'insertRetentionDays')}</td>

                    <td>${display(bean:systemTracingInstance, field:'updateRetentionDays')}</td>

                    <td>${display(bean:systemTracingInstance, field:'deleteRetentionDays')}</td>

                    <td>${display(bean:systemTracingInstance, field:'systemOnly')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemTracingInstanceTotal}" />
    </div>
</div>
</body>
</html>
