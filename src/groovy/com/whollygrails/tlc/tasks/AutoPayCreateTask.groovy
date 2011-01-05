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

import com.whollygrails.tlc.books.Supplier
import com.whollygrails.tlc.sys.TaskExecutable

class AutoPayCreateTask extends TaskExecutable {
    def execute() {
        if (company.systemOnly) return true     // Don't do this for the System company
        def today = utilService.fixDate()
        def examined = 0
        def created = 0
        def result
        def supplierIds = Supplier.executeQuery('select id from Supplier where company = ? and active = ? and nextAutoPaymentDate <= ?', [company, true, today])
        for (supplierId in supplierIds) {
            yield()
            result = bookService.autoPayService.createRemittanceAdvice(supplierId, true, today)
            if (result instanceof String) {
                completionMessage = result
                return false
            } else {
                examined++
                if (result) created++
            }
        }

        results.examined = examined
        results.created = created

        return true
    }
}
