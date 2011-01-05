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
<%@ page import="com.whollygrails.tlc.corp.Company; com.whollygrails.tlc.sys.SystemUser; com.whollygrails.tlc.sys.SystemActivity" %>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="code"><g:msg code="task.code" default="Code"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'code', 'errors')}">
                <input initialField="true" type="text" maxlength="10" size="10" id="code" name="code" value="${display(bean: taskInstance, field: 'code')}"/>&nbsp;<g:help code="task.code"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="name"><g:msg code="task.name" default="Name"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'name', 'errors')}">
                <input type="text" maxlength="50" size="30" id="name" name="name" value="${taskInstance.id ? msg(code: 'task.name.' + taskInstance.code, default: taskInstance.name) : taskInstance.name}"/>&nbsp;<g:help code="task.name"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="executable"><g:msg code="task.executable" default="Executable"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'executable', 'errors')}">
                <input type="text" maxlength="50" size="30" id="executable" name="executable" value="${display(bean: taskInstance, field: 'executable')}"/>&nbsp;<g:help code="task.executable"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="allowOnDemand"><g:msg code="task.allowOnDemand" default="Allow On Demand"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'allowOnDemand', 'errors')}">
                <g:checkBox name="allowOnDemand" value="${taskInstance?.allowOnDemand}"></g:checkBox>&nbsp;<g:help code="task.allowOnDemand"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="activity.id"><g:msg code="task.activity" default="Activity"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'activity', 'errors')}">
                <g:select optionKey="id" optionValue="code" from="${SystemActivity.findAllBySystemOnlyOrCode(false, 'sysadmin', [sort: 'code'])}" name="activity.id" value="${taskInstance?.activity?.id}" noSelection="${['': msg(code: 'generic.no.selection', default: '-- none --')]}"/>&nbsp;<g:help code="task.activity"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="schedule"><g:msg code="task.schedule" default="Schedule"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'schedule', 'errors')}">
                <input type="text" maxlength="200" size="30" id="schedule" name="schedule" value="${display(bean: taskInstance, field: 'schedule')}"/>&nbsp;<g:help code="task.schedule"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="nextScheduledRun"><g:msg code="task.nextScheduledRun" default="Next Scheduled Run"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'nextScheduledRun', 'errors')}">
                <input type="text" size="20" id="nextScheduledRun" name="nextScheduledRun" value="${display(bean: taskInstance, field: 'nextScheduledRun', scale: 2)}"/>&nbsp;<g:help code="task.nextScheduledRun"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="user.id"><g:msg code="task.user" default="User"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'user', 'errors')}">
                <g:select optionKey="id" optionValue="name" from="${companyUserList}" name="user.id" value="${taskInstance?.user?.id}" noSelection="${['': msg(code: 'generic.no.selection', default: '-- none --')]}"/>&nbsp;<g:help code="task.user"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="retentionDays"><g:msg code="task.retentionDays" default="Retention Days"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'retentionDays', 'errors')}">
                <input type="text" size="5" id="retentionDays" name="retentionDays" value="${display(bean: taskInstance, field: 'retentionDays')}"/>&nbsp;<g:help code="task.retentionDays"/>
            </td>
        </tr>

        <g:permit activity="sysadmin">
            <tr class="prop">
                <td valign="top" class="name">
                    <label for="systemOnly"><g:msg code="task.systemOnly" default="System Only"/>:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: taskInstance, field: 'systemOnly', 'errors')}">
                    <g:checkBox name="systemOnly" value="${taskInstance?.systemOnly}"></g:checkBox>&nbsp;<g:help code="task.systemOnly"/>
                </td>
            </tr>
        </g:permit>

        </tbody>
    </table>
</div>
