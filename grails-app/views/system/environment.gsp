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
    <title><g:msg code="system.environment" default="Environment"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="system.environment" default="Environment"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.osName" default="Operating System Name"/>:</td>

                <td valign="top" class="value">${environmentInstance.osName.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.osVersion" default="Operating System Version"/>:</td>

                <td valign="top" class="value">${environmentInstance.osVersion.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.osArchitecture" default="Operating System Architecture"/>:</td>

                <td valign="top" class="value">${environmentInstance.osArchitecture.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.javaName" default="Java Name"/>:</td>

                <td valign="top" class="value">${environmentInstance.javaName.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.javaVendor" default="Java Vendor"/>:</td>

                <td valign="top" class="value">${environmentInstance.javaVendor.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.javaVersion" default="Java Version"/>:</td>

                <td valign="top" class="value">${environmentInstance.javaVersion.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.groovyVersion" default="Groovy Version"/>:</td>

                <td valign="top" class="value">${environmentInstance.groovyVersion.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.grailsVersion" default="Grails Version"/>:</td>

                <td valign="top" class="value">${environmentInstance.grailsVersion.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.grailsEnvironment" default="Grails Environment"/>:</td>

                <td valign="top" class="value">${environmentInstance.grailsEnvironment.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.applicationName" default="Application Name"/>:</td>

                <td valign="top" class="value">${environmentInstance.applicationName.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.applicationVersion" default="Application Version"/>:</td>

                <td valign="top" class="value">${environmentInstance.applicationVersion.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.memoryUsed" default="Memory Used"/>:</td>

                <td valign="top" class="value">${environmentInstance.memoryUsed.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.memoryFree" default="Memory Free"/>:</td>

                <td valign="top" class="value">${environmentInstance.memoryFree.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.memoryTotal" default="Memory Total"/>:</td>

                <td valign="top" class="value">${environmentInstance.memoryTotal.encodeAsHTML()}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="system.environment.memoryLimit" default="Memory Limit"/>:</td>

                <td valign="top" class="value">${environmentInstance.memoryLimit.encodeAsHTML()}</td>

            </tr>

            </tbody>
        </table>
    </div>
</div>
</body>
</html>
