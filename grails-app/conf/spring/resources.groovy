import org.grails.plugins.restjs.JsonRestApiPropertyEditorRegistrar

// Place your Spring DSL code here
beans = {
//	customPropertyEditorRegistrar(CustomDateEditorRegistrar)
	jsonRestApiPropertyEditorRegistrar(JsonRestApiPropertyEditorRegistrar, ref("grailsApplication"))
//	customPropertyEditorRegistrar(JsonDateEditorRegistrar)
}
