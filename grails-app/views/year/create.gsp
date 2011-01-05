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
<%@ page import="com.whollygrails.tlc.books.Year" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="year.create" default="Create Year"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="year.list" default="Year List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="year.create" default="Create Year"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${yearInstance}">
        <div class="errors">
            <g:listErrors bean="${yearInstance}"/>
        </div>
    </g:hasErrors>
    <g:if test="${newYearIsProhibited}">
        <p>&nbsp;</p>
        <h2><g:msg code="year.no.new" default="You may not create a new year until all periods of the preceding year have been defined."/></h2>
        <p>&nbsp;</p>
    </g:if>
    <g:else>
        <g:form action="save" method="post">
            <g:render template="dialog" model="[yearInstance: yearInstance]"/>
            <div class="buttons">
                <span class="button"><input class="save" type="submit" value="${msg(code: 'create', 'default': 'Create')}"/></span>
            </div>
        </g:form>
    </g:else>
</div>
</body>
</html>
