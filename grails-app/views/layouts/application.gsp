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
<!--
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
 ~  along with TLC.  If not, see http://www.gnu.org/licenses.
 -->
<html>
<head>
    <title><g:layoutTitle default="Wholly Grails"/></title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon"/>
    <g:layoutHead/>
    <g:javascript library="prototype"/>
    <g:javascript library="application"/>
    <g:javascript src="HelpBalloon.js"/>
    <g:helpSetup/>
</head>
<body onload="bodyLoaded()">
<div id="spinner" class="spinner" style="display:none;">
    <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt="Spinner"/>
</div>
<div id="topbar">
    <div id="menu">
        <nobr>
            <g:if test="${userName()}">
                <g:formatHelp/>&nbsp;&nbsp;<g:link controller="systemUser" action="profile"><g:userName/></g:link>&nbsp;|&nbsp;<g:link controller="systemUser" action="logout"><g:msg code="topbar.logout" default="Logout"/></g:link>
            </g:if>
            <g:else>
                <g:link controller="systemUser" action="login"><g:msg code="topbar.login" default="Login"/></g:link>&nbsp;|&nbsp;<g:link controller="systemUser" action="register"><g:msg code="topbar.register" default="Register"/></g:link>
            </g:else>
        </nobr>
    </div>
</div>
<div class="logo">
    <img src="${resource(dir: 'images/logos', file: companyLogo())}" alt="${msg(code: 'topbar.logo', default: 'Logo')}" width="48" height="48"/>
    <g:if test="${companyName()}">
        <g:companyName/>
    </g:if>
    <g:else>
        <g:msg code="generic.company"/>
    </g:else>
</div>
<g:layoutBody/>
<p>&nbsp;</p>
<div id="footer">
    <span class="copyright">Copyright 2010 Wholly Grails</span>
</div>
</body>
</html>