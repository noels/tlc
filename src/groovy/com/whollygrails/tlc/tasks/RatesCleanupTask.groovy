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

import com.whollygrails.tlc.corp.ExchangeCurrency
import com.whollygrails.tlc.corp.ExchangeRate
import com.whollygrails.tlc.sys.TaskExecutable

public class RatesCleanupTask extends TaskExecutable {

    def execute() {
        def retentionDays = params.days
        if (!retentionDays || retentionDays < 0) retentionDays = 1100  // Default to just over three years of history
        def cutoff = utilService.fixDate(new Date() - retentionDays)
        def deleted = 0
        def failed = 0
        def currencies = ExchangeCurrency.findAllByCodeNotEqual(utilService.BASE_CURRENCY_CODE)
        for (currency in currencies) {
            yield()
            def rates = ExchangeRate.findAllByCurrencyAndValidFromLessThan(currency, cutoff, [sort: 'validFrom', order: 'desc'])
            if (rates.size() > 1) {
                def ftt = true
                for (rate in rates) {
                    if (ftt) {
                        ftt = false // Don't delete the first one - it might be the ONLY one left
                    } else {
                        try {
                            rate.delete(flush: true)
                            deleted++
                        } catch (Exception ex) {
                            failed++
                        }
                    }
                }
            }
        }

        results.count = deleted
        results.failed = failed
    }
}