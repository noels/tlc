package com.whollygrails.tlc.sys

import grails.util.GrailsWebUtil
import javax.mail.internet.MimeMessage
import javax.servlet.http.HttpServletRequest
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.codehaus.groovy.grails.commons.GrailsResourceUtils
import org.codehaus.groovy.grails.plugins.PluginManagerHolder
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import org.codehaus.groovy.grails.web.servlet.DefaultGrailsApplicationAttributes
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.support.WebApplicationContextUtils

/*
 * Copyright 2004-2005 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
class MailMessageBuilder {
    static PATH_TO_MAIL_VIEWS = "/WEB-INF/grails-app/views"
    static HTML_CONTENT_TYPES = ['text/html', 'text/xhtml']

    private mailSender
    private templateEngine
    private MimeMessageHelper messageHelper

    String[] msgTo
    String[] msgCc
    String[] msgBcc
    String msgFrom
    String msgReplyTo
    String msgSubject
    String msgText
    def msgAttachments = []
    Date msgDateSent

    MailMessageBuilder(sender, engine) {
        mailSender = sender
        templateEngine = engine
    }

    MimeMessage getMessage() {
        return getMessageHelper().getMimeMessage()
    }

    private MimeMessageHelper getMessageHelper() {
        if (!messageHelper) {
            messageHelper = new MimeMessageHelper(mailSender.createMimeMessage(), true, 'UTF-8')
            msgFrom = ConfigurationHolder.config.grails.mail.username
            msgDateSent = new Date()
            messageHelper.setFrom(msgFrom)
            messageHelper.setSentDate(msgDateSent)
        }

        return messageHelper
    }

    void to(String recip) {
        if (recip) {
            msgTo = [recip] as String[]
            getMessageHelper().setTo(msgTo)
        }
    }

    void to(Object[] args) {
        if (args) {
            msgTo = args as String[]
            getMessageHelper().setTo(msgTo)
        }
    }

    void title(title) {
        subject(title)
    }

    void subject(title) {
        msgSubject = title?.toString()
        getMessageHelper().setSubject(msgSubject)
    }

    void body(body) {
        text(body)
    }

    void body(Map params) {
        // Here need to render it first, establish content type of virtual response / contentType model param
        if (params.view) renderMailView(params.view, params.model, params.plugin)
    }

    void text(body) {
        msgText = body?.toString()
        getMessageHelper().setText(msgText)
    }

    void html(text) {
        msgText = text
        getMessageHelper().setText(msgText, true)
    }

    void bcc(String bcc) {
        msgBcc = [bcc] as String[]
        getMessageHelper().setBcc(msgBcc)
    }

    void bcc(Object[] args) {
        msgBcc = args as String[]
        getMessageHelper().setBcc(msgBcc)
    }

    void cc(String cc) {
        msgCc = [cc] as String[]
        getMessageHelper().setCc(msgCc)
    }

    void cc(Object[] args) {
        msgCc = args as String[]
        getMessageHelper().setCc(msgCc)
    }

    void replyTo(String replyTo) {
        msgReplyTo = replyTo
        getMessageHelper().setReplyTo(msgReplyTo)
    }

    void from(String from) {
        msgFrom = from
        getMessageHelper().setFrom(msgFrom)
    }

    void attach(files) {
        if (files instanceof File) files = [files]
        def helper = getMessageHelper()
        File file
        files.each {
            file = (File) it
            helper.addAttachment(file.getName(), file)
            msgAttachments << file.getPath()
        }
    }

    protected renderMailView(templateName, model, pluginName = null) {
        def requestAttributes = RequestContextHolder.getRequestAttributes()
        boolean unbindRequest = false

        // Outside of an executing request, establish a mock version
        if (!requestAttributes) {
            def servletContext = ServletContextHolder.getServletContext()
            def applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext)
            requestAttributes = GrailsWebUtil.bindMockWebRequest(applicationContext)
            unbindRequest = true
        }

        def request = requestAttributes.request

        // See if the application has the view for it
        def uri = getMailViewUri(templateName, request)
        def r = templateEngine.getResourceForUri(uri)

        // Try plugin view if not found in application
        if ((!r || !r.exists()) && controllerName) {

            // Caution, this uses views/ always, whereas our app view resolution uses the PATH_TO_MAIL_VIEWS which may in future be orthogonal!
            def plugin = PluginManagerHolder.pluginManager.getGrailsPlugin(pluginName)
            String pathToView
            if (plugin) {
                pathToView = '/plugins/' + plugin.name + '-' + plugin.version + '/' + GrailsResourceUtils.GRAILS_APP_DIR + '/views' + templateName
            }

            if (pathToView != null) {
                uri = GrailsResourceUtils.WEB_INF + pathToView + templateName + ".gsp"
                r = templateEngine.getResourceForUri(uri)
            }
        }

        def t = templateEngine.createTemplate(r)
        def out = new StringWriter()
        def originalOut = requestAttributes.getOut()
        requestAttributes.setOut(out)
        try {
            if (model instanceof Map) {
                t.make(model).writeTo(out)
            } else {
                t.make().writeTo(out)
            }
        } finally {
            requestAttributes.setOut(originalOut)
            if (unbindRequest) RequestContextHolder.setRequestAttributes(null)
        }

        if (HTML_CONTENT_TYPES.contains(t.metaInfo.contentType)) {
            html(out.toString()) // @todo Spring mail helper will not set correct mime type if we give it XHTML
        } else {
            text(out)
        }
    }

    protected String getMailViewUri(String viewName, HttpServletRequest request) {
        StringBuffer buf = new StringBuffer(PATH_TO_MAIL_VIEWS)

        if (viewName.startsWith('/')) {
            String tmp = viewName.substring(1, viewName.length())
            if (tmp.indexOf('/') > -1) {
                buf.append('/')
                buf.append(tmp.substring(0, tmp.lastIndexOf('/')))
                buf.append('/')
                buf.append(tmp.substring(tmp.lastIndexOf('/') + 1, tmp.length()))
            } else {
                buf.append('/')
                buf.append(viewName.substring(1, viewName.length()))
            }
        } else {
            if (!request) throw new IllegalArgumentException("Mail views cannot be loaded from relative view paths where there is no current HTTP request")
            def grailsAttributes = new DefaultGrailsApplicationAttributes(request.servletContext);
            buf.append(grailsAttributes.getControllerUri(request)).append('/').append(viewName);

        }

        return buf.append(".gsp").toString()
    }
}
