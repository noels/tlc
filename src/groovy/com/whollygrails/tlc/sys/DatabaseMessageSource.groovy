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

import com.whollygrails.tlc.corp.Message
import grails.util.GrailsWebUtil
import java.text.MessageFormat
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import org.hibernate.SessionFactory
import org.springframework.context.ResourceLoaderAware
import org.springframework.context.support.AbstractMessageSource
import org.springframework.core.io.ResourceLoader
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.support.WebApplicationContextUtils
import org.springframework.web.servlet.support.RequestContextUtils

public class DatabaseMessageSource extends AbstractMessageSource implements ResourceLoaderAware {

    private static final String CACHE_CODE = 'message'
    private static UtilService utilService
    private static SessionFactory sessionFactory
    private ResourceLoader resourceLoader = null

    @Override
    protected MessageFormat resolveCode(String code, Locale locale) {
        String msg = getBaseText(code, locale)
        return (msg != null) ? new MessageFormat(msg, locale) : null
    }

    @Override
    protected String resolveCodeWithoutArguments(String code, Locale locale) {
        return getBaseText(code, locale)
    }

    // Used by Spring to inject our util service
    public void setUtilService(UtilService utilService) {
        this.utilService = utilService
    }

    // Used by Spring to inject the Hibernate session factory
    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory
    }

    public void setResourceLoader(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader
    }

    // Used by the two main 'resolve code' methods above plus the two methods
    // below: getMessageText and setError
    private String getBaseText(String code, Locale locale, Long securityCode = null) {

        def cache = utilService.cacheService
        if (securityCode == null) {
            def unbindRequest = false
            if (!RequestContextHolder.getRequestAttributes()) {
                def applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(ServletContextHolder.getServletContext())
                GrailsWebUtil.bindMockWebRequest(applicationContext)
                unbindRequest = true
            }

            securityCode = utilService.currentCompany()?.securityCode ?: 0L
            if (unbindRequest) RequestContextHolder.setRequestAttributes(null)
        }

        def key = code + cache.IMPOSSIBLE_VALUE + locale.getLanguage() + locale.getCountry()
        def msg = cache.get(CACHE_CODE, securityCode, key, (securityCode == 0L))

        // If we didn't find the message and it was a search for a specific
        // company, then try a 'system' level search of the cache
        if (!msg && securityCode > 0L) msg = cache.get(CACHE_CODE, 0L, key)

        if (!msg) {
            if (securityCode > 0) {
                def lst = Message.findAll(
                        "from Message as x where x.securityCode = ? and x.code = ? and x.locale in ('*', ?, ?) order by x.relevance desc",
                        [securityCode, code, locale.getLanguage(), locale.getLanguage() + locale.getCountry()], [max: 1])
                if (lst) msg = lst[0].text
            }

            if (!msg) {
                def lst = SystemMessage.findAll(
                        "from SystemMessage as x where x.code = ? and x.locale in ('*', ?, ?) order by x.relevance desc",
                        [code, locale.getLanguage(), locale.getLanguage() + locale.getCountry()], [max: 1])
                msg = lst.size() ? lst[0].text : cache.IMPOSSIBLE_VALUE
            }

            cache.put(CACHE_CODE, securityCode, key, msg)
        }

        return (msg == cache.IMPOSSIBLE_VALUE) ? null : msg
    }

    def getMessageText(Map parameters) {

        def unbindRequest = false
        Locale locale = parameters.locale
        if (!locale) {
            if (RequestContextHolder.getRequestAttributes()) {
                locale = utilService.currentLocale()
            } else {    // Outside of an executing request, establish a mock version
                def applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(ServletContextHolder.getServletContext())
                def requestAttributes = GrailsWebUtil.bindMockWebRequest(applicationContext)
                unbindRequest = true
                locale = RequestContextUtils.getLocale(requestAttributes.request)
            }
        }

        def msg = getBaseText(parameters.code, locale, parameters.securityCode)
        if (msg) {
            if (parameters.args) msg = new MessageFormat(msg, locale).format(parameters.args as Object[])
        } else {
            msg = parameters.default
        }

        if (unbindRequest) RequestContextHolder.setRequestAttributes(null)
        if (msg && parameters.encodeAs) {
            switch (parameters.encodeAs.toLowerCase()) {
                case 'html':
                    msg = msg.encodeAsHTML()
                    break

                case 'xml':
                    msg = msg.encodeAsXML()
                    break

                case 'url':
                    msg = msg.encodeAsURL()
                    break

                case 'javascript':
                    msg = msg.encodeAsJavaScript()
                    break

                case 'base64':
                    msg = msg.encodeAsBase64()
                    break
            }
        }

        return msg
    }

    def setError(domain, parameters) {
        def msg = getMessageText(parameters)
        if (parameters.field) {
            domain.errors.rejectValue(parameters.field, null, msg)
        } else {
            domain.errors.reject(null, msg)
        }

        // If they didn't specify eviction and the domain id is for an existing record (i.e. id > 0),
        // OR if they specifically set evict to true, then remove the domain object from the Hibernate cache
        if ((parameters.evict == null && domain.id) || parameters.evict == true) sessionFactory.currentSession.evict(domain)

        return msg
    }

    static loadPropertyFile(file, locale, company = null) {
        def loc = locale ? locale.getLanguage() + locale.getCountry() : '*'
        def props = new Properties()
        def reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), 'UTF-8'))
        try {
            props.load(reader)
        } finally {
            if (reader) reader.close()
        }

        def rec, txt
        def counts = [imported: 0, skipped: 0]
        props.stringPropertyNames().each {key ->
            txt = props.getProperty(key)
            if (key && key.length() <= 250 && txt && txt.length() <= 2000) {
                if (company) {
                    rec = Message.find('from Message as x where x.company = ? and x.code = ? and x.locale = ?', [company, key, loc])
                } else {
                    rec = SystemMessage.findByCodeAndLocale(key, loc)
                }

                if (!rec) {
                    if (company) {
                        rec = new Message()
                        rec.company = company
                    } else {
                        rec = new SystemMessage()
                    }

                    rec.code = key
                    rec.locale = loc
                    rec.text = txt
                    rec.saveThis()
                    counts.imported = counts.imported + 1
                } else {
                    counts.skipped = counts.skipped + 1
                }
            } else {
                counts.skipped = counts.skipped + 1
            }
        }

        return counts
    }

    static loadPageHelpFile(file, locale, key) {
        def loc = locale ? locale.getLanguage() + locale.getCountry() : '*'
        def reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), 'UTF-8'))
        def text = null
        try {
            def line = reader.readLine()
            while (line != null) {
                if (text == null)  {
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
            def rec = SystemPageHelp.findByCodeAndLocale(key, loc)
            if (!rec) {
                rec = new SystemPageHelp()
                rec.code = key
                rec.locale = loc
                rec.text = text
                return rec.saveThis()
            }
        }

        return false
    }
}
