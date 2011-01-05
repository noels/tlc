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
<%@ page import="com.whollygrails.tlc.sys.SystemRegion; com.whollygrails.tlc.sys.SystemLanguage; com.whollygrails.tlc.sys.SystemCurrency; com.whollygrails.tlc.sys.SystemAddressFormat" %>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="code"><g:msg code="systemCountry.code" default="Code"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemCountryInstance, field: 'code', 'errors')}">
                <input initialField="true" type="text" size="5" id="code" name="code" value="${display(bean: systemCountryInstance, field: 'code')}"/>&nbsp;<g:help code="systemCountry.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="systemCountry.name" default="Name"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemCountryInstance, field: 'name', 'errors')}">
                <input type="text" maxlength="50" size="30" id="name" name="name" value="${systemCountryInstance.id ? msg(code: 'country.name.' + systemCountryInstance.code, default: systemCountryInstance.name) : systemCountryInstance.name}"/>&nbsp;<g:help code="systemCountry.name"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="flag"><g:msg code="systemCountry.flag" default="Flag"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemCountryInstance, field: 'flag', 'errors')}">
                <input type="text" size="5" id="flag" name="flag" value="${display(bean: systemCountryInstance, field: 'flag')}"/>&nbsp;<g:help code="systemCountry.flag"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="currency.id"><g:msg code="systemCountry.currency" default="Currency"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemCountryInstance, field: 'currency', 'errors')}">
                <g:domainSelect name="currency.id" options="${SystemCurrency.list()}" selected="${systemCountryInstance?.currency}" prefix="currency.name" code="code" default="name"/>&nbsp;<g:help code="systemCountry.currency"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="language.id"><g:msg code="systemCountry.language" default="Language"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemCountryInstance, field: 'language', 'errors')}">
                <g:domainSelect name="language.id" options="${SystemLanguage.list()}" selected="${systemCountryInstance?.language}" prefix="language.name" code="code" default="name"/>&nbsp;<g:help code="systemCountry.language"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="region.id"><g:msg code="systemCountry.region" default="Region"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemCountryInstance, field: 'region', 'errors')}">
                <g:domainSelect name="region.id" options="${SystemRegion.list()}" selected="${systemCountryInstance?.region}" prefix="region.name" code="code" default="name"/>&nbsp;<g:help code="systemCountry.region"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="addressFormat.id"><g:msg code="systemCountry.addressFormat" default="Address Format"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemCountryInstance, field: 'addressFormat', 'errors')}">
                <g:domainSelect name="addressFormat.id" options="${SystemAddressFormat.list()}" selected="${systemCountryInstance?.addressFormat}" prefix="systemAddressFormat.name" code="code" default="name"/>&nbsp;<g:help code="systemCountry.addressFormat"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
