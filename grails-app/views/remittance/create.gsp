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
    <title><g:msg code="remittance.new" default="Create Remittance Advice"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="remittance.list" default="Remittance Advices List"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="remittance.new" default="Create Remittance Advice"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${supplierInstance}">
        <div class="errors">
            <g:listErrors bean="${supplierInstance}"/>
        </div>
    </g:hasErrors>
    <div class="center" style="margin-top:15px;margin-bottom:20px;">
        <g:msg code="remittance.adhoc" default="Use this facility to create a remittance advice, overwriting any existing unauthorized advice for the supplier."/>
    </div>
    <g:form action="save" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="code"><g:msg code="remittance.code" default="Code"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'code', 'errors')}">
                        <input initialField="true" type="text" maxlength="20" size="20" id="code" name="code" value="${display(bean: supplierInstance, field: 'code')}"/>&nbsp;<g:help code="remittance.code"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'create', 'default': 'Create')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
