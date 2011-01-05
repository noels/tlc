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
    <title><g:msg code="systemPaymentSchedule.test" default="Test System Payment Schedule"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="systemPaymentSchedule.list" default="System Payment Schedule List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemPaymentSchedule.test" default="Test System Payment Schedule"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemPaymentScheduleInstance}">
        <div class="errors">
            <g:listErrors bean="${systemPaymentScheduleInstance}"/>
        </div>
    </g:hasErrors>
    <g:form method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="id"><g:msg code="systemPaymentSchedule.test.schedule" default="Payment Schedule"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemPaymentScheduleInstance, field: 'id', 'errors')}">
                        <g:domainSelect initialField="true" name="id" options="${scheduleList}" selected="${systemPaymentScheduleInstance?.id}" prefix="paymentSchedule.name" code="code" default="name"/>&nbsp;<g:help code="systemPaymentSchedule.test.schedule"/>
                    </td>
                </tr>

                <g:if test="${predictions}">
                    <tr class="prop">
                        <td valign="top" class="name">
                            <g:msg code="systemPaymentSchedule.test.results" default="Results"/>:
                        </td>
                        <td></td>
                    </tr>
                    <g:each in="${predictions}" var="prediction">
                        <tr>

                            <td></td>
                            <td valign="top" class="value">
                                <g:format value="${prediction}" scale="1"/>
                            </td>

                        </tr>
                    </g:each>
                </g:if>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="testing" value="${msg(code:'systemPaymentSchedule.test.button', 'default':'Test')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
