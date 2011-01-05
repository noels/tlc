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
    <title><g:msg code="company.show" default="Show Company"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="company.list" default="Company List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="company.new" default="New Company"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="company.show" default="Show Company"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                <td valign="top" class="value">${display(bean: companyInstance, field: 'id')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="company.name" default="Name"/>:</td>

                <td valign="top" class="value">${display(bean: companyInstance, field: 'name')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="company.country" default="Country"/>:</td>

                <td valign="top" class="value">${msg(code: 'country.name.' + companyInstance.country.code, default: companyInstance.country.name)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="company.language" default="Language"/>:</td>

                <td valign="top" class="value">${msg(code: 'language.name.' + companyInstance.language.code, default: companyInstance.language.name)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="company.currency" default="Currency"/>:</td>

                <td valign="top" class="value">${msg(code: 'currency.name.' + companyInstance.displayCurrency?.code, default: companyInstance.displayCurrency?.name)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="company.displayTaxCode" default="Tax Code"/>:</td>

                <td valign="top" class="value">${msg(code: 'taxCode.name.' + companyInstance.displayTaxCode.code, default: companyInstance.displayTaxCode.name)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                <td valign="top" class="value">${display(bean: companyInstance, field: 'securityCode')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="company.systemOnly" default="System Only"/>:</td>

                <td valign="top" class="value">${display(bean: companyInstance, field: 'systemOnly')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                <td valign="top" class="value">${display(bean: companyInstance, field: 'dateCreated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                <td valign="top" class="value">${display(bean: companyInstance, field: 'lastUpdated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                <td valign="top" class="value">${display(bean: companyInstance, field: 'version')}</td>

            </tr>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${companyInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
