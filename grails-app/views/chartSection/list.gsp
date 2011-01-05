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
<%@ page import="com.whollygrails.tlc.books.ChartSection" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="chartSection.list" default="Chart Section List" /></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home" /></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu" /></g:link></span>
    <span class="menuButton"><g:link class="tree" action="tree"><g:msg code="chartSection.tree.button" default="Tree View" /></g:link></span>
    <span class="menuButton"><g:link class="print" action="print"><g:msg code="generic.print" default="Print" /></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="chartSection.new" default="New Chart Section" /></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="chartSection.list" default="Chart Section List"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}" /></div>
    </g:if>

    <div class="criteria">
        <g:criteria include="path, name, type*, autoCreate, sequencer, status*"/>
    </div>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="path" title="Path" titleKey="chartSection.path" />

                <g:sortableColumn property="name" title="Name" titleKey="chartSection.name" />

                <g:sortableColumn property="sequencer" title="Sequencer" titleKey="chartSection.sequencer" />

                <g:sortableColumn property="type" title="Type" titleKey="chartSection.type" />

                <g:sortableColumn property="status" title="Status" titleKey="chartSection.status" />

                <g:sortableColumn property="autoCreate" title="Auto Create" titleKey="chartSection.autoCreate" />

                <th><g:msg code="chartSection.segments" default="Segments"/></th>

                <th><g:msg code="chartSection.defaults" default="Defaults"/></th>

                <th><g:msg code="chartSection.ranges" default="Ranges"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${chartSectionInstanceList}" status="i" var="chartSectionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${chartSectionInstance.id}">${display(bean:chartSectionInstance, field:'path')}</g:link></td>

                    <td>${display(bean:chartSectionInstance, field:'name')}</td>

                    <td>${display(bean:chartSectionInstance, field:'sequencer')}</td>

                    <td><g:msg code="chartSection.type.${chartSectionInstance.type}" default="${chartSectionInstance.type}"/></td>

                    <td><g:msg code="chartSection.status.${chartSectionInstance.status}" default="${chartSectionInstance.status}"/></td>

                    <td>${display(bean:chartSectionInstance, field:'autoCreate')}</td>

                    <td>${segmentsList[i]}</td>

                    <td>${defaultsList[i]}</td>

                    <g:if test="${chartSectionInstance.segment1}">
                        <td><g:drilldown controller="chartSectionRange" value="${chartSectionInstance.id}"/></td>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <div class="paginateButtons">
        <g:paginate total="${chartSectionInstanceTotal}" />
    </div>
</div>
</body>
</html>
