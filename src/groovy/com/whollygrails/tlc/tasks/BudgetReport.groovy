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
import com.whollygrails.tlc.books.*

class BudgetReport extends TaskExecutable {

    def execute() {
        def reportParams = [divisor: 1000.0]
        def year = Year.findByIdAndSecurityCode(params.yearId, company.securityCode)
        if (!year) {
            completionMessage = message(code: 'year.not.found', args: [params.yearId], default: "Year not found with id ${params.yearId}")
            return false
        }

        def title = message(code: 'budget.report.title', args: [year.code], default: "Budget Listing for Year ${year.code}".toString())     // Careful of GStrings in report parameters
        reportParams.reportTitle = title
        reportParams.subTitle = message(code: 'budget.report.subtitle', args: [currency.code], default: "(All values shown in ${currency.code} thousands)".toString())

        def offset = 0
        def periodId, period, periodClause
        for (int i = 1; i <= 13; i++) {
            periodId = params."periodId${i}"
            if (periodId) {
                period = Period.findByIdAndYear(periodId, year)
                if (period) {
                    reportParams."txtCol${i}" = period.code
                    if (periodClause) {
                        periodClause += ', ' + period.id.toString()
                    } else {
                        periodClause = 'p.id in (' + period.id.toString()
                    }
                } else {
                    completionMessage = message(code: 'period.not.found', args: [periodId], default: "Period not found with id ${periodId}")
                    return false
                }
            } else {
                offset++
                reportParams."txtCol${i}" = ''
            }
        }

        if (offset == 13) {
            completionMessage = message(code: 'budget.no.periods', default: 'There are no periods available in the selected year')
            return false
        }

        reportParams.offset = offset
        reportParams.periodClause = periodClause + ')'
        yield()

        reportParams.txtSections = message(code: 'budget.report.sections', default: 'Section(s)')
        if (params.section) {
            if (['ie', 'bs'].contains(params.section)) {
                reportParams.sectionClause = "AND s.section_type = '${params.section}'".toString()  // Groovy GStrings not allowed in report parameters
                reportParams.valSections = message(code: 'systemAccountType.sectionType.' + params.section,
                        default: (params.section == 'ie' ? 'Income and Expenditure' : 'Balance Sheet'))
            } else {
                def section = ChartSection.findByIdAndCompany(params.section, company)
                if (!section) {
                    completionMessage = message(code: 'chartSection.not.found', args: [params.section], default: "Chart Section not found with id ${params.section}")
                    return false
                }

                reportParams.sectionClause = "AND s.id = '${params.section}'".toString()
                reportParams.valSections = section.name
            }
        } else {
            reportParams.sectionClause = ''
            reportParams.valSections = message(code: 'generic.all.selection', default: '-- all --')
        }

        def exclusions = []
        def accountClause = ''
        def fragment, valueId, val
        def elements = CodeElement.findAllByCompanyAndElementNumberGreaterThan(company, (byte) 1, [sort: 'elementNumber'])
        for (element in elements) {
            fragment = bookService.createElementAccessFragment('x', element, company, user)
            if (fragment != null) {     // They have some access to this element
                reportParams."txtElement${element.elementNumber}" = element.name
                valueId = params."element${element.elementNumber}"
                if (valueId) {
                    val = CodeElementValue.findByIdAndElement(valueId, element)
                    if (val && bookService.hasCodeElementValueAccess(val, company, user)) {
                        exclusions << element
                        accountClause += ' AND a.element' + element.elementNumber.toString() + '_id = ' + val.id.toString()
                        reportParams."valElement${element.elementNumber}" = val.code
                    } else {
                        completionMessage = message(code: 'codeElementValue.not.found', args: [valueId], default: "Code Element Value not found with id ${valueId}")
                        return false
                    }
                } else {
                    reportParams."valElement${element.elementNumber}" = message(code: 'generic.all.selection', default: '-- all --')
                }
            }
        }

        fragment = bookService.createAccountAccessFragment('a', exclusions, true, company, user)
        if (fragment) {
            accountClause += ' AND ' + fragment
        } else if (fragment == null) {
            completionMessage = message(code: 'generic.no.permission', default: 'There are no accounts you can access and therefore you cannot perform this operation')
            return false
        }

        reportParams.accountClause = accountClause
        reportParams.txtDebit = message(code: 'generic.debit', default: 'Debit')
        reportParams.txtCredit = message(code: 'generic.credit', default: 'Credit')
        reportParams.txtSummary = message(code: 'generic.summary', default: 'Summary')
        yield()

        def pdfFile = createReportPDF('Budget', reportParams)
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
