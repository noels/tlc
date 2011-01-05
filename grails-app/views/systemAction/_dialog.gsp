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
<%@ page import="com.whollygrails.tlc.sys.SystemActivity" %>
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="appController"><g:msg code="systemAction.appController" default="Controller"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemActionInstance, field: 'appController', 'errors')}">
                <input initialField="true" type="text" maxlength="50" size="30" id="appController" name="appController" value="${display(bean: systemActionInstance, field: 'appController')}"/>&nbsp;<g:help code="systemAction.appController"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="appAction"><g:msg code="systemAction.appAction" default="Action"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemActionInstance, field: 'appAction', 'errors')}">
                <input type="text" maxlength="50" size="30" id="appAction" name="appAction" value="${display(bean: systemActionInstance, field: 'appAction')}"/>&nbsp;<g:help code="systemAction.appAction"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="activity.id"><g:msg code="systemAction.activity" default="Activity"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemActionInstance, field: 'activity', 'errors')}">
                <g:select optionKey="id" from="${SystemActivity.list([sort: 'code'])}" name="activity.id" value="${systemActionInstance?.activity?.id}"/>&nbsp;<g:help code="systemAction.activity"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
