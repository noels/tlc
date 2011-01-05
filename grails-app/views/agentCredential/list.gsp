
<%--
 ~   Copyright 2010 Wholly Grails.
 ~
 ~   This file is part of the Three Ledger Core (TLC) software
 ~   from Wholly Grails.
 ~
 ~   TLC is free software: you can redistribute it and/or modify
 ~   it under the terms of the GNU General Public License as published by
 ~   the Free Software Foundation, either version 3 of the License, or
 ~   (at your option) any later version.
 ~
 ~   TLC is distributed in the hope that it will be useful,
 ~   but WITHOUT ANY WARRANTY; without even the implied warranty of
 ~   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ~   GNU General Public License for more details.
 ~
 ~   You should have received a copy of the GNU General Public License
 ~   along with TLC.  If not, see <http://www.gnu.org/licenses/>.
 --%>
<%@ page import="com.whollygrails.tlc.rest.AgentCredential" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="company"/>
    <title><g:msg code="agentCredential.list" default="Agent Credentials List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="agentCredential.new" default="New Agent Credentials" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="agentCredential.list.for" args="${[ddSource.user.name]}" default="Agent Credentials List for User ${ddSource.user.name}" returns="true"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, secret, dateCreated, active"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="dateCreated" title="Created" titleKey="agentCredential.dateCreated" />

                <g:sortableColumn property="code" title="Code" titleKey="agentCredential.code" />

                <g:sortableColumn property="secret" title="Secret" titleKey="agentCredential.secret" />

                <g:sortableColumn property="active" title="Active" titleKey="agentCredential.active" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${agentCredentialInstanceList}" status="i" var="agentCredentialInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${agentCredentialInstance.id}">${display(bean:agentCredentialInstance, field:'dateCreated', scale: 2)}</g:link></td>

                    <td>${display(bean:agentCredentialInstance, field:'code')}</td>

                    <td>${display(bean:agentCredentialInstance, field:'secret')}</td>

                    <td>${display(bean:agentCredentialInstance, field:'active')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${agentCredentialInstanceTotal}" />
    </div>
</div>
</body>
</html>
