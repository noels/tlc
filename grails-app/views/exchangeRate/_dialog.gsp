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
<div class="dialog">
    <table>
        <tbody>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="validFrom"><g:msg code="exchangeRate.validFrom" default="Valid From" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:exchangeRateInstance,field:'validFrom','errors')}">
                <input initialField="true" type="text" name="validFrom" id="validFrom" size="20" value="${display(bean:exchangeRateInstance,field:'validFrom', scale: 1)}" />&nbsp;<g:help code="exchangeRate.validFrom"/>
            </td>
        </tr>

        <tr class="prop">
            <td valign="top" class="name">
                <label for="rate"><g:msg code="exchangeRate.rate" default="Rate" />:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean:exchangeRateInstance,field:'rate','errors')}">
                <input type="text" id="rate" name="rate" size="20" value="${display(bean:exchangeRateInstance,field:'rate', scale: 6)}" />&nbsp;<g:help code="exchangeRate.rate"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
