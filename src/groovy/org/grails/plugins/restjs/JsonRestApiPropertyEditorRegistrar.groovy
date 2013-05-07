package org.grails.plugins.restjs

import org.codehaus.groovy.grails.commons.GrailsDomainClass
import org.springframework.beans.PropertyEditorRegistrar;
import org.springframework.beans.PropertyEditorRegistry;

import org.codehaus.groovy.grails.commons.GrailsApplication

// Originally from https://github.com/padcom/grails-json-rest-api
public class JsonRestApiPropertyEditorRegistrar implements PropertyEditorRegistrar {
    private final GrailsApplication application

    public JsonRestApiPropertyEditorRegistrar(GrailsApplication application) {
        this.application = application
    }

    public void registerCustomEditors(PropertyEditorRegistry reg) {
//        JSONApiRegistry.registry.each { name, className ->
		application.getArtefacts("Domain").each{GrailsDomainClass it ->
			//Class clazz = application.getClassForName(it.clazz)
			println "Registering " + it.clazz
            reg.registerCustomEditor(it.clazz, new ParameterToDomainInstanceEditor(it.clazz));
        }
    }
}

