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
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="chartSection.print" default="Print Chart Of Accounts"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="chartSection.list" default="Chart Section List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="chartSection.print" default="Print Chart Of Accounts"/>
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:if test="${queueNumber}">
        <g:render template="/system/submitted" model="[queueNumber: queueNumber]"/>
    </g:if>
    <g:else>
        <g:form action="printing" method="post">
            <g:render template="/system/submit" model="[parameters: parameters, now: now]"/>
            <div class="buttons">
                <span class="button"><input class="save" type="submit" value="${msg(code: 'generic.submit', 'default': 'Submit')}"/></span>
            </div>
        </g:form>
    </g:else>
</div>
</body>
</html>
