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
    <meta name="layout" content="none"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>
    <title><g:msg code="systemPageHelp.title" default="Page Help"/></title>
</head>
<body>
<div class="body">
    <g:if test="${displayInstance.lines}">
        <div class="pageHelp">
            <g:each in="${displayInstance.lines}" var="line">${line}
            </g:each>
        </div>
    </g:if>
    <g:else>
        <div style="margin-top:20px;"><h2><g:msg code="systemPageHelp.no.help" default="No page help is available."/></h2></div>
    </g:else>
</div>
</body>
</html>