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
<%@ page import="com.whollygrails.tlc.books.CustomerContact" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="customerContact.list" default="Customer Contact List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="customerContact.new" default="New Customer Contact" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="customerContact.list" default="Customer Contact List" returns="true"/>
    <p>
    <g:each in="${customerAddressLines}" status="j" var="customerAddressLine">
        <g:if test="${j}"><br/></g:if>${customerAddressLine?.encodeAsHTML()}
    </g:each>
    </p>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="name, identifier"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>
                <g:sortableColumn property="name" title="Name" titleKey="customerContact.name" />

                <g:sortableColumn property="identifier" title="Identifier" titleKey="customerContact.identifier" />

                <th><g:msg code="customerContact.usages" default="Usages"/></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${customerContactInstanceList}" status="i" var="customerContactInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${customerContactInstance.id}">${display(bean:customerContactInstance, field:'name')}</g:link></td>

                    <td>${display(bean:customerContactInstance, field:'identifier')}</td>

                    <td>
                        <g:each in="${customerContactInstance.usages}" status="k" var="customerContactUsage">
                            <g:if test="${k}"><br/></g:if><g:msg code="customerContactType.name.${customerContactUsage.type.code}" default="${customerContactUsage.type.name}"/>
                        </g:each>
                    </td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${customerContactInstanceTotal}" />
    </div>
</div>
</body>
</html>
