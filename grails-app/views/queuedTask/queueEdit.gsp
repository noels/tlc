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
    <title><g:msg code="queuedTask.sys.edit" default="Edit Task Queue Entry"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="queue"><g:msg code="queuedTask.sys.list" default="System Task Queue"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="queuedTask.sys.edit" default="Edit Task Queue Entry"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${queuedTaskInstance}">
        <div class="errors">
            <g:listErrors bean="${queuedTaskInstance}"/>
        </div>
    </g:hasErrors>
    <div align="center"><g:msg code="generic.server.time" args="${[new Date()]}" default="The current date and time on the server is ${new Date()}."/></div>
    <g:form method="post">
        <input type="hidden" name="id" value="${queuedTaskInstance?.id}"/>
        <input type="hidden" name="version" value="${queuedTaskInstance?.version}"/>
        <g:render template="queueDialog" model="[queuedTaskInstance: queuedTaskInstance]"/>
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="queueUpdate" value="${msg(code:'update', 'default':'Update')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="queueDelete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
