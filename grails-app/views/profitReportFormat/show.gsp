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
<%@ page import="com.whollygrails.tlc.books.ProfitReportFormat" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="profitReportFormat.show" default="Show Report Format"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="profitReportFormat.list" default="Report Format List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="profitReportFormat.new" default="New Report Format"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="clone" id="${profitReportFormatInstance.id}"><g:msg code="profitReportFormat.clone" default="Clone Report Format"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="profitReportFormat.show" default="Show Report Format"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>
            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>
                    <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'id')}</td>

                </tr>
            </g:permit>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.name" default="Name"/>:</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'name')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.title" default="Title"/>:</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'title')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.subTitle" default="Sub-Title"/>:</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'subTitle')}</td>

            </tr>
            </tbody>
        </table>

        <table>
            <thead>
            <tr>
                <th></th>
                <th><g:msg code="profitReportFormat.column1" default="Column 1"/></th>
                <th><g:msg code="profitReportFormat.column2" default="Column 2"/></th>
                <th><g:msg code="profitReportFormat.column3" default="Column 3"/></th>
                <th><g:msg code="profitReportFormat.column4" default="Column 4"/></th>
            </tr>
            </thead>

            <tbody>
            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.column1Heading" default="Heading"/>:</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column1Heading')}</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column2Heading')}</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column3Heading')}</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column4Heading')}</td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.column1SubHeading" default="Sub-Heading"/>:</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column1SubHeading')}</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column2SubHeading')}</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column3SubHeading')}</td>
                <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'column4SubHeading')}</td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name nowrap"><g:msg code="profitReportFormat.column1PrimaryData" default="Primary Data"/>:</td>
                <td valign="top" class="value nowrap">${(profitReportFormatInstance.column1PrimaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column1PrimaryData, default: profitReportFormatInstance.column1PrimaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value nowrap">${(profitReportFormatInstance.column2PrimaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column2PrimaryData, default: profitReportFormatInstance.column2PrimaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value nowrap">${(profitReportFormatInstance.column3PrimaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column3PrimaryData, default: profitReportFormatInstance.column3PrimaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value nowrap">${(profitReportFormatInstance.column4PrimaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column4PrimaryData, default: profitReportFormatInstance.column4PrimaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.column1Calculation" default="Calculation"/>:</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column1Calculation ? msg(code: 'profitReportFormat.calculationOptions.' + profitReportFormatInstance.column1Calculation, default: profitReportFormatInstance.column1Calculation) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column2Calculation ? msg(code: 'profitReportFormat.calculationOptions.' + profitReportFormatInstance.column2Calculation, default: profitReportFormatInstance.column2Calculation) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column3Calculation ? msg(code: 'profitReportFormat.calculationOptions.' + profitReportFormatInstance.column3Calculation, default: profitReportFormatInstance.column3Calculation) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column4Calculation ? msg(code: 'profitReportFormat.calculationOptions.' + profitReportFormatInstance.column4Calculation, default: profitReportFormatInstance.column4Calculation) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.column1SecondaryData" default="Secondary Data"/>:</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column1SecondaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column1SecondaryData, default: profitReportFormatInstance.column1SecondaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column2SecondaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column2SecondaryData, default: profitReportFormatInstance.column2SecondaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column3SecondaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column3SecondaryData, default: profitReportFormatInstance.column3SecondaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
                <td valign="top" class="value">${(profitReportFormatInstance.column4SecondaryData ? msg(code: 'profitReportFormat.dataOptions.' + profitReportFormatInstance.column4SecondaryData, default: profitReportFormatInstance.column4SecondaryData) : msg(code: 'generic.no.selection', default: '-- none --'))}</td>
            </tr>
            </tbody>
        </table>
        <table>
            <tbody>
            <tr class="prop">
                <td valign="top" class="name"><g:msg code="profitReportFormat.percentageSections" default="Total Percentage Section(s)"/>:</td>
                <td valign="top" class="value">
                    <g:if test="${profitReportPercentInstanceList}">
                        <g:each in="${profitReportPercentInstanceList}" status="i" var="profitReportPercentInstance">
                            ${i ? '<br/>' : ''}${profitReportPercentInstance.section.code.encodeAsHTML()} - ${profitReportPercentInstance.section.name.encodeAsHTML()}
                        </g:each>
                    </g:if>
                    <g:else>
                        <g:msg code="generic.no.selection" default="-- none --"/>
                    </g:else>
                </td>
            </tr>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>
                    <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'securityCode')}</td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'dateCreated')}</td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>
                    <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'lastUpdated')}</td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>
                    <td valign="top" class="value">${display(bean: profitReportFormatInstance, field: 'version')}</td>
                </tr>
            </g:permit>
            </tbody>
        </table>

        <table>
            <thead>
            <tr>
                <th><g:msg code="profitReportLine.lineNumber" default="Line Number"/></th>
                <th><g:msg code="profitReportLine.text" default="Text"/></th>
                <th><g:msg code="profitReportLine.section" default="Chart Section"/></th>
                <th><g:msg code="profitReportLine.accumulation" default="Accumulation"/></th>
            </tr>
            </thead>

            <tbody>
            <g:if test="${profitReportFormatInstance.lines}">
                <g:each in="${profitReportFormatInstance.lines}" status="j" var="profitReportLineInstance">
                    <tr class="${(j % 2) == 0 ? 'odd' : 'even'}">
                        <td>${display(bean: profitReportLineInstance, field: 'lineNumber')}</td>
                        <td>${display(bean: profitReportLineInstance, field: 'text')}</td>
                        <td>${profitReportLineInstance.section ? (profitReportLineInstance.section.code + ' - ' + profitReportLineInstance.section.name).encodeAsHTML() : ''}</td>
                        <td>${display(bean: profitReportLineInstance, field: 'accumulation')}</td>
                    </tr>
                </g:each>
            </g:if>
            <g:else>
                <tr>
                    <td colspan="4"><g:msg code="profitReportFormat.no.lines" default="The Report Format has no lines"/></td>
                </tr>
            </g:else>
            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${profitReportFormatInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
