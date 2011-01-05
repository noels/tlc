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
<%@ page import="com.whollygrails.tlc.corp.Task; com.whollygrails.tlc.sys.SystemUser" %>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <g:msg code="task.Company" default="Company"/>:
            </td>
            <td valign="top" class="value">
                ${queuedTask?.task?.company?.name?.encodeAsHTML()}
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="user"><g:msg code="queuedTask.user" default="User"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: queuedTaskInstance, field: 'user', 'errors')}">
                <g:select initialField="true" optionKey="id" optionValue="name" from="${companyUserList}" name="user.id" value="${queuedTaskInstance?.user?.id}"/>&nbsp;<g:help code="queuedTask.user"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="preferredStart"><g:msg code="queuedTask.preferredStart" default="Preferred Start"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: queuedTaskInstance, field: 'preferredStart', 'errors')}">
                <input type="text" size="20" id="preferredStart" name="preferredStart" value="${display(bean: queuedTaskInstance, field: 'preferredStart', scale: 2)}"/>&nbsp;<g:help code="queuedTask.preferredStart"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
