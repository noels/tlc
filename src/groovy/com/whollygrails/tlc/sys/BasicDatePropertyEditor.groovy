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

import java.beans.PropertyEditorSupport
import java.text.DateFormat
import java.text.ParseException
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.servlet.support.RequestContextUtils

class BasicDatePropertyEditor extends PropertyEditorSupport {
	private DateFormat dateOnlyFormat
    private DateFormat dateTimeFormat

    public String getAsText() {
        init()
        def value = getValue()
        if (value) value = dateTimeFormat.format(value)
        return value
    }

    public void setAsText(String text) throws IllegalArgumentException {
        init()
        if (text) {
            try {
                setValue(dateTimeFormat.parse(text))
            } catch (ParseException pe1) {
                try {
                    setValue(dateOnlyFormat.parse(text))
                } catch (ParseException pe2) {
                    throw new IllegalArgumentException(pe2)
                }
            }
        } else {
            setValue(null)
        }
    }

    private init() {
        if (dateOnlyFormat == null) {
            Locale locale = RequestContextUtils.getLocale(RequestContextHolder.currentRequestAttributes().getCurrentRequest())
            dateOnlyFormat = DateFormat.getDateInstance(DateFormat.SHORT, locale)
            dateTimeFormat = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, locale)
            dateOnlyFormat.setLenient(false)
            dateTimeFormat.setLenient(false)
        }
    }
}

