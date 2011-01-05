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
    <title><g:msg code="chartSection.show" default="Show Chart Section"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="chartSection.list" default="Chart Section List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="chartSection.new" default="New Chart Section"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="chartSection.show" default="Show Chart Section"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'id')}</td>

                </tr>
            </g:permit>


            <tr class="prop">
                <td valign="top" class="name"><g:msg code="chartSection.path" default="Path"/>:</td>

                <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'path')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="chartSection.name" default="Name"/>:</td>

                <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'name')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="chartSection.sequencer" default="Sequencer"/>:</td>

                <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'sequencer')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="chartSection.type" default="Type"/>:</td>

                <td valign="top" class="value"><g:msg code="chartSection.type.${chartSectionInstance.type}" default="${chartSectionInstance.type}"/></td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="chartSection.status" default="Status"/>:</td>

                <td valign="top" class="value"><g:msg code="chartSection.status.${chartSectionInstance.status}" default="${chartSectionInstance.status}"/></td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:msg code="chartSection.autoCreate" default="Auto Create"/>:</td>

                <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'autoCreate')}</td>

            </tr>

            <tr>
                <td colspan="2">
                    <table style="border:0px;">
                        <tbody>
                        <tr class="prop">
                            <td valign="top" class="name"></td>
                            <td valign="top" class="name" style="font-weight:bold;"><g:msg code="chartSection.segments" default="Segments"/></td>
                            <td valign="top" class="name" style="font-weight:bold;"><g:msg code="chartSection.defaults" default="Defaults"/></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">1:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment1?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default1')}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">2:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment2?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default2')}</td>

                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">3:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment3?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default3')}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">4:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment4?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default4')}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">5:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment5?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default5')}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">6:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment6?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default6')}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">7:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment7?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default7')}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">8:</td>
                            <td valign="top" class="value">${chartSectionInstance?.segment8?.name?.encodeAsHTML()}</td>
                            <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'default8')}</td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>


            <g:permit activity="sysadmin">

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="chartSection.code" default="Code"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'code')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="chartSection.pattern" default="Pattern"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'pattern')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="chartSection.treeSequence" default="Tree Sequence"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'treeSequence')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="chartSection.accountSegment" default="Account Segment"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'accountSegment')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="chartSection.parent" default="Parent"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'parent')}</td>

                </tr>

                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'securityCode')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'dateCreated')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'lastUpdated')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: chartSectionInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${chartSectionInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
