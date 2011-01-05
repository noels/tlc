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

class YuiTagLib {

    private static final String yuiBase = 'yui-2.8.1/'

    def bookService

    def yuiResources = {attrs, body ->
        if (attrs.require) {
            def require = attrs.require.split(',')*.trim()
            def css = []
            def libs = []
            require.each {
                switch (it.toLowerCase()) {
                    case 'treeview':
                        addResource(css, 'treeview/assets/skins/sam/treeview.css')
                        addResource(libs, 'yahoo-dom-event/yahoo-dom-event.js')
                        addResource(libs, 'connection/connection-min.js')
                        addResource(libs, 'treeview/treeview-min.js')
                        break
                    case 'connection':
                        addResource(libs, 'yahoo-dom-event/yahoo-dom-event.js')
                        addResource(libs, 'connection/connection-min.js')
                        addResource(libs, 'json/json-min.js')
                        break
                }
            }

            css.each {
                out << '<link rel="stylesheet" href="'
                out << g.resource(dir: 'js/' + yuiBase + it.substring(0, it.lastIndexOf('/')), file: it.substring(it.lastIndexOf('/') + 1))
                out << '"/>\n'
            }

            libs.each {
                out << g.javascript(src: yuiBase + it)
                out << '\n'
            }
        }
    }

    def yuiTreeView = {attrs, body ->
        def id = attrs.remove('id') ?: 'treeDiv'
        def clazz = attrs.remove('class') ?: 'tree'
        def data = attrs.remove('data')
        def expand = attrs.remove('expand')
        if (data) {
            if (!attrs.labelStyle) attrs.labelStyle = 'none'
            def attribs = []
            def extras = []
            def labelSeen = false
            def val
            attrs.each {
                val = it.value
                if (val) {
                    if (it.key == 'label') labelSeen = true
                    if (val.startsWith('data.') && val.length() > 5) {
                        attribs << [it.key, val.substring(5)]
                    } else {
                        if (val == 'true') {
                            val = true
                        } else if (val == 'false') {
                            val = false
                        } else if (val.isInteger()) {
                            val = val.toInteger()
                        }

                        extras << [it.key, val]
                    }
                }
            }

            if (expand) {
                if (expand.action && expand.query) {
                    if (!expand.controller) expand.controller = params.controller
                    if (!expand.timeout) expand.timeout = 30
                    if (!expand.message) expand.message = message(code: 'generic.ajax.timeout', default: 'Operation timed out waiting for a response from the server')
                } else {
                    expand = null
                }
            }

            if (!labelSeen) throw new IllegalArgumentException('No label attribute specified for tree')

            def treeData = bookService.buildTreeFromPaths(data, attribs, extras) as grails.converters.JSON
            out << """\
            <div id="${id}" class="${clazz}">
                <script type="text/javascript">
                    var tree;
                    (function() {
"""
            if (expand) {
                if (!expand.attrs) expand.attrs = []
                if (!expand.attrs.labelStyle) expand.attrs.labelStyle = 'none'
                def additional = ''
                expand.attrs.each {
                    additional += '&' + it.key.encodeAsURL() + '=' + "${it.value}".encodeAsURL()
                }
                def url = g.link(controller: expand.controller, action: expand.action)
                url = url.substring(url.indexOf('"') + 1, url.lastIndexOf('"'))
                out << """\
                        function loadNodeData(node, fnLoadComplete)  {
                            var url = '${url}?query=' + encodeURI(node.${expand.query}) + '${additional}';
                            var callback = {
                                success: function(resp) {
                                    var results = eval("(" + resp.responseText + ")");
                                    if ((results.data) && (results.data.length)) {
                                        if (YAHOO.lang.isArray(results.data)) {
                                            for (var i = 0, j = results.data.length; i < j; i++) {
                                                var tempNode = new YAHOO.widget.TextNode(results.data[i], node, false);
                                            }
                                        } else {
                                            var tempNode = new YAHOO.widget.TextNode(results.data, node, false);
                                        }
                                    }
                                    resp.argument.fnLoadComplete();
                                },
                                failure: function(resp) {
                                    alert('${expand.message.encodeAsJavaScript()}');
                                    resp.argument.fnLoadComplete();
                                },
                                argument: {
                                    "node": node,
                                    "fnLoadComplete": fnLoadComplete
                                },
                                timeout: ${expand.timeout * 1000}
                            };
                            YAHOO.util.Connect.asyncRequest('GET', url, callback);
                        }
"""
            }

            out << """\
                        function treeInit() {
                            tree = new YAHOO.widget.TreeView("treeDiv", ${treeData.toString(true)});
                            ${expand ? 'tree.setDynamicLoad(loadNodeData, 0);' : ''}
                            tree.render();
                        }
                        YAHOO.util.Event.onDOMReady(treeInit);
                    })();
                </script>
            </div>
"""
        }
    }

    private addResource(list, val) {
        if (!list.contains(val)) list << val
    }
}
