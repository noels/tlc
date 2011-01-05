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
                <label for="path"><g:msg code="systemMenu.path" default="Path"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemMenuInstance, field: 'path', 'errors')}">
                <input initialField="true" type="text" maxlength="100" size="40" id="path" name="path" value="${display(bean: systemMenuInstance, field: 'path')}"/>&nbsp;<g:help code="systemMenu.path"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="title"><g:msg code="systemMenu.title" default="Title"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemMenuInstance, field: 'title', 'errors')}">
                <input type="text" maxlength="100" size="30" id="title" name="title" value="${systemMenuInstance.id ? msg(code: 'menu.option.' + systemMenuInstance.path, default: systemMenuInstance.title) : systemMenuInstance.title}"/>&nbsp;<g:help code="systemMenu.title"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="sequencer"><g:msg code="systemMenu.sequencer" default="Sequencer"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemMenuInstance, field: 'sequencer', 'errors')}">
                <input type="text" size="5" id="sequencer" name="sequencer" value="${display(bean: systemMenuInstance, field: 'sequencer')}"/>&nbsp;<g:help code="systemMenu.sequencer"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="type"><g:msg code="systemMenu.type" default="Type"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemMenuInstance, field: 'type', 'errors')}">
                <g:select id="type" name="type" from="${systemMenuInstance.constraints.type.inList}" value="${systemMenuInstance.type}" valueMessagePrefix="systemMenu.type"/>&nbsp;<g:help code="systemMenu.type"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="command"><g:msg code="systemMenu.command" default="Command"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemMenuInstance, field: 'command', 'errors')}">
                <input type="text" maxlength="100" size="30" id="command" name="command" value="${display(bean: systemMenuInstance, field: 'command')}"/>&nbsp;<g:help code="systemMenu.command"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="parameters"><g:msg code="systemMenu.parameters" default="Parameters"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemMenuInstance, field: 'parameters', 'errors')}">
                <input type="text" maxlength="200" size="30" id="parameters" name="parameters"
                        value="${(systemMenuInstance.type == 'submenu' && systemMenuInstance.parameters) ? msg(code: 'menu.submenu.' + systemMenuInstance.path, default: systemMenuInstance.parameters) : display(bean: systemMenuInstance, field: 'parameters')}"/>&nbsp;<g:help code="systemMenu.parameters"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="activity"><g:msg code="systemMenu.activity" default="Activity"/>:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: systemMenuInstance, field: 'activity', 'errors')}">
                <g:select optionKey="id" from="${SystemActivity.list([sort: 'code'])}" name="activity.id" value="${systemMenuInstance?.activity?.id}"/>&nbsp;<g:help code="systemMenu.activity"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
