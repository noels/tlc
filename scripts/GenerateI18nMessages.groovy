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
import grails.util.GrailsNameUtils
import org.codehaus.groovy.grails.scaffolding.DomainClassPropertyComparator
import org.codehaus.groovy.grails.validation.ConstrainedProperty

includeTargets << grailsScript("Init")
includeTargets << grailsScript("_GrailsBootstrap")
includeTargets << grailsScript("_GrailsCreateArtifacts")

generateForName = null

target(main: "Generates i18n messages for domain classes") {
    depends(checkVersion, parseArguments, packageApp)
    promptForName(type: "Domain Class")
    generateI18nMessages()
}

setDefaultTarget(main)

target(generateI18nMessages: "The implementation target") {
    try {
        def name = argsMap["params"][0]
        if (!name || name == "*") {
            uberGenerate()
        } else {
            generateForName = name
            generateForOne()
        }
    } catch (Exception e) {
        logError("Error running generate-i18n-messages", e)
        exit(1)
    }
}

target(generateForOne: "Generates i18n messages for only one domain class") {
    depends(loadApp)

    def name = generateForName
    name = name.indexOf('.') > -1 ? name : GrailsNameUtils.getClassNameRepresentation(name)
    def domainClass = grailsApp.getDomainClass(name)

    if (!domainClass) {
        println "Domain class not found in grails-app/domain, trying hibernate mapped classes..."
        bootstrap()
        domainClass = grailsApp.getDomainClass(name)
    }

    if (domainClass) {
        generateForDomainClass(domainClass)
        event("StatusFinal", ["Finished generation for domain class ${domainClass.fullName}. Copy messages to appropriate resource bundle(s)"])
    } else {
        event("StatusFinal", ["No domain class found for name ${name}. Please try again and enter a valid domain class name"])
    }
}

target(uberGenerate: "Generates i18n messages for all domain classes") {
    depends(loadApp)

    def domainClasses = grailsApp.domainClasses

    if (!domainClasses) {
        println "No domain classes found in grails-app/domain, trying hibernate mapped classes..."
        bootstrap()
        domainClasses = grailsApp.domainClasses
    }

   if (domainClasses) {
        domainClasses.each { domainClass ->
            generateForDomainClass(domainClass)
        }
        event("StatusFinal", ["Finished generation for domain classes. Copy messages to appropriate resource bundle(s)"])
    } else {
        event("StatusFinal", ["No domain classes found"])
    }
}


def generateForDomainClass(domainClass) {

    // Create a human readable name for the domain
    naturalName = org.codehaus.groovy.grails.commons.GrailsClassUtils.getNaturalName(domainClass.propertyName)

    // Print generic messages for this domain class
    println "# ${naturalName} messages"
    println "${domainClass.propertyName}.create=Create ${naturalName}"
    println "${domainClass.propertyName}.edit=Edit ${naturalName}"
    println "${domainClass.propertyName}.list=${naturalName} List"
    println "${domainClass.propertyName}.new=New ${naturalName}"
    println "${domainClass.propertyName}.show=Show ${naturalName}"
    println "${domainClass.propertyName}.created=${naturalName} {0} created"
    println "${domainClass.propertyName}.updated=${naturalName} {0} updated"
    println "${domainClass.propertyName}.deleted=${naturalName} {0} deleted"
    println "${domainClass.propertyName}.not.deleted=${naturalName} {0} could not be deleted ({1})"
    println "${domainClass.propertyName}.not.found=${naturalName} not found with id {0}"
    println "${domainClass.propertyName}.optimistic.locking.failure=Another user has updated this ${naturalName} while you were editing"

    // Print messages for all properties contained by domain class
    props = domainClass.properties.findAll { !['id', 'securityCode', 'dateCreated', 'lastUpdated', 'version', 'afterInsert', 'afterUpdate', 'afterDelete'].contains(it.name) }
    Collections.sort(props, new DomainClassPropertyComparator(domainClass))
    props.each { p ->
        println "${domainClass.propertyName}.${p.name}=${p.naturalName}"

        // Print messages for inList constaint values
        cp = domainClass.constrainedProperties[p.name]
        if (cp?.inList) {
            cp.inList.each { v ->
                println "${domainClass.propertyName}.${p.name}.${v}=${v}"
            }
        }
    }

    println ""
}