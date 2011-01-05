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
    <title><g:msg code="budget.adjust" default="Budget Adjustment"/></title>
    <g:yuiResources require="connection"/>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="budget.adjust" default="Budget Adjustment"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div id="ajaxErrorMessage" class="errors" style="visibility:hidden;"></div>
    <g:form action="adjusting" method="post">
        <input type="hidden" id="responseMessage" name="responseMessage" value="${msg(code: 'generic.ajax.response', default: 'Unable to understand the response from the server')}"/>
        <input type="hidden" id="timeoutMessage" name="timeoutMessage" value="${msg(code: 'generic.ajax.timeout', default: 'Operation timed out waiting for a response from the server')}"/>
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td></td>
                    <td valign="top" class="value"><g:msg code="systemConversion.source" default="Source"/></td>
                    <td valign="top" class="value"><g:msg code="systemConversion.target" default="Target"/></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="year"><g:msg code="budget.adjust.year" default="Year"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <g:domainSelect initialField="true" onchange="changeYear(this, '${createLink(controller: 'document', action: 'year')}', 'periods')" id="year" options="${yearInstanceList}" selected="${yearInstance}" displays="code" sort="false"/>&nbsp;<g:help code="budget.adjust.year"/>
                    </td>
                    <td valign="top" class="value nowrap">
                        <g:domainSelect onchange="changeYear(this, '${createLink(controller: 'document', action: 'year')}', 'targetPeriods')" id="targetYear" options="${targetYearInstanceList}" selected="${targetYearInstance}" displays="code" sort="false"/>&nbsp;<g:help code="budget.adjust.targetYear"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="periods"><g:msg code="budget.filter.periods" default="Periods"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <g:domainSelect size="${Math.min(20, periodInstanceList.size())}" id="periods" options="${periodInstanceList}" selected="${selectedPeriods}" displays="code" sort="false"/>&nbsp;<g:help code="budget.adjust.periods"/>
                    </td>
                    <td valign="top" class="value nowrap">
                        <g:domainSelect size="${Math.min(20, targetPeriodInstanceList.size())}" id="targetPeriods" options="${targetPeriodInstanceList}" selected="${targetSelectedPeriods}" displays="code" sort="false"/>&nbsp;<g:help code="budget.adjust.targetPeriods"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="sectionType"><g:msg code="budget.adjust.sectionType" default="Section Type"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <g:select id="sectionType" name="sectionType" onchange="changeSectionType(this, '${createLink(controller: 'document', action: 'sectionType')}', 'section')" from="${chartSectionInstance.constraints.type.inList}" value="${sectionType}" valueMessagePrefix="chartSection.type" noSelection="['': msg(code: 'generic.all.selection', default: '-- all --')]"/>&nbsp;<g:help code="budget.adjust.sectionType"/>
                    </td>
                    <td></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="section"><g:msg code="budget.adjust.section" default="Section"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <g:domainSelect id="section" options="${chartSectionInstanceList}" selected="${chartSectionInstance}" displays="name" sort="false" noSelection="['': msg(code: 'generic.all.selection', default: '-- all --')]"/>&nbsp;<g:help code="budget.adjust.section"/>
                    </td>
                    <td></td>
                </tr>

                <g:each in="${codeElementInstanceList}" status="i" var="codeElementInstance">
                    <g:if test="${valueLists.get(codeElementInstance.elementNumber.toString())}">
                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="value${codeElementInstance.elementNumber}">${codeElementInstance.name.encodeAsHTML()}:</label>
                            </td>

                            <td valign="top" class="value">
                                <g:domainSelect id="value${codeElementInstance.elementNumber}" options="${valueLists.get(codeElementInstance.elementNumber.toString())}" selected="${selectedValues.get(codeElementInstance.elementNumber.toString())}" displays="code" sort="false" noSelection="['': msg(code: 'generic.all.selection', default: '-- all --')]"/>&nbsp;<g:help code="budget.adjust.values"/>
                            </td>
                            <td></td>
                        </tr>
                    </g:if>
                </g:each>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="sourceData"><g:msg code="budget.adjust.sourceData" default="Source Data"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <g:domainSelect id="sourceData" options="${sourceDataInstanceList}" selected="${sourceDataInstance}" displays="name" sort="false"/>&nbsp;<g:help code="budget.adjust.sourceData"/>
                    </td>
                    <td></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="adjustmentType"><g:msg code="budget.adjust.adjustmentType" default="Adjustment Type"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <g:domainSelect id="adjustmentType" options="${adjustmentTypeInstanceList}" selected="${adjustmentTypeInstance}" displays="name" sort="false" noSelection="['': msg(code: 'generic.no.selection', default: '-- none --')]"/>&nbsp;<g:help code="budget.adjust.adjustmentType"/>
                    </td>
                    <td></td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="adjustmentValue"><g:msg code="budget.adjust.adjustmentValue" default="Adjustment Value"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <input type="text" size="20" id="adjustmentValue" name="adjustmentValue" value="${display(value: adjustmentValue, scale: adjustmentScale)}"/>&nbsp;<g:help code="budget.adjust.adjustmentValue"/>
                    </td>
                    <td></td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'update', 'default': 'Update')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
