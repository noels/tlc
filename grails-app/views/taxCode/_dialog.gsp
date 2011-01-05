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
<%@ page import="com.whollygrails.tlc.corp.Company; com.whollygrails.tlc.corp.TaxAuthority" %>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="code"><g:msg code="taxCode.code" default="Code"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taxCodeInstance, field: 'code', 'errors')}">
                <input initialField="true" type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean: taxCodeInstance, field: 'code')}"/>&nbsp;<g:help code="taxCode.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="taxCode.name" default="Name"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taxCodeInstance, field: 'name', 'errors')}">
                <input type="text" maxlength="50" size="30" id="name" name="name" value="${taxCodeInstance.id ? msg(code: 'taxCode.name.' + taxCodeInstance.code, default: taxCodeInstance.name) : taxCodeInstance.name}"/>&nbsp;<g:help code="taxCode.name"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="authority.id"><g:msg code="taxAuthority.name" default="Tax Authority"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taxCodeInstance, field: 'authority', 'errors')}">
                <g:select optionKey="id" from="${TaxAuthority.findAllByCompany(taxCodeInstance.company, [sort: 'name'])}" name="authority.id" value="${taxCodeInstance?.authority?.id}"/>&nbsp;<g:help code="taxCode.authority"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
