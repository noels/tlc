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
                <label for="code"><g:msg code="measure.code" default="Code" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:measureInstance,field:'code','errors')}">
                <input initialField="true" type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean:measureInstance,field:'code')}"/>&nbsp;<g:help code="measure.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="measure.name" default="Name" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:measureInstance,field:'name','errors')}">
                <input type="text" maxlength="20" size="20" id="name" name="name" value="${measureInstance.id ? msg(code: 'measure.name.' + measureInstance.code, default: measureInstance.name) : measureInstance.name}"/>&nbsp;<g:help code="measure.name"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
