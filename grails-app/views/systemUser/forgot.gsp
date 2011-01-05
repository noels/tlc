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
    <title><g:msg code="systemUser.forgot" default="Forgotten Password"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="login" action="logout"><g:msg code="systemUser.login.button" default="Login"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemUser.forgot" default="Forgotten Password"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemUserInstance}">
        <div class="errors">
            <g:listErrors bean="${systemUserInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="notify" method="post">
        <input type="hidden" name="loginId" value="${systemUserInstance?.loginId}"/>
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name" colspan="2">
                        <p><g:msg code="systemUser.forgot.security" default="You need to correctly answer the security question below and then press the New Password button. You will then be emailed with a new password which you will be obliged to change the next time you log in."/></p><p>&nbsp;</p>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="systemUser.loginId" default="Login Id"/>:</td>

                    <td valign="top" class="value">${display(bean: systemUserInstance, field: 'loginId')}</td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="systemUser.securityQuestion" default="Security Question"/>:</td>

                    <td valign="top" class="value">${display(bean: systemUserInstance, field: 'securityQuestion')}</td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="answer"><g:msg code="systemUser.securityAnswer" default="Security Answer"/>:</label>
                    </td>
                    <td valign="top" class="value">
                        <input initialField="true" type="text" maxlength="30" id="answer" name="answer" value="${answer?.encodeAsHTML()}"/>&nbsp;<g:help code="systemUser.securityAnswer"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'systemUser.forgot.button', 'default': 'New Password')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
