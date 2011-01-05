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

import com.whollygrails.tlc.corp.TaxStatement
import com.whollygrails.tlc.sys.TaskExecutable
import grails.util.Environment

public class TaxStatementReport extends TaskExecutable {

    def execute() {
        def statement = TaxStatement.get(params.stringId)
        if (statement?.securityCode != company.securityCode) {
            completionMessage = message(code: 'taxStatement.not.found', args: [params.stringId], default: "Tax Statement not found with id ${params.stringId}")
            return false
        }

        def taxCodeNameMap = [:]
        for (tc in statement.authority.taxCodes) {
            taxCodeNameMap.put(tc.code, message(code: 'taxCode.name.' + tc.code, default: tc.name))
        }

        def reportParams = [:]
        def title = message(code: 'taxStatement.title', args: [utilService.format(statement.statementDate, 1, null, locale), statement.authority.name],
                default: 'Tax Statement on ' + utilService.format(statement.statementDate, 1, null, locale) + ' for ' + statement.authority.name)
        reportParams.put('reportTitle', title)
        reportParams.put('statementId', statement.id)
        reportParams.put('colCode', message(code: 'taxStatementLine.taxCode', default: 'Tax Code'))
        reportParams.put('colRate', message(code: 'taxStatementLine.taxPercentage', default: 'Tax Rate'))
        reportParams.put('colGoods', message(code: 'taxStatementLine.companyGoodsValue', default: 'Goods Value'))
        reportParams.put('colTax', message(code: 'taxStatementLine.companyTaxValue', default: 'Tax Value'))
        reportParams.put('currentPd', message(code: 'taxStatementLine.currentStatement', default: 'Current'))
        reportParams.put('priorPd', message(code: 'taxStatementLine.priorStatement', default: 'Prior'))
        reportParams.put('inputs', message(code: 'taxStatementLine.inputTax', default: 'Input Tax'))
        reportParams.put('outputs', message(code: 'taxStatementLine.outputTax', default: 'Output Tax'))
        reportParams.put('payable', message(code: 'taxStatement.totalPayable', default: 'Total Payable'))
        reportParams.put('refund', message(code: 'taxStatement.totalRefund', default: 'Total Refund'))
        reportParams.put('summary', message(code: 'generic.summary', default: 'Summary'))
        reportParams.put('taxCodeNameMap', taxCodeNameMap)
        yield()
        def pdfFile = createReportPDF('TaxStatement', reportParams)
        yield()
        utilService.sendMail {
            to user.email
            subject title
            body(view: '/emails/genericReport', model: [companyInstance: company, systemUserInstance: user, title: title])
            attach pdfFile
        }

        yield()
        if (Environment.current != Environment.DEVELOPMENT) pdfFile.delete()
    }
}