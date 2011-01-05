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
    <title><g:msg code="queuedTaskParam.edit" default="Edit Queued Task Parameter"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="queueList"><g:msg code="queuedTaskParam.list" default="Queued Task Parameter List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="queuedTaskParam.edit" default="Edit Queued Task Parameter"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${queuedTaskParamInstance}">
        <div class="errors">
            <g:listErrors bean="${queuedTaskParamInstance}"/>
        </div>
    </g:hasErrors>
    <g:form method="post">
        <input type="hidden" name="id" value="${queuedTaskParamInstance?.id}"/>
        <input type="hidden" name="version" value="${queuedTaskParamInstance?.version}"/>
        <g:render template="dialog" model="[queuedTaskParamInstance: queuedTaskParamInstance]"/>
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="queueUpdate" value="${msg(code:'update', 'default':'Update')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
