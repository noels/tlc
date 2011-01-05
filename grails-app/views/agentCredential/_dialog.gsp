<%--
 ~   Copyright 2010 Wholly Grails.
 ~
 ~   This file is part of the Three Ledger Core (TLC) software
 ~   from Wholly Grails.
 ~
 ~   TLC is free software: you can redistribute it and/or modify
 ~   it under the terms of the GNU General Public License as published by
 ~   the Free Software Foundation, either version 3 of the License, or
 ~   (at your option) any later version.
 ~
 ~   TLC is distributed in the hope that it will be useful,
 ~   but WITHOUT ANY WARRANTY; without even the implied warranty of
 ~   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ~   GNU General Public License for more details.
 ~
 ~   You should have received a copy of the GNU General Public License
 ~   along with TLC.  If not, see <http://www.gnu.org/licenses/>.
 --%>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name"><g:msg code="agentCredential.code" default="Code" />:</td>
            <td valign="top" class="value">${display(bean:agentCredentialInstance, field:'code')}</td>
            <input type="hidden" name = "code" value="${display(bean:agentCredentialInstance, field:'code')}">
        </tr>

        <tr class="prop">
            <td valign="top" class="name"><g:msg code="agentCredential.secret" default="Secret" />:</td>
            <td valign="top" class="value">${display(bean:agentCredentialInstance, field:'secret')}</td>
            <input type="hidden" name = "secret" value="${display(bean:agentCredentialInstance, field:'secret')}">
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="active"><g:msg code="agentCredential.active" default="Active" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:agentCredentialInstance,field:'active','errors')}">
                <g:checkBox initialField="true" name="active" value="${agentCredentialInstance?.active}" ></g:checkBox>&nbsp;<g:help code="agentCredential.active"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
