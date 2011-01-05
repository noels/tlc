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
<%@ page import="com.whollygrails.tlc.books.BalanceReportFormat" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="balanceReportLine.edit" default="Edit Report Format Lines"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="edit" action="edit" id="${balanceReportFormatInstance.id}"><g:msg code="balanceReportLine.header" default="Report Format Header"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="balanceReportLine.edit.for" args="${[balanceReportFormatInstance.name]}" default="Edit Report Format Lines for ${balanceReportFormatInstance.name}"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${balanceReportFormatInstance}">
        <div class="errors">
            <g:listErrors bean="${balanceReportFormatInstance}"/>
        </div>
    </g:hasErrors>
    <SCRIPT language="JavaScript">
        function needResequence() {
            document.getElementById('resequence').value = 'true';
            return true;
        }
    </SCRIPT>
    <g:form method="post">
        <input type="hidden" name="id" value="${balanceReportFormatInstance?.id}"/>
        <input type="hidden" id="resequence" name="resequence" value="" />
        <div class="dialog">
            <table>
                <thead>
                <tr>
                    <th><g:msg code="balanceReportLine.lineNumber" default="Line Number"/>&nbsp;<g:help code="balanceReportLine.lineNumber"/></th>
                    <th><g:msg code="balanceReportLine.text" default="Text"/>&nbsp;<g:help code="balanceReportLine.text"/></th>
                    <th><g:msg code="balanceReportLine.section" default="Chart Section"/>&nbsp;<g:help code="balanceReportLine.section"/></th>
                    <th><g:msg code="balanceReportLine.accumulation" default="Accumulation"/>&nbsp;<g:help code="balanceReportLine.accumulation"/></th>
                </tr>
                </thead>

                <tbody>
                <g:each in="${balanceReportFormatInstance.lines}" status="i" var="balanceReportLineInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td valign="top" class="value ${hasErrors(bean: balanceReportLineInstance, field: 'lineNumber', 'errors')}">
                            <input type="text" maxlength="10" size="10" id="lines[${i}].lineNumber" name="lines[${i}].lineNumber" value="${display(bean: balanceReportLineInstance, field: 'lineNumber')}"/>
                            <input type="hidden" name="index${i}" value="${balanceReportLineInstance.id}"/>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: balanceReportLineInstance, field: 'text', 'errors')}">
                            <input type="text" maxlength="50" size="50" id="lines[${i}].text" name="lines[${i}].text" value="${display(bean: balanceReportLineInstance, field: 'text')}"/>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: balanceReportLineInstance, field: 'section', 'errors')}">
                            <g:domainSelect id="lines[${i}].section.id" options="${chartSectionInstanceList}" selected="${balanceReportLineInstance?.section}" displays="${['code', 'name']}" sort="false" noSelection="['': msg(code: 'generic.no.selection', default: '-- none --')]"/>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: balanceReportLineInstance, field: 'accumulation', 'errors')}">
                            <input type="text" maxlength="200" size="50" id="lines[${i}].accumulation" name="lines[${i}].accumulation" value="${display(bean: balanceReportLineInstance, field: 'accumulation')}"/>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="process" value="${msg(code:'update', 'default':'Update')}"/></span>
            <span class="button"><g:actionSubmit class="save" action="process" onclick="return needResequence()" value="${msg(code:'balanceReportLine.resequence', 'default':'Resequence')}"/></span>
            <span class="button"><g:actionSubmit class="edit" action="adding" value="${msg(code:'document.more.lines', 'default':'More Lines')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
