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

import com.whollygrails.tlc.books.Reconciliation
import com.whollygrails.tlc.sys.TaskExecutable
import grails.util.Environment

public class ReconciliationReport extends TaskExecutable {

    def execute() {
        def reconciliation = Reconciliation.get(params.recId)
        if (!reconciliation || reconciliation.securityCode != company.securityCode || !bookService.hasAccountAccess(reconciliation, company, user)) {
            completionMessage = message(code: 'reconciliation.not.found', args: [params.recId.toString()], default: "Reconciliation not found with id ${params.recId}")
            return false
        }

        def bankAccount = reconciliation.bankAccount
        def bankCurrency = bankAccount.currency
        def title = message(code: 'reconciliation.reportTitle', args: [utilService.format(reconciliation.statementDate, 1, null, locale), bankCurrency.code],
                default: "Bank Reconciliation Statement on ${utilService.format(reconciliation.statementDate, 1, null, locale)} in ${bankCurrency.code}".toString())    // No GStrings in parameters
        def reportParams = [:]
        reportParams.reportTitle = title
        reportParams.reconciliationId = reconciliation.id
        reportParams.decimals = bankCurrency.decimals
        reportParams.txtBF = message(code: 'generic.bf', default: 'b/f')
        reportParams.txtCF = message(code: 'generic.cf', default: 'c/f')
        reportParams.txtPartBF = message(code: 'reconciliationLine.part', default: 'Part')
        reportParams.txtFullBF = message(code: 'reconciliationLine.full', default: 'Full')
        reportParams.txtDate = message(code: 'reconciliationLine.date', default: 'Date')
        reportParams.txtDocument = message(code: 'generic.document', default: 'Document')
        reportParams.txtReference = message(code: 'reconciliationLine.reference', default: 'Reference')
        reportParams.txtDescription = message(code: 'document.description', default: 'Description')
        reportParams.txtPart = message(code: 'reconciliationLine.part', default: 'Part')
        reportParams.txtPayment = message(code: 'reconciliationLine.payment', default: 'Payment')
        reportParams.txtReceipt = message(code: 'reconciliationLine.receipt', default: 'Receipt')
        reportParams.txtUnreconciledTotals = message(code: 'reconciliation.reportUnreconciled', default: 'Items in our Bank Account not on the Statement')
        reportParams.txtNoUnreconciledTotals = message(code: 'reconciliation.no.reportUnreconciled', default: 'There are no items in our Bank Account that are not also on the Statement')
        reportParams.txtSummary = message(code: 'reconciliation.reportSummary', default: 'Summary')
        reportParams.txtStatementBalance = message(code: 'reconciliation.statementBalance', default: 'Statement Balance')
        reportParams.txtAddReceipts = message(code: 'reconciliation.reportReceipts', default: 'add Unlodged Receipts')
        reportParams.txtLessPayments = message(code: 'reconciliation.reportPayments', default: 'less Unpresented Payments')
        reportParams.txtDifferenceShortReceipts = message(code: 'reconciliation.reportShortReceipts', default: 'Difference (short of net receipts)')
        reportParams.txtDifferenceShortPayments = message(code: 'reconciliation.reportShortPayments', default: 'Difference (short of net payments)')
        reportParams.txtBankAccountBalance = message(code: 'reconciliation.bankAccountBalance', default: 'Bank Account Balance')
        reportParams.txtBankAccountName = bankAccount.name
        reportParams.txtOD = message(code: 'generic.od', default: 'o/d')
        if (reconciliation.finalizedDate) {
            reportParams.txtFinalized = message(code: 'reconciliation.reportFinalized', args: [utilService.format(reconciliation.finalizedDate, 1, null, locale)],
                    default: "(This reconciliation was finalized on ${utilService.format(reconciliation.finalizedDate, 1, null, locale)})".toString())   // GStrings not allowed as Jasper parameters
        } else {
            reportParams.txtFinalized = message(code: 'reconciliation.reportNotFinalized', default: '(This reconciliation has not yet been finalized)')
        }

        yield()
        def pdfFile = createReportPDF('BankReconciliation', reportParams)
        yield()
        utilService.sendMail {
            to user.email
            subject title
            body(view: '/emails/genericReport', model: [companyInstance: company, systemUserInstance: user, title: bankAccount.name + ' ' + title])
            attach pdfFile
        }

        yield()
        if (Environment.current != Environment.DEVELOPMENT) pdfFile.delete()
        return true
    }
}