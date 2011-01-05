
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
<%@ page import="com.whollygrails.tlc.sys.SystemPaymentSchedule" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemPaymentSchedule.list" default="System Payment Schedule List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemPaymentSchedule.new" default="New System Payment Schedule" /></g:link></span>
    <span class="menuButton"><g:link class="test" action="test"><g:msg code="systemPaymentSchedule.test" default="Test System Payment Schedule"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemPaymentSchedule.list" default="System Payment Schedule List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="code, monthDayPattern, weekDayPattern"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="code" title="Code" titleKey="systemPaymentSchedule.code" />

                <th><g:msg code="systemPaymentSchedule.name" default="Name"/></th>

                <g:sortableColumn property="monthDayPattern" title="Month Day Pattern" titleKey="systemPaymentSchedule.monthDayPattern" />

                <g:sortableColumn property="weekDayPattern" title="Week Day Pattern" titleKey="systemPaymentSchedule.weekDayPattern" />

                <th><g:msg code="systemPaymentSchedule.propagate" default="Propagate"/>&nbsp;<g:help code="systemPaymentSchedule.propagate"/></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${systemPaymentScheduleInstanceList}" status="i" var="systemPaymentScheduleInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${systemPaymentScheduleInstance.id}">${display(bean:systemPaymentScheduleInstance, field:'code')}</g:link></td>

                    <td><g:msg code="paymentSchedule.name.${systemPaymentScheduleInstance.code}" default="${systemPaymentScheduleInstance.name}"/></td>

                    <td>${display(bean:systemPaymentScheduleInstance, field:'monthDayPattern')}</td>

                    <td>${display(bean:systemPaymentScheduleInstance, field:'weekDayPattern')}</td>

                    <td><g:form method="post" action="propagate" id="${systemPaymentScheduleInstance.id}"><input type="submit" value="${msg(code: 'systemPaymentSchedule.propagate', default: 'Propagate')}"/></g:form></td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${systemPaymentScheduleInstanceTotal}" />
    </div>
</div>
</body>
</html>
