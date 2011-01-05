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
<%@ page import="com.whollygrails.tlc.books.Account" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="bodyClass" content="accounts"/>
    <title><g:msg code="account.show" default="Show Account"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="list"><g:msg code="account.list" default="Account List"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:msg code="account.new" default="New Account"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="account.show" default="Show Account"/>
    <g:if test="${flash.message}">
        <div class="message"><g:msg code="${flash.message}" args="${flash.args}" default="${flash.defaultMessage}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.id" default="Id"/>:</td>

                    <td valign="top" class="value">${display(bean: accountInstance, field: 'id')}</td>

                </tr>
            </g:permit>


            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.code" default="Code"/>:</td>

                <td valign="top" class="value">${display(bean: accountInstance, field: 'code')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.name" default="Name"/>:</td>

                <td valign="top" class="value">${display(bean: accountInstance, field: 'name')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.currency" default="Currency"/>:</td>

                <td valign="top" class="value">${msg(code: 'currency.name.' + accountInstance.currency.code, default: accountInstance.currency.name)}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.revaluationAccount" default="Revaluation Account"/>:</td>

                <td valign="top" class="value">${accountInstance.revaluationAccount ? (accountInstance.revaluationAccount.code + ' '+ accountInstance.revaluationAccount.name).encodeAsHTML() : ''}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.revaluationMethod" default="Revaluation Method"/>:</td>

                <td valign="top" class="value">${accountInstance.revaluationMethod ? msg(code: 'account.revaluationMethod.' + accountInstance.revaluationMethod, default: accountInstance.revaluationMethod) : ''}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.status" default="Status"/>:</td>

                <td valign="top" class="value">${msg(code: 'account.status.' + accountInstance.status, default: accountInstance.status)}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.type" default="Type"/>:</td>

                <td valign="top" class="value">${accountInstance.type ? msg(code: 'systemAccountType.name.' + accountInstance.type.code, default: accountInstance.type.name) : ''}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.active" default="Active"/>:</td>

                <td valign="top" class="value">${display(bean: accountInstance, field: 'active')}</td>

            </tr>



            <tr class="prop">
                <td valign="top" class="name"><g:msg code="account.section" default="Section"/>:</td>

                <td valign="top" class="value">${accountInstance?.section?.name?.encodeAsHTML()}</td>

            </tr>



            <g:permit activity="sysadmin">
                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element1" default="Element1"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element1?.encodeAsHTML()}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element2" default="Element2"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element2?.encodeAsHTML()}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element3" default="Element3"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element3?.encodeAsHTML()}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element4" default="Element4"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element4?.encodeAsHTML()}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element5" default="Element5"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element5?.encodeAsHTML()}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element6" default="Element6"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element6?.encodeAsHTML()}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element7" default="Element7"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element7?.encodeAsHTML()}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="account.element8" default="Element8"/>:</td>

                    <td valign="top" class="value">${accountInstance?.element8?.encodeAsHTML()}</td>

                </tr>


                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.securityCode" default="Security Code"/>:</td>

                    <td valign="top" class="value">${display(bean: accountInstance, field: 'securityCode')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.dateCreated" default="Date Created"/>:</td>

                    <td valign="top" class="value">${display(bean: accountInstance, field: 'dateCreated')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.lastUpdated" default="Last Updated"/>:</td>

                    <td valign="top" class="value">${display(bean: accountInstance, field: 'lastUpdated')}</td>

                </tr>



                <tr class="prop">
                    <td valign="top" class="name"><g:msg code="generic.version" default="Version"/>:</td>

                    <td valign="top" class="value">${display(bean: accountInstance, field: 'version')}</td>

                </tr>
            </g:permit>

            </tbody>
        </table>
    </div>
    <div class="buttons">
        <g:form>
            <input type="hidden" name="id" value="${accountInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="Edit" value="${msg(code:'edit', 'default':'Edit')}"/></span>
            <g:if test="${!hasTransactions}">
                <span class="button"><g:actionSubmit class="delete" onclick="return confirm('${msg(code:'delete.confirm', 'default':'Are you sure?')}');" action="Delete" value="${msg(code:'delete', 'default':'Delete')}"/></span>
            </g:if>
        </g:form>
    </div>
</div>
</body>
</html>
