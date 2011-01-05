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
    <title><g:msg code="incomeReport.title" default="Income and Expenditure Report"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="incomeReport.title" default="Income and Expenditure Report"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${incomeReportInstance}">
        <div class="errors">
            <g:listErrors bean="${incomeReportInstance}"/>
        </div>
    </g:hasErrors>
    <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
        <g:msg code="incomeReport.text" default="Click the Submit button to create the report."/>
    </div>
    <g:form action="incomeReporting" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="format.id"><g:msg code="incomeReport.format" default="Format"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: incomeReportInstance, field: 'format', 'errors')}">
                        <g:domainSelect initialField="true" id="format.id" options="${formatInstanceList}" selected="${incomeReportInstance.format}" displays="name" sort="false"/>&nbsp;<g:help code="incomeReport.format"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="period.id"><g:msg code="incomeReport.period" default="Period"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: incomeReportInstance, field: 'period', 'errors')}">
                        <g:domainSelect id="period.id" options="${periodInstanceList}" selected="${incomeReportInstance.period}" displays="code" sort="false"/>&nbsp;<g:help code="incomeReport.period"/>
                    </td>
                </tr>

                <g:each in="${codeElementInstanceList}" status="i" var="codeElementInstance">
                    <g:if test="${valueLists.get(codeElementInstance.elementNumber.toString())}">
                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="element${codeElementInstance.elementNumber}.id">${codeElementInstance.name.encodeAsHTML()}:</label>
                            </td>

                            <td valign="top" class="value ${hasErrors(bean: incomeReportInstance, field: 'element' + codeElementInstance.elementNumber.toString(), 'errors')}">
                                <g:domainSelect id="element${codeElementInstance.elementNumber}.id" options="${valueLists.get(codeElementInstance.elementNumber.toString())}" selected="${incomeReportInstance.('element' + codeElementInstance.elementNumber.toString())}" displays="code" sort="false" noSelection="['': msg(code: 'generic.all.selection', default: '-- all --')]"/>&nbsp;<g:help code="incomeReport.element"/>
                            </td>
                        </tr>
                    </g:if>
                </g:each>

                <g:if test="${groupingList.size() >= 1}">
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="grouping1.id"><g:msg code="incomeReport.grouping1" default="Grouping 1"/>:</label>
                        </td>

                        <td valign="top" class="value ${hasErrors(bean: incomeReportInstance, field: 'grouping1', 'errors')}">
                            <g:domainSelect id="grouping1.id" options="${groupingList}" selected="${incomeReportInstance.grouping1}" displays="name" sort="false" noSelection="['': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="incomeReport.grouping1"/>
                        </td>
                    </tr>
                </g:if>

                <g:if test="${groupingList.size() >= 2}">
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="grouping2.id"><g:msg code="incomeReport.grouping2" default="Grouping 2"/>:</label>
                        </td>

                        <td valign="top" class="value ${hasErrors(bean: incomeReportInstance, field: 'grouping2', 'errors')}">
                            <g:domainSelect id="grouping2.id" options="${groupingList}" selected="${incomeReportInstance.grouping2}" displays="name" sort="false" noSelection="['': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="incomeReport.grouping2"/>
                        </td>
                    </tr>
                </g:if>

                <g:if test="${groupingList.size() >= 3}">
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="grouping3.id"><g:msg code="incomeReport.grouping3" default="Grouping 3"/>:</label>
                        </td>

                        <td valign="top" class="value ${hasErrors(bean: incomeReportInstance, field: 'grouping3', 'errors')}">
                            <g:domainSelect id="grouping3.id" options="${groupingList}" selected="${incomeReportInstance.grouping3}" displays="name" sort="false" noSelection="['': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="incomeReport.grouping3"/>
                        </td>
                    </tr>
                </g:if>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="detailed"><g:msg code="incomeReport.detailed" default="Detailed Accounts"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: incomeReportInstance, field: 'detailed', 'errors')}">
                        <g:checkBox name="detailed" value="${incomeReportInstance.detailed}"/>&nbsp;<g:help code="incomeReport.detailed"/>
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
