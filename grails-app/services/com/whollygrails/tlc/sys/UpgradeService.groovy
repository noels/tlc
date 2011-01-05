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
package com.whollygrails.tlc.sys

import com.whollygrails.tlc.books.Allocation
import com.whollygrails.tlc.books.Customer
import com.whollygrails.tlc.books.GeneralTransaction
import com.whollygrails.tlc.books.Supplier
import grails.util.Environment

class UpgradeService {

    boolean transactional = false

    static upgrade(dataVersion, to, servletContext) {
        if (dataVersion.value == '1.0') {
            if (!upgradeTo_1_1(dataVersion, to, servletContext)) return false
        }

        if (dataVersion.value == '1.1') {
            if (!upgradeTo_1_2(dataVersion, to, servletContext)) return false
        }

        if (dataVersion.value == '1.2') {
            if (!upgradeTo_1_3(dataVersion, to, servletContext)) return false
        }

        return true
    }

    static upgradeTo_1_1(dataVersion, to, servletContext) {

        // Do the non-transactional stuff first
        importMessageFile(servletContext, 'tlc')
        setPageHelp(servletContext, 'revaluation')
        setPageHelp(servletContext, 'account.enquire')
        setPageHelp(servletContext, 'customer.enquire')
        setPageHelp(servletContext, 'supplier.enquire')
        setPageHelp(servletContext, 'document.allocations')

        // Now for the serious stuff
        def valid = true
        def customers = Customer.findAll('from Customer as x where x.revaluationMethod is null and x.currency.companyCurrency = ?', [false])
        def suppliers = Supplier.findAll('from Supplier as x where x.revaluationMethod is null and x.currency.companyCurrency = ?', [false])
        def transactions = GeneralTransaction.findAll('from GeneralTransaction where (customer is not null or supplier is not null) and companyUnallocated is null')
        Allocation.withTransaction {status ->
            if (valid && !SystemAccountType.findByCode('glRevalue')) {
                if (!createAccountType(code: 'glRevalue', name: 'GL revaluation account', sectionType: 'bs',
                        singleton: false, changeable: true, allowInvoices: false, allowCash: false, allowProvisions: false, allowJournals: true)) valid = false
            }

            if (valid && !SystemAccountType.findByCode('arRevalue')) {
                if (!createAccountType(code: 'arRevalue', name: 'AR revaluation account', sectionType: 'bs',
                        singleton: true, changeable: true, allowInvoices: false, allowCash: false, allowProvisions: false, allowJournals: true)) valid = false
            }

            if (valid && !SystemAccountType.findByCode('apRevalue')) {
                if (!createAccountType(code: 'apRevalue', name: 'AP revaluation account', sectionType: 'bs',
                        singleton: true, changeable: true, allowInvoices: false, allowCash: false, allowProvisions: false, allowJournals: true)) valid = false
            }

            if (valid) {
                for (customer in customers) {
                    customer.revaluationMethod = 'standard'
                    if (!customer.saveThis()) {
                        valid = false
                        break
                    }
                }
            }

            if (valid) {
                for (supplier in suppliers) {
                    supplier.revaluationMethod = 'standard'
                    if (!supplier.saveThis()) {
                        valid = false
                        break
                    }
                }
            }

            if (valid) {
                def total, val, currency, lastAlloc
                for (tran in transactions) {
                    if (tran.accountValue == tran.companyValue) {                   // It's in company currency
                        tran.companyUnallocated = tran.accountUnallocated
                        for (alloc in tran.allocations) alloc.companyValue = alloc.accountValue
                    } else {    // Foreign Currency
                        currency = tran.balance.account.currency                    // Get the company currency
                        if (tran.accountValue == 0.0 && tran.companyValue != 0.0) { // An fx adjustment document
                            tran.companyUnallocated = tran.companyValue
                        } else if (tran.accountUnallocated == 0.0) {                // Fully allocated
                            tran.companyUnallocated = 0.0
                        } else if (tran.accountUnallocated == tran.accountValue) {  // Completely unallocated
                            tran.companyUnallocated = tran.companyValue
                        } else {                                                    // Partially allocated
                            tran.companyUnallocated = UtilService.round((tran.companyValue * tran.accountUnallocated) / tran.accountValue, currency.decimals)
                        }

                        total = tran.companyValue - tran.companyUnallocated
                        lastAlloc = null
                        for (alloc in tran.allocations) {
                            lastAlloc = alloc
                            val = UtilService.round((tran.companyValue * alloc.accountValue) / tran.accountValue, currency.decimals)
                            alloc.companyValue = val
                            total += val
                        }

                        if (lastAlloc && total) lastAlloc.companyValue -= total     // Take care of any rounding differnces
                    }

                    if (!tran.save(flush: true)) {  // With deep validation
                        valid = false
                        break
                    }
                }
            }

            if (valid) {

                // Update the data version number
                dataVersion.value = '1.1'
                if (!dataVersion.saveThis()) valid = false
            }

            if (!valid) status.setRollbackOnly()
        }

        return valid
    }

    static upgradeTo_1_2(dataVersion, to, servletContext) {

        // Just need to import the new danish message file
        importMessageFile(servletContext, 'messages', new Locale('da'))

        // Update the data version number
        dataVersion.value = '1.2'
        return dataVersion.saveThis()
    }

    static upgradeTo_1_3(dataVersion, to, servletContext) {

        // Import the rest message file
        importMessageFile(servletContext, 'rest')

        // Update relevant page helps
        setPageHelp(servletContext, 'companyUser.list')
        setPageHelp(servletContext, 'agentCredential')

        // Update the data version number
        dataVersion.value = '1.3'
        return dataVersion.saveThis()
    }

    // Imports a message file to the database. DOES NOT modify existing
    // records. The name should not include any locale suffix, the optional
    // locale parameter handles this.
    static importMessageFile(servletContext, name, locale = null) {
        def dir
        if (Environment.current == Environment.PRODUCTION) {
            dir = new File(new File(servletContext.getRealPath('/')), "WEB-INF${File.separator}grails-app${File.separator}i18n")
        } else {
            dir = new File(new File(servletContext.getRealPath('/')).getParent(), "grails-app${File.separator}i18n")
        }

        if (dir.exists() && dir.canRead()) {
            if (locale?.getLanguage()) {
                name = name + '_' + locale.getLanguage()
                if (locale.getCountry()) name = name + '_' + locale.getCountry()
            }

            def file = new File(dir, name + '.properties')
            if (file.isFile() && file.canRead()) DatabaseMessageSource.loadPropertyFile(file, locale)
        }
    }

    // Updates a page help in the database, creating it if necessary.
    // The name should not include any locale suffix, the optional locale
    // parameter handles this.
    static setPageHelp(servletContext, name, locale = null) {
        def dir = new File(servletContext.getRealPath('/pagehelp'))
        if (dir.exists() && dir.canRead()) {
            def key = name
            def loc = locale ? locale.getLanguage() + locale.getCountry() : '*'
            if (locale?.getLanguage()) {
                name = name + '_' + locale.getLanguage()
                if (locale.getCountry()) name = name + '_' + locale.getCountry()
            }

            def file = new File(dir, name + '.helptext')
            if (file.isFile() && file.canRead()) {
                def reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), 'UTF-8'))
                def text = null
                try {
                    def line = reader.readLine()
                    while (line != null) {
                        if (text == null) {
                            text = line
                        } else {
                            text = text + '\n' + line
                        }

                        line = reader.readLine()
                    }
                } finally {
                    if (reader) reader.close()
                }

                if (key.length() <= 250 && text.length() <= 8000) {
                    def rec = SystemPageHelp.findByCodeAndLocale(key, loc) ?: new SystemPageHelp(code: key, locale: loc)
                    rec.text = text
                    rec.saveThis()
                }
            }
        }
    }

    static createAccountType(map) {
        if (new SystemAccountType(map).saveThis()) {
            if (new SystemMessage(code: "systemAccountType.name.${map.code}", locale: '*', text: map.name).saveThis()) return true
        }

        return false
    }
}
