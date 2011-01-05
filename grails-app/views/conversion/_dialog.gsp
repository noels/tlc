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
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="code"><g:msg code="conversion.code" default="Code" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:conversionInstance,field:'code','errors')}">
                <input initialField="true" type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean:conversionInstance,field:'code')}"/>&nbsp;<g:help code="conversion.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="conversion.name" default="Name" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:conversionInstance,field:'name','errors')}">
                <input type="text" maxlength="50" size="30" id="name" name="name" value="${conversionInstance.id ? msg(code: 'conversion.name.' + conversionInstance.code, default: conversionInstance.name) : conversionInstance.name}"/>&nbsp;<g:help code="conversion.name"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="source.id"><g:msg code="conversion.source" default="Source" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:conversionInstance,field:'source','errors')}">
                <g:domainSelect name="source.id" options="${unitList}" selected="${conversionInstance?.source}" prefix="unit.name" code="code" default="name"/>&nbsp;<g:help code="conversion.source"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="target.id"><g:msg code="conversion.target" default="Target" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:conversionInstance,field:'target','errors')}">
                <g:domainSelect name="target.id" options="${unitList}" selected="${conversionInstance?.target}" prefix="unit.name" code="code" default="name"/>&nbsp;<g:help code="conversion.target"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="preAddition"><g:msg code="conversion.preAddition" default="Pre Addition" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:conversionInstance,field:'preAddition','errors')}">
                <input type="text" id="preAddition" name="preAddition" size="20" value="${display(bean:conversionInstance,field:'preAddition')}" />&nbsp;<g:help code="conversion.preAddition"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="multiplier"><g:msg code="conversion.multiplier" default="Multiplier" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:conversionInstance,field:'multiplier','errors')}">
                <input type="text" id="multiplier" name="multiplier" size="20" value="${display(bean:conversionInstance,field:'multiplier')}" />&nbsp;<g:help code="conversion.multiplier"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="postAddition"><g:msg code="conversion.postAddition" default="Post Addition" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:conversionInstance,field:'postAddition','errors')}">
                <input type="text" id="postAddition" name="postAddition" size="20" value="${display(bean:conversionInstance,field:'postAddition')}" />&nbsp;<g:help code="conversion.postAddition"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
