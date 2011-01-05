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
package com.whollygrails.tlc.books

import com.whollygrails.tlc.sys.SystemCustomerContactType

class CustomerContactController {

    // Injected services
    def utilService
    def bookService
    def addressService

    // Security settings
    def activities = [default: 'aradmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = ['name', 'identifier'].contains(params.sort) ? params.sort : 'name'
        def ddSource = utilService.source('customerAddress.list')
        def customerContactInstanceList = []
        def customerContactInstanceTotal = 0
        def customerAddressLines = []
        if (bookService.hasCustomerAccess(ddSource?.customer)) {
            customerContactInstanceList = CustomerContact.selectList(securityCode: utilService.currentCompany().securityCode)
            customerContactInstanceTotal = CustomerContact.selectCount()
            customerAddressLines = addressService.formatAddress(ddSource, ddSource.customer, null, ddSource.customer.country)
        }

        [customerContactInstanceList: customerContactInstanceList, customerContactInstanceTotal: customerContactInstanceTotal, ddSource: ddSource, customerAddressLines: customerAddressLines]
    }

    def show = {
        def customerContactInstance = CustomerContact.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!bookService.hasCustomerAccess(customerContactInstance?.address?.customer)) {
            flash.message = 'customerContact.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [customerContactInstance: customerContactInstance]
        }
    }

    def delete = {
        def customerContactInstance = CustomerContact.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (bookService.hasCustomerAccess(customerContactInstance?.address?.customer)) {
            try {
                customerContactInstance.delete(flush: true)
                flash.message = 'customerContact.deleted'
                flash.args = [customerContactInstance.toString()]
                flash.defaultMessage = "Customer Contact ${customerContactInstance.toString()} deleted"
                redirect(action: list)
            } catch (Exception e) {
                flash.message = 'customerContact.not.deleted'
                flash.args = [customerContactInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Customer Contact ${customerContactInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'customerContact.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def customerContactInstance = CustomerContact.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!bookService.hasCustomerAccess(customerContactInstance?.address?.customer)) {
            flash.message = 'customerContact.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [customerContactInstance: customerContactInstance, transferList: createTransferList(customerContactInstance)]
        }
    }

    def update = {
        def customerContactInstance = CustomerContact.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (bookService.hasCustomerAccess(customerContactInstance?.address?.customer)) {
            if (params.version) {
                def version = params.version.toLong()
                if (customerContactInstance.version > version) {
                    customerContactInstance.errors.rejectValue('version', 'customerContact.optimistic.locking.failure', 'Another user has updated this Customer Contact while you were editing')
                    render(view: 'edit', model: [customerContactInstance: loadTransfers(customerContactInstance, params), transferList: createTransferList(customerContactInstance)])
                    return
                }
            }

            customerContactInstance.properties['name', 'identifier'] = params
            loadTransfers(customerContactInstance, params)
            def valid = (!customerContactInstance.hasErrors() && customerContactInstance.validate())
            if (valid) {
                def usage
                CustomerContact.withTransaction {status ->
                    for (trf in customerContactInstance.usageTransfers) {
                        usage = CustomerContactUsage.findByAddressAndType(customerContactInstance.address, trf)
                        if (usage && usage.contact.id != customerContactInstance.id) usage.delete()
                        customerContactInstance.addToUsages(new CustomerContactUsage(address: customerContactInstance.address, type: trf))
                    }

                    if (!customerContactInstance.save(flush: true)) {
                        status.setRollbackOnly()
                        valid = false
                    }
                }
            }

            if (valid) {
                flash.message = 'customerContact.updated'
                flash.args = [customerContactInstance.toString()]
                flash.defaultMessage = "Customer Contact ${customerContactInstance.toString()} updated"
                redirect(action: show, id: customerContactInstance.id)
            } else {
                render(view: 'edit', model: [customerContactInstance: customerContactInstance, transferList: createTransferList(customerContactInstance)])
            }
        } else {
            flash.message = 'customerContact.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Contact not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def create = {
        def ddSource = utilService.reSource('customerAddress.list')
        if (bookService.hasCustomerAccess(ddSource?.customer)) {
            def customerContactInstance = new CustomerContact()
            customerContactInstance.address = ddSource
            return [customerContactInstance: customerContactInstance, transferList: createTransferList(customerContactInstance)]
        } else {
            redirect(action: list)

        }
    }

    def save = {
        def ddSource = utilService.reSource('customerAddress.list')
        if (bookService.hasCustomerAccess(ddSource?.customer)) {
            def customerContactInstance = new CustomerContact()
            customerContactInstance.properties['name', 'identifier'] = params
            customerContactInstance.address = ddSource
            loadTransfers(customerContactInstance, params)
            def valid = (!customerContactInstance.hasErrors() && customerContactInstance.validate())
            if (valid) {
                def usage
                CustomerContact.withTransaction {status ->
                    for (trf in customerContactInstance.usageTransfers) {
                        usage = CustomerContactUsage.findByAddressAndType(customerContactInstance.address, trf)
                        if (usage && usage.contact.id != customerContactInstance.id) usage.delete()
                        customerContactInstance.addToUsages(new CustomerContactUsage(address: customerContactInstance.address, type: trf))
                    }

                    if (!customerContactInstance.save(flush: true)) {
                        status.setRollbackOnly()
                        valid = false
                    }
                }
            }

            if (valid) {
                flash.message = 'customerContact.created'
                flash.args = [customerContactInstance.toString()]
                flash.defaultMessage = "Customer Contact ${customerContactInstance.toString()} created"
                redirect(action: show, id: customerContactInstance.id)
            } else {
                render(view: 'create', model: [customerContactInstance: customerContactInstance, transferList: createTransferList(customerContactInstance)])
            }
        } else {
            redirect(action: list)
        }
    }

// --------------------------------------------- Support Methods ---------------------------------------------

    private createTransferList(contact) {
        def types = SystemCustomerContactType.list()
        if (contact.id) {
            def usages = CustomerContactUsage.findAllByContact(contact)
            for (usage in usages) {
                for (int i = 0; i < types.size(); i++) {
                    if (types[i].id == usage.type.id) {
                        types.remove(i)
                        break
                    }
                }
            }
        }

        return types
    }

    private loadTransfers(contact, params) {
        if (params.transfers) {
            contact.usageTransfers = []
            def transfers = (params.transfers instanceof String) ? [params.transfers] : params.transfers
            for (transfer in transfers) contact.usageTransfers << SystemCustomerContactType.get(transfer)
        }

        return contact
    }
}