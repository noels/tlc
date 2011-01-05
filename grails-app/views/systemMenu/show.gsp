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
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemMenu.show" default="Show Menu Option"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="systemMenu.list" default="Menu Option List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemMenu.new" default="New Menu Option"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemMenu.show" default="Show Menu Option"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'id')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.path" default="Path"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'path')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.title" default="Title"/>:</td>

                <td valign="top" class="value"><g:msg code="menu.option.${systemMenuInstance.path}" default="${systemMenuInstance.title}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.sequencer" default="Sequencer"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'sequencer')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.type" default="Type"/>:</td>

                <td valign="top" class="value"><g:msg code="systemMenu.type.${systemMenuInstance.type}" default="${systemMenuInstance.type}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.command" default="Command"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'command')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.parameters" default="Parameters"/>:</td>

                <g:if test="${(systemMenuInstance.type == 'submenu' && systemMenuInstance.parameters)}">
                    <td valign="top" class="value"><g:msg code="menu.submenu.${systemMenuInstance.path}" default="${systemMenuInstance.parameters}"/></td>
                </g:if>
                <g:else>
                    <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'parameters')}</td>
                </g:else>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.activity" default="Activity"/>:</td>

                <td valign="top" class="value">${systemMenuInstance.activity.code.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.parent" default="Parent"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'parent')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemMenu.treeSequence" default="Tree Sequence"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'treeSequence')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'securityCode')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'dateCreated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'lastUpdated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                <td valign="top" class="value">${display(bean: systemMenuInstance, field: 'version')}</td>

            </tr>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${systemMenuInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'systemMenu.delete.confirm', 'default':'If this is a sub-menu, the children will be deleted also. Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
