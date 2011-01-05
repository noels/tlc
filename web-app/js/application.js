//  Copyright 2010 Wholly Grails.
//
//  This file is part of the Three Ledger Core (TLC) software
//  from Wholly Grails.
//
//  TLC is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  TLC is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with TLC.  If not, see <http://www.gnu.org/licenses/>.
var Ajax;
if (Ajax && (Ajax != null)) {
    Ajax.Responders.register({
        onCreate: function() {
            if ($('spinner') && Ajax.activeRequestCount > 0)
                Effect.Appear('spinner', {duration:0.5,queue:'end'});
        },
        onComplete: function() {
            if ($('spinner') && Ajax.activeRequestCount == 0)
                Effect.Fade('spinner', {duration:0.5,queue:'end'});
        }
    });
}

// ++++++++++++++++ Generic methods ++++++++++++++++

// Set any specially tagged page display attribute and set initial form field focus, as required
function bodyLoaded() {
    var metaArray = document.getElementsByName('bodyClass');
    if (metaArray.length > 0) {
        document.body.className = metaArray[0].content;
    }
    var forms = document.forms;
    for (var i = 0; i < forms.length; i++) {
        if (setInitialFocus(forms[i].getElementsByTagName('input'))) break;
        if (setInitialFocus(forms[i].getElementsByTagName('select'))) break;
        if (setInitialFocus(forms[i].getElementsByTagName('textarea'))) break;
    }

    return true;
}

// Gives the focus to a specially tagged field after the page has loaded
function setInitialFocus(elements) {
    for (var i = 0; i < elements.length; i++) {
        if (elements[i].getAttribute('initialField') == 'true') {
            elements[i].focus();
            return true;
        }
    }

    return false;
}

// Pop up page help
function openPageHelp(loc) {
    var width = 400;
    var height = 400;
    var x = Math.max((screen.width - width) / 2, 0);
    var y = Math.max((screen.height - height) / 2, 0);
    var ph = window.open(loc, 'pagehelp', 'width=' + width + ',height=' + height + ',status=no,toolbar=no,location=no,menubar=no,directories=no,resizable=yes,scrollbars=yes,titlebar=no');
    ph.moveTo(x, y);
}

// Select a document to allocate to
function allocationSelect(docType, docCode) {
    if (docType > 0 && docCode > '') {
        var type = document.getElementById('targetType.id');
        var code = document.getElementById('targetCode');
        if (type != null && code != null) {
            type.value = docType;
            code.value = docCode;
        }
    }
}

// ++++++++++++++++ Ajax Processing ++++++++++++++++

var ajaxResponse = 'Unable to understand the response from the server';
var ajaxTimeout = 'Operation timed out waiting for a response from the server';
var timeoutMillis = 10000;
var typeModified = false;
var accountModified = false;
var lineNumber = '';

// Display or clear an ajax error message
function setAjaxErrorMessage(message) {
    var div = document.getElementById('ajaxErrorMessage');
    if (div != null) {
        if (message != null && message.length > 0) {
            div.innerHTML = '<ul><li>' + h(message) + '</li></ul>';
            div.style.visibility = 'visible';
        } else {
            div.innerHTML = '';
            div.style.visibility = 'hidden';
        }
    }
}

// HTML encode some text
function h(text) {
    var txt = '';
    if (text != null) {
        txt = txt + text;
        txt = txt.replace(/&/, '&amp;');
        txt = txt.replace(/</, '&lt;');
        txt = txt.replace(/>/, '&gt;');
    }

    return(txt);
}

// Set a 'document type changed' flag
function typeChanged() {
    typeModified = true;
}

// Set an 'account changed' flag
function accountChanged() {
    accountModified = true;
}

// Gets the index of a field with an id in the format 'name[nnn]'
function getFieldIndex(field) {
    var fieldId = field.id;
    var start = fieldId.indexOf('[') + 1;
    var end = fieldId.indexOf(']', start + 1);
    return fieldId.substring(start, end);
}

// Generic ajax error handling
var handleFailure = function(obj) {
    document.body.style.cursor = 'default';
    var msg = document.getElementById('timeoutMessage');
    if (msg != null && msg.value > '') {
        msg = msg.value;
    } else {
        msg = ajaxTimeout;
    }

    setAjaxErrorMessage(msg);
};

// Display the invalid response message
function setResponseMessage() {
    var msg = document.getElementById('responseMessage');
    if (msg != null && msg.value > '') {
        msg = msg.value;
    } else {
        msg = ajaxResponse;
    }

    setAjaxErrorMessage(msg);
}

// Update the display for customer or supplier retrieval
var handleLedgerSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            document.getElementById('sourceCode').value = h(result.sourceCode);
            document.getElementById('sourceName').value = h(result.sourceName);
            var td = document.getElementById('currency.id');
            for (var i = 0; i < td.options.length; i++) {
                if (td.options[i].value == result.currencyId) {
                    td.selectedIndex = i;
                    break;
                }
            }
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Get customer or supplier details
function getLedger(field, url) {
    document.body.style.cursor = 'wait';
    var ledgerCallbacks = {
        success: handleLedgerSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    var requestData = 'sourceCode=' + encodeURIComponent(field.value);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, ledgerCallbacks, requestData);
    return true;
}

// Handle the change of a document date
var handlePeriodSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.periodId > 0) {
            if (result.dueDate > '') document.getElementById('dueDate').value = result.dueDate;
            var td = document.getElementById('period.id');
            for (var i = 0; i < td.options.length; i++) {
                if (td.options[i].value == result.periodId) {
                    td.selectedIndex = i;
                    break;
                }
            }
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Get the period associated with a changed document date
function getPeriod(field, url, type, adjustment) {
    document.body.style.cursor = 'wait';
    var periodCallbacks = {
        success: handlePeriodSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    var requestData = 'documentDate=' + encodeURIComponent(field.value) + '&type=' + encodeURIComponent(document.getElementById('type.id').value);
    if (type > '') {
        if (type == 'common') {
            requestData = requestData + '&common=true';
        } else {
            requestData = requestData + '&' + type + '=' + encodeURIComponent(document.getElementById('sourceCode').value);
        }
    }
    if (adjustment != null) requestData = requestData + '&adjustment=' + encodeURIComponent(adjustment);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, periodCallbacks, requestData);
    return true;
}

// Update the document with the next document code number, if required, and enable/disable code field editing
var handleCodeSuccess = function(obj) {
    typeModified = false;
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            if (result.allowEdit == true) {
                document.getElementById('code').disabled = false;
                document.getElementById('code').focus();
            } else {
                document.getElementById('code').disabled = true;
                if (result.nextField > '') {
                    var nxt = document.getElementById(result.nextField);
                    if (nxt != null) nxt.focus();
                }
            }
            if (result.sourceNumber > '') {
                document.getElementById('code').value = h(result.sourceNumber);
                document.getElementById('sourceNumber').value = h(result.sourceNumber);
            }
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Get the next document code number
function getCode(field, url, nextField) {
    if (typeModified) {
        document.body.style.cursor = 'wait';
        var codeCallbacks = {
            success: handleCodeSuccess,
            failure: handleFailure,
            timeout: timeoutMillis
        };
        var requestData = 'typeId=' + encodeURIComponent(field.value) + '&nextField=' + encodeURIComponent(nextField);
        var request = YAHOO.util.Connect.asyncRequest('POST', url, codeCallbacks, requestData);
    }

    return true;
}

// Update a line with the GL account details
var handleAccountSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            document.getElementById('lines[' + lineNumber + '].accountCode').value = h(result.accountCode);
            document.getElementById('lines[' + lineNumber + '].accountName').value = h(result.accountName);
            document.getElementById('lines[' + lineNumber + '].displayName').value = h(result.accountName);
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Get GL account details
function getAccount(field, url, metaType) {
    document.body.style.cursor = 'wait';
    var accountCallbacks = {
        success: handleAccountSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    lineNumber = getFieldIndex(field);
    var requestData = 'accountCode=' + encodeURIComponent(field.value) + '&metaType=' + encodeURIComponent(metaType);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, accountCallbacks, requestData);

    return true;
}

// Get a GL, AR or AP account's details based on the type parameter if supplied OR the setting of an account type selection list if not
function setAccount(field, url, metaType, type) {
    document.body.style.cursor = 'wait';
    var accountCallbacks = {
        success: handleAccountSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    lineNumber = getFieldIndex(field);
    var code = document.getElementById('lines[' + lineNumber + '].accountCode').value;
    var accountType = (type > '') ? type : document.getElementById('lines[' + lineNumber + '].accountType').value;
    var requestData = 'accountCode=' + encodeURIComponent(code) + '&metaType=' + encodeURIComponent(metaType) + '&accountType=' + encodeURIComponent(accountType);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, accountCallbacks, requestData);

    return true;
}

// Set the onHold checkbox for a general transaction line
var handleHoldSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Set the onHold checkbox state
function setHold(field, url) {
    document.body.style.cursor = 'wait';
    var holdCallbacks = {
        success: handleHoldSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    var lineId = getFieldIndex(field);
    var state = field.checked ? 'true' : 'false';
    var requestData = 'lineId=' + encodeURIComponent(lineId) + '&newState=' + encodeURIComponent(state);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, holdCallbacks, requestData);

    return true;
}

// Handle the change of a bank or cash account
var handleBankSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            if (result.currencyId > 0) {
                var td = document.getElementById('currency.id');
                for (var i = 0; i < td.options.length; i++) {
                    if (td.options[i].value == result.currencyId) {
                        td.selectedIndex = i;
                        break;
                    }
                }
            }
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Get a bank or cash account depending upon the type parameter
function getBank(field, url, type) {
    if (accountModified) {
        document.body.style.cursor = 'wait';
        var bankCallbacks = {
            success: handleBankSuccess,
            failure: handleFailure,
            timeout: timeoutMillis
        };
        var requestData = 'accountCode=' + encodeURIComponent(field.value) + '&type=' + encodeURIComponent(type);
        var request = YAHOO.util.Connect.asyncRequest('POST', url, bankCallbacks, requestData);
    }

    return true;
}

// Set the reconciled checkbox for a bank reconciliation line or detailed line
var handleReconciledSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            document.getElementById('unrec').innerHTML = result.unreconciledValue;
            document.getElementById('subtot').innerHTML = result.subtotalValue;
            document.getElementById('diff').innerHTML = result.differenceValue;
            document.getElementById('fin').style.visibility = (result.canFinalize == true) ? 'visible' : 'hidden';
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Set the reconciled checkbox state for a bank reconciliation line or detailed line
function setReconciled(field, url) {
    document.body.style.cursor = 'wait';
    var reconciledCallbacks = {
        success: handleReconciledSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    var lineId = getFieldIndex(field);
    var state = field.checked ? 'true' : 'false';
    var requestData = 'lineId=' + encodeURIComponent(lineId) + '&newState=' + encodeURIComponent(state);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, reconciledCallbacks, requestData);

    return true;
}

// Set the new periods on change of a year
var handleYearSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            var target = document.getElementById(result.targetId);
            var pds = result.periods;
            var pd;
            target.size = Math.min(20, pds.length);
            for (var i = 0; i < pds.length; i++) {
                pd = pds[i];
                target.options[i] = new Option(pd.txt, pd.val, false, false);
            }
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Ask the server to get the periods of a year
function changeYear(field, url, target, statusCodes, order) {
    document.body.style.cursor = 'wait';
    var yearCallbacks = {
        success: handleYearSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    document.getElementById(target).options.length = 0;
    var requestData = 'yearId=' + encodeURIComponent(field.value) + '&targetId=' + encodeURIComponent(target);
    if (statusCodes > '') requestData = requestData + '&statusCodes=' + encodeURIComponent(statusCodes);
    if (order > '') requestData = requestData + '&order=' + encodeURIComponent(order);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, yearCallbacks, requestData);

    return true;
}

// Sets a new budget value for a given GL balance record
var handleBudgetSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            document.getElementById(result.balanceId).value = result.budgetValue;
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Sets a new budget value for a given GL balance record
function changeBudget(field, url) {
    document.body.style.cursor = 'wait';
    var budgetCallbacks = {
        success: handleBudgetSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    var requestData = 'balanceId=' + encodeURIComponent(field.id) + '&budgetValue=' + encodeURIComponent(field.value);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, budgetCallbacks, requestData);

    return true;
}

// Update the available chart sections on change of type
var handleSectionTypeSuccess = function(obj) {
    document.body.style.cursor = 'default';
    try {
        var result = YAHOO.lang.JSON.parse(obj.responseText);
        if (result.errorMessage != null) {
            setAjaxErrorMessage(result.errorMessage);
        } else {
            setAjaxErrorMessage('');
            var target = document.getElementById(result.targetId);
            var sections = result.sections;
            var section;
            target.options.length = 0;
            for (var i = 0; i < sections.length; i++) {
                section = sections[i];
                target.options[i] = new Option(section.txt, section.val, false, false);
            }
        }
    } catch (ex) {
        setResponseMessage();
    }
};

// Handle the change of chart section type (ie, bs or both)
function changeSectionType(field, url, target) {
    document.body.style.cursor = 'wait';
    var sectionTypeCallbacks = {
        success: handleSectionTypeSuccess,
        failure: handleFailure,
        timeout: timeoutMillis
    };
    var requestData = 'sectionType=' + encodeURIComponent(field.value) + '&targetId=' + encodeURIComponent(target);
    var request = YAHOO.util.Connect.asyncRequest('POST', url, sectionTypeCallbacks, requestData);

    return true;
}
