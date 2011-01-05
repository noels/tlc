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
    <title><g:msg code="balanceReport.title" default="Balance Sheet Report"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="balanceReport.title" default="Balance Sheet Report"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${balanceReportInstance}">
        <div class="errors">
            <g:listErrors bean="${balanceReportInstance}"/>
        </div>
    </g:hasErrors>
    <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
        <g:msg code="balanceReport.text" default="Click the Submit button to create the report."/>
    </div>
    <g:form action="balanceReporting" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="format.id"><g:msg code="balanceReport.format" default="Format"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: balanceReportInstance, field: 'format', 'errors')}">
                        <g:domainSelect initialField="true" id="format.id" options="${formatInstanceList}" selected="${balanceReportInstance.format}" displays="name" sort="false"/>&nbsp;<g:help code="balanceReport.format"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="period.id"><g:msg code="balanceReport.period" default="Period"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: balanceReportInstance, field: 'period', 'errors')}">
                        <g:domainSelect id="period.id" options="${periodInstanceList}" selected="${balanceReportInstance.period}" displays="code" sort="false"/>&nbsp;<g:help code="balanceReport.period"/>
                    </td>
                </tr>

                <g:if test="${groupingList.size() >= 1}">
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="grouping1.id"><g:msg code="balanceReport.grouping1" default="Grouping"/>:</label>
                        </td>

                        <td valign="top" class="value ${hasErrors(bean: balanceReportInstance, field: 'grouping1', 'errors')}">
                            <g:domainSelect id="grouping1.id" options="${groupingList}" selected="${balanceReportInstance.grouping1}" displays="name" sort="false" noSelection="['': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="balanceReport.grouping1"/>
                        </td>
                    </tr>
                </g:if>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="detailed"><g:msg code="balanceReport.detailed" default="Detailed Accounts"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: balanceReportInstance, field: 'detailed', 'errors')}">
                        <g:checkBox name="detailed" value="${balanceReportInstance.detailed}"/>&nbsp;<g:help code="balanceReport.detailed"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="preferredStart"><g:msg code="queuedTask.demand.delay" default="Delay Until"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <input type="text" size="20" id="preferredStart" name="preferredStart" value=""/>&nbsp;<g:help code="queuedTask.demand.delay"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'generic.submit', 'default': 'Submit')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
