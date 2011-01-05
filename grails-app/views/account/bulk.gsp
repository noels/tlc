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
    <title><g:msg code="account.bulk" default="Bulk Account Creation"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="account.bulk" default="Bulk Account Creation"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${chartSectionRangeInstance}">
        <div class="errors">
            <g:listErrors bean="${chartSectionRangeInstance}"/>
        </div>
    </g:hasErrors>
    <g:if test="${chartSectionList}">
        <p>&nbsp;</p>
        <p><g:msg code="account.bulk.limit" args="${[limit]}" default="Note that there is a limit of ${limit} accounts that can be created in any one go. You may re-run bulk creation multiple times with the same criteria if you need more than this number of accounts creating in one section."/></p>
        <p>&nbsp;</p>
        <g:form action="preview" method="post">
            <div class="dialog">
                <table>
                    <tbody>
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="section.id"><g:msg code="account.bulk.section" default="Section"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: chartSectionRangeInstance, field: 'section', 'errors')}">
                            <g:domainSelect initialField="true" name="section.id" options="${chartSectionList}" selected="${chartSectionRangeInstance.section}" displays="name"/>&nbsp;<g:help code="account.bulk.section"/>
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="rangeFrom"><g:msg code="account.bulk.rangeFrom" default="Range From"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: chartSectionRangeInstance, field: 'rangeFrom', 'errors')}">
                            <input type="text" maxlength="87" size="30" id="rangeFrom" name="rangeFrom" value="${display(bean: chartSectionRangeInstance, field: 'rangeFrom')}"/>&nbsp;<g:help code="account.bulk.rangeFrom"/>
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="rangeTo"><g:msg code="account.bulk.rangeTo" default="Range To"/>:</label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: chartSectionRangeInstance, field: 'rangeTo', 'errors')}">
                            <input type="text" maxlength="87" size="30" id="rangeTo" name="rangeTo" value="${display(bean: chartSectionRangeInstance, field: 'rangeTo')}"/>&nbsp;<g:help code="account.bulk.rangeTo"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <span class="button"><input class="save" type="submit" value="${msg(code: 'account.bulk.button', 'default': 'Preview')}"/></span>
            </div>
        </g:form>
    </g:if>
    <g:else>
        <h2><g:msg code="account.no.sections" default="No sections found with ranges defined"/></h2>
    </g:else>
</div>
</body>
</html>
