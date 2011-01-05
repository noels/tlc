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
<%@ page import="com.whollygrails.tlc.sys.SystemGeo" %>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="code"><g:msg code="systemRegion.code" default="Code"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemRegionInstance, field: 'code', 'errors')}">
                <input initialField="true" type="text" size="5" id="code" name="code" value="${display(bean: systemRegionInstance, field: 'code')}"/>&nbsp;<g:help code="systemRegion.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="systemRegion.name" default="Name"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemRegionInstance, field: 'name', 'errors')}">
                <input type="text" maxlength="30" size="30" id="name" name="name" value="${systemRegionInstance.id ? msg(code: 'region.name.' + systemRegionInstance.code, default: systemRegionInstance.name) : systemRegionInstance.name}"/>&nbsp;<g:help code="systemRegion.name"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="geo.id"><g:msg code="systemRegion.geo" default="Geo"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemRegionInstance, field: 'geo', 'errors')}">
                <g:domainSelect name="geo.id" options="${SystemGeo.list()}" selected="${systemRegionInstance?.geo}" prefix="geo.name" code="code" default="name"/>&nbsp;<g:help code="systemRegion.geo"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
