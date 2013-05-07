package org.grails.plugins.restjs

import org.codehaus.groovy.grails.web.json.JSONObject

import java.beans.PropertyEditorSupport;

//Originally from https://github.com/padcom/grails-json-rest-api  NumberToDomainInstanceEditor

public class ParameterToDomainInstanceEditor extends PropertyEditorSupport {
    private final Class domainClass

    public ParameterToDomainInstanceEditor(Class domainClass) {
        this.domainClass = domainClass
    }

    @Override
    public void setValue(Object value) {
		println "Assigning to $domainClass from $value with class " + value?.class
//        if (domainClass.isAssignableFrom(value.class)) {
//            super.setValue(value)
//			println "set value directly"
//		}
//        else
		if (value instanceof JSONObject) {
            def instance = domainClass.get(value?.id)
            super.setValue(instance)
			println "set value directly from json"
        }
    }
}
