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
    <title><g:msg code="runtimeLogging.changed" default="Logging Level Changed"/></title>
</head>
<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:msg code="home" default="Home"/></a></span>
    <span class="menuButton"><g:link class="menu" controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link></span>
    <span class="menuButton"><g:link class="list" action="index"><g:msg code="runtimeLogging.set" default="Set Logging Levels"/></g:link></span>
</div>
<div class="body">
    <g:pageTitle code="runtimeLogging.changed" default="Logging Level Changed"/>
    <p>&nbsp;</p>
    <g:msg code="runtimeLogging.setting" args="${[logger, level]}" default="Logger ${logger} set to level ${level}"/>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <g:pageTitle code="runtimeLogging.equivalent" default="Config.groovy equivalent"/>
    <p>&nbsp;</p>
    <g:msg code="runtimeLogging.update" default="Update the log4j/logger{} closure in Config.groovy to achieve the same effect permanently"/>:<br/><br/>
    <p>
    <pre>
        log4j
        {
        ...
        logger
        {
        ...
        ${loggerConfig}
        }
        }
    </pre>
</p>
</div>
</body>
</html>