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
    <title><g:msg code="report.postings" default="Detailed Postings Report"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="report.postings" default="Detailed Postings Report"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${generalBalanceInstance}">
        <div class="errors">
            <g:listErrors bean="${generalBalanceInstance}"/>
        </div>
    </g:hasErrors>
    <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
        <g:msg code="generic.task.submit" default="Click the Submit button to run the report."/>
    </div>
    <g:form action="detailedPostingsReport" method="post">
        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="period.id"><g:msg code="report.period" default="Period"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: generalBalanceInstance, field: 'period', 'errors')}">
                        <g:select initialField="true" optionKey="id" optionValue="code" from="${periodInstanceList}" name="period.id" value="${generalBalanceInstance.period?.id}"/>&nbsp;<g:help code="report.period"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="scope.code"><g:msg code="report.postings.scope" default="Report Scope"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: generalBalanceInstance, field: 'generalBudget', 'errors')}">
                        <g:domainSelect name="scope.code" options="${scopeList}" selected="${scope}" returns="code" displays="name" prefix="report.postings" code="code" default="name" sort="false"/>&nbsp;<g:help code="report.postings.scope"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="selector"><g:msg code="report.postings.selector" default="Section or Account Code"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: generalBalanceInstance, field: 'companyBudget', 'errors')}">
                        <input type="text" maxlength="87" size="30" id="selector" name="selector" value="${selector}"/>&nbsp;<g:help code="report.postings.selector"/>
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
