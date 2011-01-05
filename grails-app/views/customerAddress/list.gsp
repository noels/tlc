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
<%@ page import="com.whollygrails.tlc.books.CustomerAddress" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title><g:msg code="customerAddress.list" default="Customer Address List"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="customerAddress.new" default="New Customer Address"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="customerAddress.list.for" args="${[ddSource?.name]}" default="Customer Address List for ${ddSource?.name}" returns="true"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="list">
        <table>
            <thead>
            <tr>
                <th><g:msg code="customer.address" default="Address"/></th>
                <th><g:msg code="customerAddress.addressUsages" default="Usages"/></th>
                <th><g:msg code="customerAddress.contacts" default="Contacts"/></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${customerAddressInstanceList}" status="i" var="customerAddressInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>
                        <g:link action="show" id="${customerAddressInstance.id}">
                            <g:each in="${customerAddressLines[i]}" status="j" var="customerAddressLine">
                                <g:if test="${j}"><br/></g:if>${customerAddressLine?.encodeAsHTML()}
                            </g:each>
                        </g:link>
                    </td>
                    <td>
                        <g:each in="${customerAddressInstance.addressUsages}" status="k" var="customerAddressUsage">
                            <g:if test="${k}"><br/></g:if><g:msg code="customerAddressType.name.${customerAddressUsage.type.code}" default="${customerAddressUsage.type.name}"/>
                        </g:each>
                    </td>

                    <td><g:drilldown controller="customerContact" action="list" value="${customerAddressInstance.id}"/></td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${customerAddressInstanceTotal}"/>
    </div>
</div>
</body>
</html>
