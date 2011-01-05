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
    <title><g:msg code="period.open" default="Open New Accounting Period"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="period.open" default="Open New Accounting Period"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:if test="${queueNumber}">
        <g:render template="/system/submitted" model="[queueNumber: queueNumber]"/>
    </g:if>
    <g:else>
        <g:if test="${periodInstance}">
            <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
                <g:msg code="period.to.open" args="${[periodInstance?.code]}" default="Click the submit button to open period ${periodInstance.code}."/>
            </div>
            <g:form action="opening" method="post">
                <input type="hidden" name="p_stringId" value="${periodInstance?.id}"/>
                <div class="dialog">
                    <table>
                        <tbody>
                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="preferredStart"><g:msg code="queuedTask.demand.delay" default="Delay Until"/>:</label>
                            </td>
                            <td valign="top" class="value">
                                <input initialField="true" type="text" size="20" id="preferredStart" name="preferredStart" value=""/>&nbsp;<g:help code="queuedTask.demand.delay"/>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="${msg(code: 'generic.submit', 'default': 'Submit')}"/></span>
                </div>
            </g:form>
        </g:if>
        <g:else>
            <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
                <g:msg code="period.no.open" default="No period is available to open."/>
            </div>
        </g:else>
    </g:else>
</div>
</body>
</html>
