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

import com.whollygrails.tlc.sys.TaskExecutable
import grails.util.Environment

class SupplierListReport extends TaskExecutable {

    def execute() {
        def reportParams = [:]
        def accessCodeList = bookService.supplierAccessCodes(company, user)
        def selectedCodes
        def codes = params.codes?.split(',') as List
        if (codes) {
            selectedCodes = accessCodeList.findAll {codes.contains(it.code)}
            reportParams.codes = params.codes
        } else {
            selectedCodes = accessCodeList
            reportParams.codes = message(code: 'generic.all.selection', default: '-- all --')
        }

        if (!selectedCodes) {
            completionMessage = message(code: 'report.no.access', default: 'You do not have permission to access any accounts and therefore cannot run this report.')
            return false
        }

        def mainClause = ' and access_code_id in ('
        for (int i = 0; i < selectedCodes.size(); i++) {
            if (i) mainClause += ','
            mainClause += selectedCodes[i].id.toString()
        }

        mainClause += ')'
        reportParams.mainClause = mainClause
        reportParams.colCode = message(code: 'supplier.code', default: 'Code')
        reportParams.colName = message(code: 'supplier.name', default: 'Name')
        reportParams.codesPrompt = message(code: 'report.accessCode', default: 'Access Code(s)')
        reportParams.active = params.active
        reportParams.activePrompt = message(code: 'report.active', default: 'Active Only')
        def title = message(code: 'supplier.list', default: 'Supplier List')
        reportParams.put('reportTitle', title)
        yield()
        def pdfFile = createReportPDF('SupplierList', reportParams)
        yield()
        utilService.sendMail {
            to user.email
            subject title
            body(view: '/emails/genericReport', model: [companyInstance: company, systemUserInstance: user, title: title])
            attach pdfFile
        }

        yield()
        if (Environment.current != Environment.DEVELOPMENT) pdfFile.delete()

        return true
    }
}
