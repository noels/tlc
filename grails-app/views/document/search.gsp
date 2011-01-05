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
    <title><g:msg code="documentSearch.search" default="Document Search"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="documentSearch.search" default="Document Search"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${documentSearchInstance}">
        <div class="errors">
            <g:listErrors bean="${documentSearchInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="list" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop nowrap">
                    <td valign="top" class="name">
                        <label for="type.id"><g:msg code="documentSearch.type" default="Document Type"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'type', 'errors')}">
                        <g:domainSelect initialField="true" name="type.id" options="${documentTypeList}" selected="${documentSearchInstance?.type}" displays="${['code', 'name']}"/>&nbsp;<g:help code="documentSearch.type"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="code"><g:msg code="documentSearch.code" default="Code"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'code', 'errors')}">
                        <input type="text" size="20" id="code" name="code" value="${display(bean: documentSearchInstance, field: 'code')}"/>&nbsp;<g:help code="documentSearch.code"/>
                    </td>
                </tr>

                <tr class="prop nowrap">
                    <td valign="top" class="name">
                        <label for="reference"><g:msg code="documentSearch.reference" default="Reference"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'reference', 'errors')}">
                        <input type="text" size="30" id="reference" name="reference" value="${display(bean: documentSearchInstance, field: 'reference')}"/>&nbsp;<g:help code="documentSearch.reference"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="description"><g:msg code="documentSearch.description" default="Description"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'description', 'errors')}">
                        <input type="text" size="45" id="description" name="description" value="${display(bean: documentSearchInstance, field: 'description')}"/>&nbsp;<g:help code="documentSearch.description"/>
                    </td>
                </tr>

                <tr class="prop nowrap">
                    <td valign="top" class="name">
                        <label for="documentFrom"><g:msg code="documentSearch.documentFrom" default="Documents Dated From"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'documentFrom', 'errors')}">
                        <input type="text" size="20" id="documentFrom" name="documentFrom" value="${format(value: documentSearchInstance.documentFrom, scale: 1)}"/>&nbsp;<g:help code="documentSearch.documentFrom"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="documentTo"><g:msg code="documentSearch.documentTo" default="Documents Dated To"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'documentTo', 'errors')}">
                        <input type="text" size="20" id="documentTo" name="documentTo" value="${format(value: documentSearchInstance.documentTo, scale: 1)}"/>&nbsp;<g:help code="documentSearch.documentTo"/>
                    </td>
                </tr>

                <tr class="prop nowrap">
                    <td valign="top" class="name">
                        <label for="postedFrom"><g:msg code="documentSearch.postedFrom" default="Documents Created From"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'postedFrom', 'errors')}">
                        <input type="text" size="20" id="postedFrom" name="postedFrom" value="${format(value: documentSearchInstance.postedFrom, scale: 1)}"/>&nbsp;<g:help code="documentSearch.postedFrom"/>
                    </td>

                    <td valign="top" class="name">
                        <label for="postedTo"><g:msg code="documentSearch.postedTo" default="Documents Created To"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: documentSearchInstance, field: 'postedTo', 'errors')}">
                        <input type="text" size="20" id="postedTo" name="postedTo" value="${format(value: documentSearchInstance.postedTo, scale: 1)}"/>&nbsp;<g:help code="documentSearch.postedTo"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="search" type="submit" value="${msg(code: 'generic.search', 'default': 'Search')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
