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
<%@ page import="com.whollygrails.tlc.sys.SystemTrace" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="system"/>
    <title><g:msg code="systemTrace.show" default="Show Trace" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="systemTrace.list" default="Trace List" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="systemTrace.show" default="Show Trace" />
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.id" default="Id" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'id')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemTrace.domainSecurityCode" default="Company" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'companyDecode')}</td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemTrace.databaseAction" default="Database Action" />:</td>

                <td valign="top" class="value"><g:msg code="systemTrace.databaseAction.${systemTraceInstance.databaseAction}" default="${systemTraceInstance.databaseAction}"/></td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemTrace.domainName" default="Domain Name" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'domainName')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemTrace.domainData" default="Domain Data" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'domainData')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemTrace.domainId" default="Domain Id" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'domainId')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemTrace.domainVersion" default="Domain Version" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'domainVersion')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="systemTrace.userId" default="User" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'userDecode')}</td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'securityCode')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'dateCreated')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'lastUpdated')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="generic.version" default="Version" />:</td>

                <td valign="top" class="value">${display(bean:systemTraceInstance, field:'version')}</td>

            </tr>

            </tbody>
        </table>
    </div>
</div>
</body>
</html>
