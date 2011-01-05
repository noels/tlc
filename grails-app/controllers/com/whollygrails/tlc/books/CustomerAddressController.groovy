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

import com.whollygrails.tlc.sys.SystemAddressFormat
import com.whollygrails.tlc.sys.SystemCountry
import com.whollygrails.tlc.sys.SystemCustomerAddressType

class CustomerAddressController {

    // Injected services
    def utilService
    def bookService
    def addressService

    // Security settings
    def activities = [default: 'aradmin']

    // List of actions with specific request types
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST', initializing: 'POST']

    def index = { redirect(action: list, params: params) }

    def list = {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), utilService.setting('pagination.max', 50)) : utilService.setting('pagination.default', 20)
        params.sort = 'id'
        def ddSource = utilService.source('customer.list')
        def customerAddressInstanceList = []
        def customerAddressInstanceTotal = 0
        def customerAddressLines = []
        if (bookService.hasCustomerAccess(ddSource) && !addressService.getDummyAddress(ddSource)) {
            customerAddressInstanceList = CustomerAddress.selectList(securityCode: utilService.currentCompany().securityCode)
            customerAddressInstanceTotal = CustomerAddress.selectCount()
            def sendingCountry = utilService.currentCompany().country
            for (address in customerAddressInstanceList) customerAddressLines << addressService.formatAddress(address, null, null, sendingCountry)
        }

        [customerAddressInstanceList: customerAddressInstanceList, customerAddressInstanceTotal: customerAddressInstanceTotal, ddSource: ddSource, customerAddressLines: customerAddressLines]
    }

    def show = {
        def customerAddressInstance = CustomerAddress.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!bookService.hasCustomerAccess(customerAddressInstance?.customer)) {
            flash.message = 'customerAddress.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Address not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [customerAddressInstance: customerAddressInstance,
                    customerAddressLines: addressService.getAsLineMaps(customerAddressInstance, null, null, utilService.currentCompany().country)]
        }
    }

    def delete = {
        def customerAddressInstance = CustomerAddress.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (bookService.hasCustomerAccess(customerAddressInstance?.customer)) {
            try {
                if (customerAddressInstance.addressUsages) {
                    flash.message = 'customerAddress.bad.delete'
                    flash.args = [customerAddressInstance.toString()]
                    flash.defaultMessage = "You cannot delete Customer Address ${customerAddressInstance.toString()} until you have re-assigned its usages"
                    redirect(action: show, id: params.id)
                } else {
                    customerAddressInstance.delete(flush: true)
                    flash.message = 'customerAddress.deleted'
                    flash.args = [customerAddressInstance.toString()]
                    flash.defaultMessage = "Customer Address ${customerAddressInstance.toString()} deleted"
                    redirect(action: list)
                }
            } catch (Exception e) {
                flash.message = 'customerAddress.not.deleted'
                flash.args = [customerAddressInstance.toString(), e.class.simpleName]
                flash.defaultMessage = "Customer Address ${customerAddressInstance.toString()} could not be deleted (${e.class.simpleName})"
                redirect(action: show, id: params.id)
            }
        } else {
            flash.message = 'customerAddress.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Address not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def edit = {
        def customerAddressInstance = CustomerAddress.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        if (!bookService.hasCustomerAccess(customerAddressInstance?.customer)) {
            flash.message = 'customerAddress.not.found'
            flash.args = [params.id]
            flash.defaultMessage = "Customer Address not found with id ${params.id}"
            redirect(action: list)
        } else {
            return [customerAddressInstance: customerAddressInstance,
                    customerAddressLines: addressService.getAsLineMaps(customerAddressInstance),
                    transferList: createTransferList(customerAddressInstance)]
        }
    }

    def update = {
        def ddSource = utilService.reSource('customer.list')
        if (params.modified) {
            def modified = processModification(ddSource, params)
            if (modified) {
                render(view: 'edit', model: [customerAddressInstance: loadTransfers(modified, params),
                        customerAddressLines: addressService.getAsLineMaps(modified),
                        transferList: createTransferList(modified)])
            } else {
                redirect(action: list)
            }
        } else {
            def customerAddressInstance = CustomerAddress.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
            if (bookService.hasCustomerAccess(customerAddressInstance?.customer)) {
                if (params.version) {
                    def version = params.version.toLong()
                    if (customerAddressInstance.version > version) {
                        customerAddressInstance.errors.rejectValue('version', 'customerAddress.optimistic.locking.failure', 'Another user has updated this Customer Address while you were editing')
                        render(view: 'edit', model: [customerAddressInstance: loadTransfers(customerAddressInstance, params),
                                customerAddressLines: addressService.getAsLineMaps(customerAddressInstance),
                                transferList: createTransferList(customerAddressInstance)])
                        return
                    }
                }

                customerAddressInstance.properties['country', 'format', 'location1', 'location2', 'location3', 'metro1', 'metro2', 'area1', 'area2', 'encoding'] = params
                def valid = addressService.validate(loadTransfers(customerAddressInstance, params))
                if (valid) {
                    def usage
                    CustomerAddress.withTransaction {status ->
                        for (trf in customerAddressInstance.usageTransfers) {
                            usage = CustomerAddressUsage.findByCustomerAndType(customerAddressInstance.customer, trf)
                            if (usage && usage.address.id != customerAddressInstance.id) usage.delete()
                            customerAddressInstance.addToAddressUsages(new CustomerAddressUsage(customer: customerAddressInstance.customer, type: trf))
                        }

                        if (!customerAddressInstance.save(flush: true)) {
                            status.setRollbackOnly()
                            valid = false
                        }
                    }
                }

                if (valid) {
                    flash.message = 'customerAddress.updated'
                    flash.args = [customerAddressInstance.toString()]
                    flash.defaultMessage = "Customer Address ${customerAddressInstance.toString()} updated"
                    redirect(action: show, id: customerAddressInstance.id)
                } else {
                    render(view: 'edit', model: [customerAddressInstance: customerAddressInstance,
                            customerAddressLines: addressService.getAsLineMaps(customerAddressInstance),
                            transferList: createTransferList(customerAddressInstance)])
                }
            } else {
                flash.message = 'customerAddress.not.found'
                flash.args = [params.id]
                flash.defaultMessage = "Customer Address not found with id ${params.id}"
                redirect(action: list)
            }
        }
    }

    def create = {
        def ddSource = utilService.reSource('customer.list')
        if (bookService.hasCustomerAccess(ddSource)) {
            def customerAddressInstance = addressService.getDummyAddress(ddSource)
            if (!customerAddressInstance) {
                customerAddressInstance = new CustomerAddress()
                customerAddressInstance.customer = ddSource   // Ensure correct parent
                customerAddressInstance.country = ddSource.country
                customerAddressInstance.format = ddSource.country.addressFormat
            }

            return [customerAddressInstance: customerAddressInstance,
                    customerAddressLines: addressService.getAsLineMaps(customerAddressInstance),
                    transferList: createTransferList(customerAddressInstance)]
        } else {
            redirect(action: list)
        }
    }

    def save = {
        def ddSource = utilService.reSource('customer.list')
        if (params.modified) {
            def modified = processModification(ddSource, params)
            if (modified) {
                render(view: 'create', model: [customerAddressInstance: loadTransfers(modified, params),
                        customerAddressLines: addressService.getAsLineMaps(modified),
                        transferList: createTransferList(modified)])
            } else {
                redirect(action: list)
            }
        } else {
            if (bookService.hasCustomerAccess(ddSource)) {
                def customerAddressInstance = addressService.getDummyAddress(ddSource)
                if (!customerAddressInstance) {
                    customerAddressInstance = new CustomerAddress()
                    customerAddressInstance.customer = ddSource   // Ensure correct parent
                }

                customerAddressInstance.properties['country', 'format', 'location1', 'location2', 'location3', 'metro1', 'metro2', 'area1', 'area2', 'encoding'] = params
                def valid = addressService.validate(loadTransfers(customerAddressInstance, params))
                if (valid) {
                    def usage
                    CustomerAddress.withTransaction {status ->
                        for (trf in customerAddressInstance.usageTransfers) {
                            usage = CustomerAddressUsage.findByCustomerAndType(customerAddressInstance.customer, trf)
                            if (usage && usage.address.id != customerAddressInstance.id) usage.delete()
                            customerAddressInstance.addToAddressUsages(new CustomerAddressUsage(customer: customerAddressInstance.customer, type: trf))
                        }

                        if (!customerAddressInstance.save(flush: true)) {
                            status.setRollbackOnly()
                            valid = false
                        }
                    }
                }

                if (valid) {
                    flash.message = 'customerAddress.created'
                    flash.args = [customerAddressInstance.toString()]
                    flash.defaultMessage = "Customer Address ${customerAddressInstance.toString()} created"
                    redirect(action: show, id: customerAddressInstance.id)
                } else {
                    render(view: 'create', model: [customerAddressInstance: customerAddressInstance,
                            customerAddressLines: addressService.getAsLineMaps(customerAddressInstance),
                            transferList: createTransferList(customerAddressInstance)])
                }
            } else {
                redirect(action: list)
            }
        }
    }

    def initial = {
        def customer = Customer.get(params.id)
        if (bookService.hasCustomerAccess(customer)) {
            def customerAddressInstance = addressService.getDummyAddress(customer)
            if (!customerAddressInstance) {
                customerAddressInstance = new CustomerAddress()
                customerAddressInstance.customer = customer   // Ensure correct parent
                customerAddressInstance.country = customer.country
                customerAddressInstance.format = customer.country.addressFormat
            }

            return [customerAddressInstance: customerAddressInstance,
                    customerAddressLines: addressService.getAsLineMaps(customerAddressInstance),
                    transferList: createTransferList(customerAddressInstance)]
        } else {
            redirect(controller: 'customer', action: 'list')
        }
    }

    def initializing = {
        def customer = Customer.get(params.parent)
        if (params.modified) {
            def modified = processModification(customer, params)
            if (modified) {
                render(view: 'initial', model: [customerAddressInstance: modified, customerAddressLines: addressService.getAsLineMaps(modified), transferList: null])
            } else {
                redirect(controller: 'customer', action: 'list')
            }
        } else {
            if (bookService.hasCustomerAccess(customer)) {
                def customerAddressInstance = addressService.getDummyAddress(customer)
                if (!customerAddressInstance) {
                    customerAddressInstance = new CustomerAddress()
                    customerAddressInstance.customer = customer   // Ensure correct parent
                }

                customerAddressInstance.properties['country', 'format', 'location1', 'location2', 'location3', 'metro1', 'metro2', 'area1', 'area2', 'encoding'] = params
                if (addressService.validate(customerAddressInstance) && customerAddressInstance.saveThis()) {
                    flash.message = 'customerAddress.created'
                    flash.args = [customerAddressInstance.toString()]
                    flash.defaultMessage = "Customer Address ${customerAddressInstance.toString()} created"
                    redirect(controller: 'customer', action: 'show', id: customer.id)
                } else {
                    render(view: 'initial', model: [customerAddressInstance: customerAddressInstance,
                            customerAddressLines: addressService.getAsLineMaps(customerAddressInstance),
                            transferList: null])
                }
            } else {
                redirect(controller: 'customer', action: 'list')
            }
        }
    }

// --------------------------------------------- Support Methods ---------------------------------------------

    private processModification(customer, params) {
        def customerAddressInstance, temp
        if (params.id) {
            customerAddressInstance = CustomerAddress.findByIdAndSecurityCode(params.id, utilService.currentCompany().securityCode)
        } else {
            customerAddressInstance = new CustomerAddress()
            customerAddressInstance.customer = customer
            customerAddressInstance.country = customer.country
            customerAddressInstance.format = customer.country.addressFormat
        }

        if (bookService.hasCustomerAccess(customerAddressInstance?.customer)) {
            customerAddressInstance.properties['location1', 'location2', 'location3', 'metro1', 'metro2', 'area1', 'area2', 'encoding'] = params
            if (params.modified == 'country') {
                temp = SystemCountry.get(params.country.id)
                if (temp) {
                    customerAddressInstance.country = temp
                    customerAddressInstance.format = temp.addressFormat
                }
            } else {    // Format
                temp = SystemAddressFormat.get(params.format.id)
                if (temp) customerAddressInstance.format = temp
            }
        } else {
            customerAddressInstance = null
        }

        // Don't want Grails to automatically save it
        if (customerAddressInstance?.id) customerAddressInstance.discard()
        return customerAddressInstance
    }

    private createTransferList(address) {
        def types = SystemCustomerAddressType.list()
        if (address.id) {
            def usages = CustomerAddressUsage.findAllByAddress(address)
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

    private loadTransfers(address, params) {
        if (params.transfers) {
            address.usageTransfers = []
            def transfers = (params.transfers instanceof String) ? [params.transfers] : params.transfers
            for (transfer in transfers) address.usageTransfers << SystemCustomerAddressType.get(transfer)
        }

        return address
    }
}