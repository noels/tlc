/*
 *  Copyright 2010 Wholly Grails.
 *
 *  This file is part of the Three Ledger Core (TLC) software
 *  from Wholly Grails.
 *
 *  TLC is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  TLC is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with TLC.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.whollygrails.tlc.tasks

import com.whollygrails.tlc.books.GeneralBalance
import com.whollygrails.tlc.books.GeneralTransaction
import com.whollygrails.tlc.books.Period
import com.whollygrails.tlc.books.Year
import com.whollygrails.tlc.sys.TaskExecutable

class DeleteYearTask extends TaskExecutable {

    def execute() {
        def year = Year.get(params.stringId)
        if (!year || year.company.id != company.id) {
            completionMessage = message(code: 'year.not.found', args: [params.stringId], default: "Year not found with id ${params.stringId}")
            return false
        }

        yield()
        if (Year.countByCompanyAndValidFromGreaterThan(company, year.validTo) &&
                Year.countByCompanyAndValidToLessThan(company, year.validFrom)) {
            completionMessage = message(code: 'year.delete.gap', default: 'Deleting this year would leave a gap in the date ranges.')
            return false
        }

        yield()
        if (Period.countByYearAndStatusNotEqual(year, 'closed')) {
            completionMessage = message(code: 'year.delete.status', default: 'You may not delete a year if any of its periods are open')
            return false
        }

        def pds = Period.findAllByYear(year)
        for (pd in pds) {
            def bals = GeneralBalance.findAllByPeriod(pd)
            for (bal in bals) {
                if (GeneralTransaction.countByBalanceAndAccountUnallocatedNotEqual(bal, 0.0)) {
                    completionMessage = message(code: 'year.delete.unallocated', default: 'You may only delete a year when all of its customer and supplier transactions are fully allocated')
                    return false
                }
            }
        }

        yield()
        try {
            year.deleteTransactions()
        } catch (Exception ex) {
            log.error(ex)
            completionMessage = message(code: 'year.delete.trans', default: 'An error occurred deleting the transactions thus leaving the year in an inconsistent state. Contact your system administrator immediately.')
            return false
        }

        yield()
        bookService.deleteYear(year)
        return true
    }
}
