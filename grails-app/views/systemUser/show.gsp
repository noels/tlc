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
    <title><g:msg code="systemUser.show" default="Show User"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="systemUser.list" default="User List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="systemUser.new" default="New User"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemUser.show" default="Show User"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemUserInstance}">
        <div class="errors">
            <g:listErrors bean="${systemUserInstance}"/>
        </div>
    </g:hasErrors>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'id')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.loginId" default="Login Id"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'loginId')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.name" default="Name"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'name')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.email" default="Email"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'email')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.salt" default="Salt"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'salt')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.encryptedPassword" default="Encrypted Password"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'encryptedPassword')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.securityQuestion" default="Security Question"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'securityQuestion')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.securityAnswer" default="Security Answer"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'securityAnswer')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.country" default="Country"/>:</td>

                <td valign="top" class="value"><g:msg code="country.name.${systemUserInstance.country.code}" default="${systemUserInstance.country.name}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.language" default="Language"/>:</td>

                <td valign="top" class="value"><g:msg code="language.name.${systemUserInstance.language.code}" default="${systemUserInstance.language.name}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.lastLogin" default="Last Login"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'lastLogin', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.disabledUntil" default="Disabled Until"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'disabledUntil', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.nextPasswordChange" default="Next Password Change"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'nextPasswordChange', scale: 2)}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.oldPassword1" default="Old Password 1"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'oldPassword1')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.oldPassword2" default="Old Password 2"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'oldPassword2')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.oldPassword3" default="Old Password 3"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'oldPassword3')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.administrator" default="Administrator"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'administrator')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemUser.disableHelp" default="Disable Help"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'disableHelp')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'securityCode')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'dateCreated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'lastUpdated')}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                <td valign="top" class="value">${display(bean: systemUserInstance, field: 'version')}</td>

            </tr>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${systemUserInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
