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
    <meta name="layout" content="none"/>
    <meta name="Keywords" content="accounting,accounts,accountant,bookkeeping,books of account,computerized accounting,grails,java,open source software"/>
    <meta name="Description" content="Open source accounting software from Wholly Grails"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'intro.css')}"/>
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon"/>
    <title>Open Source Accounting Software From Wholly Grails</title>
    <SCRIPT language="JavaScript">
        function destination() {
            var data = '${revcon()}';
            var revstr = '';
            for (i = data.length - 1; i >= 0; i--) {
                revstr += data.charAt(i);
            }

            revstr = revstr.replace('[', '@');
            revstr = revstr.replace(']', ':');
            revstr = revstr.replace('..', '.');
            document.getElementById('sad').href = revstr;
            return true;
        }
    </SCRIPT>
</head>
<body>
<div id="page">
    <g:menuReset/>
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
    <div id="header">
        <img src="${resource(dir: 'images/logos', file: companyLogo())}" alt="${msg(code: 'topbar.logo', default: 'Logo')}" width="48" height="48"/>
        <g:if test="${companyName()}">
            <g:companyName/>
        </g:if>
        <g:else>
            <g:msg code="generic.company"/>
        </g:else>
    </div>
    <g:if test="${companyName()}">
        <p style="margin: 5px 20px 10px 20px; font-weight: bold;">
            You are currently logged in to the system. To return to the application menu click this link:
            <g:link controller="systemMenu" action="display"><g:msg code="systemMenu.display" default="Menu"/></g:link>
        </p>
    </g:if>
    <div id="content">
        <h1>Open Source Accounting Software</h1>
        <p>
            TLC from Wholly Grails is an Open Source three-ledger (GL, AR and AP) core accounting system designed for use by medium to large enterprises.
            Capable of working as a 'bookkeeping engine' in to which your existing applications can feed and retrieve accounting data, TLC comes complete
            with a fully functioning browser-based front-end for manual data entry plus an extensive reporting system including Trial Balance, Income and
            Expenditure Statement, Balance Sheet, detailed posting reports, Aged Lists of debtors and creditors etc. Its main features are outlined below.
        </p>
        <div id="bullets">
            <h2>Overview</h2>
            <ul>
                <li>Multi-Company</li>
                <li>Multi-Currency</li>
                <li>Multilingual</li>
                <li>Multi-User</li>
            </ul>
            <h2>General Ledger</h2>
            <ul>
                <li>Up to eight levels of GL analysis</li>
                <li>GL code defaults and mnemonics</li>
                <li>Any number of periods per year</li>
                <li>Multiple open periods</li>
                <li>Multi-year history retention</li>
                <li>Multiple bank and cash accounts</li>
                <li>Recurring bank transactions</li>
                <li>Bank reconciliation facility</li>
                <li>Foreign currency account revaluation</li>
                <li>Automatic exchange rate update, if required</li>
                <li>Recurring journal templates</li>
                <li>Auto-reversing provisions</li>
                <li>Budget recording and reporting</li>
                <li>Document searching and account enquiries</li>
            </ul>
            <h2>AR and AP Ledgers</h2>
            <ul>
                <li>Open-item accounts (with multi-year history)</li>
                <li>Multiple document types (e.g. Home and Export invoices)</li>
                <li>Generic Sales/Purchase/VAT taxation facilities</li>
                <li>Foreign exchange difference recording</li>
                <li>Manual or automatic invoice/cash allocations</li>
                <li>Intra-ledger and inter-ledger journals</li>
                <li>Customer statements</li>
                <li>Automatic supplier payments with remittance advices</li>
                <li>Account and document enquiry facilities</li>
            </ul>
            <h2>Security and Other Features</h2>
            <ul>
                <li>Roles control access to functionality</li>
                <li>Access Groups control access to data</li>
                <li>Role sensitive menu display</li>
                <li>Powerful system administration functions</li>
                <li>Extensive on-line help at 'page' and 'field' levels</li>
                <li>Immediate postings, no batch processing</li>
                <li>Background processing system for report creation etc.</li>
            </ul>
        </div>
        <p style="margin-top: 15px;">
            TLC is written in <a href="http://www.grails.org">Grails</a>, a leading <a href="http://www.java.com">Java</a> based
        development framework, and was developed using <a href="http://www.mysql.com">MySQL</a> as its underlying database
        plus <a href="http://www.jasperforge.org/projects/jasperreports">JasperReports</a> for production of its PDF report
        output. TLC, MySQL and JasperReports are all freely available for download and use, as
        is <a href="http://www.jasperforge.org/projects/ireport">iReport</a>, the visual report designer for JasperReports.
        TLC is made available under the <a href="http://www.gnu.org/copyleft/gpl.html">GNU General Public License</a> version 3.
        </p>
        <p>&nbsp;</p>
    </div>
    <div id="sidebar">
        <h1>Fast Track</h1>
        <div id="actions">
            <h1>What do you want to do...</h1>
            <p><g:link controller="systemUser" action="register">Create my own test company</g:link></p>
            <p><g:link controller="systemUser" action="login">Revisit my test company</g:link></p>
            <p><a href="${resource(base: '/downloads', file: 'tlc-' + appVersion() + '.zip')}">Download the source code</a></p>
            <p><a href="${resource(base: '/downloads', file: 'technotes.pdf')}">View technical installation notes</a></p>
            <p><a href="${resource(base: '/downloads', file: 'accountnotes.pdf')}">View accounting set-up notes</a></p>
            <p><a id="sad" href="" onclick="destination();">Contact Wholly Grails</a></p>
        </div>
        <div id="rest">
            <h1>RESTful interface...</h1>
            <p><a href="${resource(base: '/downloads', file: 'restnotes.pdf')}">View RESTful interface notes</a></p>
            <p><a href="${resource(base: '/downloads', file: 'RestTest.groovy')}">Download the test program</a></p>
        </div>
        <div id="status">
            <h1>Status information...</h1>
            <p>Current version: ${appVersion()}</p>
            <p><a href="${resource(base: '/downloads', file: 'issues.pdf')}">View known issues</a></p>
            <p><a href="${resource(base: '/downloads', file: 'changelog.pdf')}">View change log</a></p>
        </div>
    </div>
    <div id="footer">
        <span class="copyright">Copyright 2010 Wholly Grails</span>
    </div>
</div>
</body>
</html>