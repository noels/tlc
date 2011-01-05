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
<%@ page import="com.whollygrails.tlc.sys.SystemCountry; com.whollygrails.tlc.sys.SystemAddressFormat" %>
<SCRIPT language="JavaScript">
    function submitform(mod) {
        document.getElementById('modified').value = mod;
        document.jsform.submit();
    }
</SCRIPT>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td></td>
            <td valign="top" class="name"><g:msg code="systemAddressFormat.required" default="Required fields are marked with *"/></td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="country.id"><g:msg code="customerAddress.country" default="Country"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: customerAddressInstance, field: 'country', 'errors')}">
                <g:domainSelect initialField="true" onChange="submitform('country')" name="country.id" options="${SystemCountry.list()}" selected="${customerAddressInstance?.country}" prefix="country.name" code="code" default="name"/>&nbsp;<g:help code="customerAddress.country"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="format.id"><g:msg code="customerAddress.format" default="Format"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: customerAddressInstance, field: 'format', 'errors')}">
                <g:domainSelect onChange="submitform('format')" name="format.id" options="${SystemAddressFormat.list()}" selected="${customerAddressInstance?.format}" prefix="systemAddressFormat.name" code="code" default="name"/>&nbsp;<g:help code="customerAddress.format"/>
            </td>
        </tr>

        <g:each in="${customerAddressLines}" status="i" var="customerAddressLine">
            <tr class="prop">
                <td valign="top" class="name">
                    <label for="${customerAddressLine.property}">${customerAddressLine.label?.encodeAsHTML()}:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: customerAddressInstance, field: customerAddressLine.property, 'errors')}">
                    <input type="text" maxlength="50" size="${customerAddressLine.width}" id="${customerAddressLine.property}" name="${customerAddressLine.property}" value="${customerAddressLine.value?.encodeAsHTML()}"/>${customerAddressLine.required ? '*' : ''}
                </td>
            </tr>
        </g:each>

        <g:if test="${transferList}">
            <tr class="prop">
                <td valign="top" class="name">
                    <label for="transfers"><g:msg code="customerAddress.transferUsages" default="Transfer Usages"/>:</label>
                </td>
                <td valign="top" class="value">
                    <g:domainSelect name="transfers" size="5" options="${transferList}" selected="${customerAddressInstance.usageTransfers}" prefix="customerAddressType.name" code="code" default="name"/>&nbsp;<g:help code="customerAddress.transferUsages"/>
                </td>
            </tr>
        </g:if>

        </tbody>
    </table>
</div>
