import org.codehaus.groovy.grails.scaffolding.view.ScaffoldingViewResolver

includeTargets << grailsScript("_GrailsBootstrap")
includeTargets << grailsScript("_GrailsCreateArtifacts")

target(main: "Create a controller for each domain class") {
	depends(loadApp)
	def domainClasses = grailsApp.domainClasses

	if (!domainClasses) {
		println "No domain classes found in grails-app/domain, trying hibernate mapped classes..."
		bootstrap()
		domainClasses = grailsApp.domainClasses
	}

	List controllerClassNames = []
	def controllers = grailsApp.controllerClasses
	if(controllers) {
		controllers.each {
			controllerClassNames << it.name
		}
	}

	if (domainClasses) {
		domainClasses.each { domainClass ->
			generateForDomainClass(domainClass, controllerClassNames)
		}
		event("StatusFinal", ["Finished generation for domain classes"])
	} else {
		event("StatusFinal", ["No domain classes found"])
	}

}

target(clearScaffolding: "Clear scaffolded views") {
	ScaffoldingViewResolver.clearViewCache()
 	println "Scaffolded views cleared"
// http://svn.codehaus.org/grails/tags/builds/build.475/src/groovy/org/codehaus/groovy/grails/scaffolding/plugins/ScaffoldingGrailsPlugin.groovy
	// can we regen scaffolding?
}

setDefaultTarget(main)

def generateForDomainClass(domainClass, controllerClassNames) {
	String name = domainClass.name
	def fullName = domainClass.fullName
	def type = "Controller"
	if(!controllerClassNames.contains(name)) {
		println "Creating Controller $name$type"
		createArtifact(name: name, suffix: type, type: type, path: "grails-app/controllers")
		createUnitTest(name: name, suffix: type, superClass: "ControllerUnitTestCase")
		event("CreatedFile", [name + type])
	}
	else {
		println "Controller $name$type exists"
	}
}