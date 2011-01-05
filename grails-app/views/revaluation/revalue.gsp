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
    <title><g:msg code="revaluation.title" default="Foreign Currency Revaluation"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="revaluation.title" default="Foreign Currency Revaluation"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${revaluationInstance}">
        <div class="errors">
            <g:listErrors bean="${revaluationInstance}"/>
        </div>
    </g:hasErrors>
    <g:if test="${queueNumber}">
        <g:render template="/system/submitted" model="[queueNumber: queueNumber]"/>
    </g:if>
    <g:else>
        <g:if test="${periodList}">
            <g:if test="${accountList}">
                <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
                    <g:msg code="revaluation.text" default="Click the submit button to perform the revaluation."/>
                </div>
                <g:form action="revaluing" method="post">
                    <div class="dialog">
                        <table>
                            <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="period.id"><g:msg code="revaluation.period" default="Period"/>:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: revaluationInstance, field: 'period', 'errors')}">
                                    <g:select initialField="true" optionKey="id" optionValue="code" from="${periodList}" name="period.id" value="${revaluationInstance.period?.id}"/>&nbsp;<g:help code="revaluation.period"/>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="account.id"><g:msg code="revaluation.account" default="Account"/>:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: revaluationInstance, field: 'account', 'errors')}">
                                    <g:select optionKey="id" optionValue="name" from="${accountList}" name="account.id" value="${revaluationInstance.account?.id}"/>&nbsp;<g:help code="revaluation.account"/>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="adjustment"><g:msg code="revaluation.adjustment" default="Adjustment"/>:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: revaluationInstance, field: 'adjustment', 'errors')}">
                                    <g:checkBox name="adjustment" value="${revaluationInstance?.adjustment}"></g:checkBox>&nbsp;<g:help code="revaluation.adjustment"/>
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
            </g:if>
            <g:else>
                <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
                    <g:msg code="revaluation.no.control" default="Neither an fxDiff account nor an fxRevalue account exists in the General Ledger."/>
                </div>
            </g:else>
        </g:if>
        <g:else>
            <div style="margin:30px;text-align:center;font-size:12px;font-weight:bold;">
                <g:msg code="revaluation.no.open" default="No open period exists to revalue."/>
            </div>
        </g:else>
    </g:else>
</div>
</body>
</html>
