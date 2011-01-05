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
<%@ page import="com.whollygrails.tlc.sys.SystemLanguage; com.whollygrails.tlc.sys.SystemCountry" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="systemUser.registration" default="New User Registration"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
</div>
<div class="body">
    <g:pageTitle code="systemUser.registration" default="New User Registration"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <g:hasErrors bean="${systemUserInstance}">
        <div class="errors">
            <g:listErrors bean="${systemUserInstance}"/>
        </div>
    </g:hasErrors>
    <p class="center" style="margin-top:10px;margin-bottom:15px;"><g:msg code="systemUser.privacy" default="Privacy Statement: The data you enter here is used solely for the purpose of operating the system."/></p>
    <g:form action="registration" method="post">
        <div class="dialog">
            <table>
                <tbody>

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
                        <label for="name"><g:msg code="systemUser.name" default="Name"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'name', 'errors')}">
                        <input type="text" maxlength="50" size="30" id="name" name="name" value="${display(bean: systemUserInstance, field: 'name')}"/>&nbsp;<g:help code="systemUser.name"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="email"><g:msg code="systemUser.email" default="Email"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'email', 'errors')}">
                        <input type="text" maxlength="100" size="30" id="email" name="email" value="${display(bean: systemUserInstance, field: 'email')}"/>&nbsp;<g:help code="systemUser.email"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="password"><g:msg code="systemUser.password" default="Password"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'password', 'errors')}">
                        <input type="password" size="20" name="password" id="password" value="${display(bean: systemUserInstance, field: 'password')}"/>&nbsp;<g:help code="systemUser.password"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="passwordConfirmation"><g:msg code="systemUser.passwordConfirmation" default="Password Confirmation"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'passwordConfirmation', 'errors')}">
                        <input type="password" size="20" name="passwordConfirmation" id="passwordConfirmation" value="${display(bean: systemUserInstance, field: 'passwordConfirmation')}"/>&nbsp;<g:help code="systemUser.passwordConfirmation"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="securityQuestion"><g:msg code="systemUser.securityQuestion" default="Security Question"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'securityQuestion', 'errors')}">
                        <input type="text" maxlength="100" size="30" id="securityQuestion" name="securityQuestion" value="${display(bean: systemUserInstance, field: 'securityQuestion')}"/>&nbsp;<g:help code="systemUser.securityQuestion"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="securityAnswer"><g:msg code="systemUser.securityAnswer" default="Security Answer"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'securityAnswer', 'errors')}">
                        <input type="text" maxlength="30" size="20" id="securityAnswer" name="securityAnswer" value="${display(bean: systemUserInstance, field: 'securityAnswer')}"/>&nbsp;<g:help code="systemUser.securityAnswer"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="country"><g:msg code="systemUser.country" default="Country"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'country', 'errors')}">
                        <g:domainSelect name="country.id" options="${SystemCountry.list()}" selected="${systemUserInstance?.country}" prefix="country.name" code="code" default="name"/>&nbsp;<g:help code="systemUser.country"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="language"><g:msg code="systemUser.language" default="Language"/>:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'language', 'errors')}">
                        <g:domainSelect name="language.id" options="${SystemLanguage.list()}" selected="${systemUserInstance?.language}" prefix="language.name" code="code" default="name"/>&nbsp;<g:help code="systemUser.language"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="accessCode"><g:msg code="systemUser.accessCode" default="Access Code"/>:<br/>
                            <g:msg code="systemUser.accessCode.prompt" default="(Enter the code shown in the image)"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: systemUserInstance, field: 'accessCode', 'errors')}">
                        <input type="text" id="accessCode" name="accessCode" value="${display(bean: systemUserInstance, field: 'accessCode')}"/>&nbsp;<g:help code="systemUser.accessCode"/><br/>
                        <img src="${createLink(action: 'captcha')}"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>
        <div class="buttons">
            <span class="button"><input class="save" type="submit" value="${msg(code: 'systemUser.register', 'default': 'Register')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
