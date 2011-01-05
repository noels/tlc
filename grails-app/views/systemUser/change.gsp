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
    <title><g:msg code="systemUser.change" default="Change Password"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><g:link class="login" action="logout"><g:msg code="systemUser.login.button" default="Login"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemUser.change" default="Change Password"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemUserInstance}">
        <div class="errors">
            <g:listErrors bean="${systemUserInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="proceed" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name" colspan="2">
                        <p><g:msg code="systemUser.change.notice" default="Your password has expired. You need to set a new password now."/></p><p>&nbsp;</p>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="systemUser.loginId" default="Login Id"/>:</td>

                    <td valign="top" class="value">${display(bean: systemUserInstance, field: 'loginId')}</td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="currentPassword"><g:msg code="systemUser.currentPassword.again" default="Re-Enter Current Password"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'currentPassword', 'errors')}">
                        <input initialField="true" type="password" maxlength="30" size="20" id="currentPassword" name="currentPassword" value="${display(bean: systemUserInstance, field: 'currentPassword')}"/>&nbsp;<g:help code="systemUser.currentPassword"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="password"><g:msg code="systemUser.newPassword" default="New Password"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'password', 'errors')}">
                        <input type="password" maxlength="30" size="20" id="password" name="password" value="${display(bean: systemUserInstance, field: 'password')}"/>&nbsp;<g:help code="systemUser.newPassword"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="passwordConfirmation"><g:msg code="systemUser.newPasswordConfirmation" default="New Password Confirmation"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'passwordConfirmation', 'errors')}">
                        <input type="password" maxlength="30" size="20" id="passwordConfirmation" name="passwordConfirmation" value="${display(bean: systemUserInstance, field: 'passwordConfirmation')}"/>&nbsp;<g:help code="systemUser.newPasswordConfirmation"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'systemUser.login.button', 'default': 'Login')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
