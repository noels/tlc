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
    <title><g:msg code="systemUser.login" default="Login Existing User"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
</div>
<div class="body">
    <g:pageTitle code="systemUser.login" default="Login Existing User"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemUserInstance}">
        <div class="errors">
            <g:listErrors bean="${systemUserInstance}"/>
        </div>
    </g:hasErrors>
    <g:form action="connect" method="post">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name" colspan="2">
                        <p><g:msg code="systemUser.login.reminder" default="If you have forgotten your password, enter your Login Id as usual (leaving the Password field blank) then press the Login button"/></p><p>&nbsp;</p>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="loginId"><g:msg code="systemUser.loginId" default="Login Id"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'loginId', 'errors')}">
                        <input initialField="true" type="text" maxlength="20" size="20" id="loginId" name="loginId" value="${display(bean: systemUserInstance, field: 'loginId')}"/>&nbsp;<g:help code="systemUser.loginId"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="password"><g:msg code="systemUser.password" default="Password"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'password', 'errors')}">
                        <input type="password" maxlength="30" size="20" id="password" name="password" value="${display(bean: systemUserInstance, field: 'password')}"/>&nbsp;<g:help code="systemUser.password"/>
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
