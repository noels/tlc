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
<%@ page import="com.whollygrails.tlc.sys.SystemPageHelp" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemPageHelp.list" default="Page Help List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemPageHelp.new" default="New Page Help" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemPageHelp.list" default="Page Help List" />
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>
    <div align="center"><h2><g:msg code="systemPageHelp.message" default="Click on the page title above to see an example of Page Help."/></h2></div>
    <div class="criteria">
        <g:criteria include="code, locale, text"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemPageHelp.code" />

                <g:sortableColumn property="locale" title="Locale" titleKey="systemPageHelp.locale" />

                <g:sortableColumn property="text" title="Text" titleKey="systemPageHelp.text" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${systemPageHelpInstanceList}" status="i" var="systemPageHelpInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemPageHelpInstance.id}">${display(bean:systemPageHelpInstance, field:'code')}</g:link></td>

                    <td>${display(bean:systemPageHelpInstance, field:'locale')}</td>

                    <td>${display(bean:systemPageHelpInstance, field:'text')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemPageHelpInstanceTotal}" />
    </div>
</div>
</body>
</html>
