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
                <label for="code"><g:msg code="systemAccountType.code" default="Code" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance,field:'code','errors')}">
                <input initialField="true" type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean:systemAccountTypeInstance,field:'code')}"/>&nbsp;<g:help code="systemAccountType.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="systemAccountType.name" default="Name" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance,field:'name','errors')}">
                <input type="text" maxlength="30" size="30" id="name" name="name" value="${systemAccountTypeInstance.id ? msg(code: 'systemAccountType.name.' + systemAccountTypeInstance.code, default: systemAccountTypeInstance.name) : systemAccountTypeInstance.name}"/>&nbsp;<g:help code="systemAccountType.name"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="sectionType"><g:msg code="systemAccountType.sectionType" default="Section Type" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance,field:'sectionType','errors')}">
                <g:select id="sectionType" name="sectionType" from="${systemAccountTypeInstance.constraints.sectionType.inList}" value="${systemAccountTypeInstance.sectionType}" valueMessagePrefix="systemAccountType.sectionType" />&nbsp;<g:help code="systemAccountType.sectionType"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="singleton"><g:msg code="systemAccountType.singleton" default="Singleton"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance, field:'singleton', 'errors')}">
                <g:checkBox name="singleton" value="${systemAccountTypeInstance?.singleton}"></g:checkBox>&nbsp;<g:help code="systemAccountType.singleton"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="changeable"><g:msg code="systemAccountType.changeable" default="Changeable"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance, field:'changeable', 'errors')}">
                <g:checkBox name="changeable" value="${systemAccountTypeInstance?.changeable}"></g:checkBox>&nbsp;<g:help code="systemAccountType.changeable"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="allowInvoices"><g:msg code="systemAccountType.allowInvoices" default="Allow Invoices"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance, field:'allowInvoices', 'errors')}">
                <g:checkBox name="allowInvoices" value="${systemAccountTypeInstance?.allowInvoices}"></g:checkBox>&nbsp;<g:help code="systemAccountType.allowInvoices"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="allowCash"><g:msg code="systemAccountType.allowCash" default="Allow Cash"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance, field:'allowCash', 'errors')}">
                <g:checkBox name="allowCash" value="${systemAccountTypeInstance?.allowCash}"></g:checkBox>&nbsp;<g:help code="systemAccountType.allowCash"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="allowProvisions"><g:msg code="systemAccountType.allowProvisions" default="Allow Provisions"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance, field:'allowProvisions', 'errors')}">
                <g:checkBox name="allowProvisions" value="${systemAccountTypeInstance?.allowProvisions}"></g:checkBox>&nbsp;<g:help code="systemAccountType.allowProvisions"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="allowJournals"><g:msg code="systemAccountType.allowJournals" default="Allow Journals"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:systemAccountTypeInstance, field:'allowJournals', 'errors')}">
                <g:checkBox name="allowJournals" value="${systemAccountTypeInstance?.allowJournals}"></g:checkBox>&nbsp;<g:help code="systemAccountType.allowJournals"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
