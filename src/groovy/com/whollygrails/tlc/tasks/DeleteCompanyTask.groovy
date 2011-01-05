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

import com.whollygrails.tlc.corp.Company
import com.whollygrails.tlc.sys.TaskExecutable

class DeleteCompanyTask extends TaskExecutable {

    def execute() {
        def corp = Company.get(params.stringId)
        if (!corp) {
            completionMessage = message(code: 'company.not.found', args: [params.stringId], default: "Company not found with id ${params.stringId}")
            return false
        }

        yield()
        if (corp.systemOnly) {
            completionMessage = message(code: 'company.system.delete', default: 'You may not delete the system company')
            return false
        }

        yield()
        try {
            corp.prepareForDeletion(runSessionFactory.currentSession)   // Notice not in a transaction
        } catch (Exception ex) {
            log.error(ex)
            completionMessage = message(code: 'company.delete.prep', default: 'An error occurred deleting the company thus leaving the company in an inconsistent state. Contact your system administrator immediately.')
            return false
        }

        yield()
        def valid = true
        Company.withTransaction {status ->
            try {
                bookService.deleteCompany(corp)
                utilService.cacheService.clearAll(corp.securityCode)
                def logo = utilService.realFile("/images/logos/L${corp.securityCode}.png")
                if (logo.exists()) logo.delete()
            } catch (Exception ex1) {
                status.setRollbackOnly()
                log.error(ex1)
                completionMessage = message(code: 'company.not.deleted', args: [corp.toString(), ex1.class.simpleName], default: "Company ${corp.toString()} could not be deleted (${ex1.class.simpleName})")
                valid = false
            }
        }

        return valid
    }
}
