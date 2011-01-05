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
<%@ page import="com.whollygrails.tlc.books.ChartSectionRange" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="chartSectionRange.list" default="Chart Section Range List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="chartSectionRange.new" default="New Chart Section Range" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="chartSectionRange.list.for" args="${[ddSource.name]}" default="Chart Section Range List for ${ddSource.name}" returns="true"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="type*, rangeFrom, rangeTo, comment, messageText"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="type" title="Type" titleKey="chartSectionRange.type" />

                <g:sortableColumn property="rangeFrom" title="Range From" titleKey="chartSectionRange.rangeFrom" />

                <g:sortableColumn property="rangeTo" title="Range To" titleKey="chartSectionRange.rangeTo" />

                <g:sortableColumn property="comment" title="Comment" titleKey="chartSectionRange.comment" />

                <g:sortableColumn property="messageText" title="Message Text" titleKey="chartSectionRange.messageText" />

            </tr>
            </thead>
            <tbody>
            <g:each in="${chartSectionRangeInstanceList}" status="i" var="chartSectionRangeInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${chartSectionRangeInstance.id}"><g:msg code="chartSectionRange.type.${chartSectionRangeInstance.type}" default="${chartSectionRangeInstance.type}"/></g:link></td>

                    <td>${display(bean:chartSectionRangeInstance, field:'rangeFrom')}</td>

                    <td>${display(bean:chartSectionRangeInstance, field:'rangeTo')}</td>

                    <td>${display(bean:chartSectionRangeInstance, field:'comment')}</td>

                    <td>${display(bean:chartSectionRangeInstance, field:'messageText')}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${chartSectionRangeInstanceTotal}" />
    </div>
</div>
</body>
</html>
