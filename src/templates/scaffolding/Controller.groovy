<%=packageName ? "package ${packageName}\n\n" : ''%>import org.springframework.dao.DataIntegrityViolationException

import org.codehaus.groovy.grails.web.servlet.HttpHeaders
import javax.servlet.http.HttpServletResponse
import grails.converters.JSON
import grails.converters.XML
import org.codehaus.groovy.grails.web.json.JSONException
import org.springframework.dao.DataIntegrityViolationException
import org.grails.plugins.restjs.HttpConstants

/**
 * ${className}Controller
 * A controller class handles incoming web requests and performs actions such as redirects, rendering views and so on.
 */
class ${className}Controller {

    static allowedMethods = [list: "GET", show: "GET", save: "POST", update: ["POST", "PUT"], delete: ["POST", "DELETE"]]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
		String range = request.getHeader(HttpHeaders.RANGE)
		if(range) {
			String[] ranges = range.substring("items=".length()).split("-")
			params.offset = Integer.valueOf(ranges[0])
			params.max = Integer.valueOf(ranges[1]) - params.offset + 1
		}
		String sort = params.sort
		if(sort) {
			if(sort.startsWith('+') || sort.startsWith(' ')) {
				params.sort = sort.substring(1)
				params.order = 'asc'
			}
			else if(sort.startsWith('-')) {
				params.sort = sort.substring(1)
				params.order = 'desc'
			}
		}
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		params.offset = params.offset ? params.int('offset') : 0
		List<${className}> ${propertyName}List = ${className}.list(params)
		Integer total = ${className}.count()
		response.setHeader(HttpHeaders.CONTENT_RANGE, "items \${params.offset}-\${params.max + params.offset -1}/\$total")
		response.addIntHeader HttpConstants.X_PAGINATION_TOTAL, ${className}.count()
		withFormat {
			//todo Add form & multipartForm for filter submissions
			html {
				[${propertyName}List: ${propertyName}List, ${propertyName}Total: total]
			}
			json {
				render ${propertyName}List as JSON
			}
			xml {
				render ${propertyName}List as XML
			}
		}
    }

	// html workflow only
    def create() {
        [${propertyName}: new ${className}(params)]
    }

    def save() {
		withFormat{
			json {
				def text = request?.inputStream?.text
				if(text) {
					try {
						JSON.parse(text).entrySet().each {
							params.put it.key, it.value
						}
					} catch (JSONException e) {
						log.error e
					}
				}
			}
			xml {
				//todo
			}
		}
        def ${propertyName} = new ${className}(params)
        if (!${propertyName}.save(flush: true)) {
			respondUnprocessableEntity ${propertyName}
            return
        }
		respondCreated ${propertyName}
    }

    def show() {
        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			respondNotFound params.id
            return
        }
		respondFound ${propertyName}
    }

	// html workflow only
    def edit() {
        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			respondNotFound(params.id)
            return
        }

        [${propertyName}: ${propertyName}]
    }

    def update() {
		withFormat{
			html {}
			json {
				def body
				if(request.JSON) {
					body = request.JSON
				}
				else {
					body = request?.inputStream?.text
					if(body)
						body = JSON.parse(body)
				}
				if(body) {
					try {
						body.entrySet().each {
							params.put it.key, it.value
						}
					} catch (JSONException ignored) {}
				}
			}
			xml {} // todo
		}

        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			respondNotFound(params.id)
            return
        }

        if (params.version) {
			if (${propertyName}.version > params.long('version')) {
				respondConflict(${propertyName})
                return
            }
        }

        ${propertyName}.properties = params

        if (!${propertyName}.save(flush: true)) {
			respondUnprocessableEntity ${propertyName}
            return
        }
		respondUpdated ${propertyName}
    }

    def delete() {
        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			respondNotFound(params.id)
            return
        }

        try {
            ${propertyName}.delete(flush: true)
			respondDeleted params.id
        }
        catch (DataIntegrityViolationException e) {
			respondNotDeleted params.id
        }
    }

//	//todo try this out instead of  def ${propertyName} = ${className}.get(params.id)... if exists ... not found
//	def withObject(object=this.getClass().getName()-"Controller", id="id", Closure c) {
//		assert object
//		def obj =  grailsApplication.classLoader.loadClass(object).get(params[id])
//		if(obj) {
//			c.call obj
//		} else {
//		    //todo replace with notFound
//			flash.message = "The object was not found"
//			redirect action: "list"
//		}
//	}

	private void respondFound(${className} ${propertyName}) {
		withFormat {
			html {
				[${propertyName}: ${propertyName}]
			}
			json {
				response.status = HttpServletResponse.SC_OK
				render ${propertyName} as JSON
			}
			xml {
				response.status = HttpServletResponse.SC_OK
				render ${propertyName} as XML
			}
		}
	}

	private void respondUpdated(${className} ${propertyName}) {
		withFormat{
			form {
				flash.message = message(code: 'default.updated.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), ${propertyName}.id])
				redirect(action: "show", id: ${propertyName}.id)
			}
			json {
				response.status = HttpServletResponse.SC_OK
				render ${propertyName} as JSON
			}
			xml {
				response.status = HttpServletResponse.SC_OK
				render ${propertyName} as XML
			}
		}
	}

	private void respondDeleted(id) {
		def responseBody = [:]
		responseBody.message = message(code: 'default.deleted.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), id])

		def htmlResponse = {
			flash.message = responseBody.message
			redirect(action: "list")
		}
		withFormat {
			form {htmlResponse()}
			multipartForm {htmlResponse()}
			html {htmlResponse()}
			json {
				response.status = HttpServletResponse.SC_OK
				render responseBody as JSON
			}
			xml {
				response.status = HttpServletResponse.SC_OK
				render responseBody as XML
			}
		}
	}

	private void respondCreated(${className} ${propertyName}) {
		def htmlResponse = {
			flash.message = message(code: 'default.created.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), ${propertyName}.id])
			redirect(action: "show", id: ${propertyName}.id)
		}

		withFormat{
			form { htmlResponse() }
			html { htmlResponse() }
			multipartForm { htmlResponse() }
			json {
				response.setStatus(HttpServletResponse.SC_CREATED)
				response.addHeader HttpHeaders.LOCATION, createLink(action: 'show', id: ${propertyName}.id)
				render ${propertyName} as JSON
			}
			xml {
				response.setStatus(HttpServletResponse.SC_CREATED)
				response.addHeader HttpHeaders.LOCATION, createLink(action: 'show', id: ${propertyName}.id)
				render ${propertyName} as XML
			}
		}
	}

	private void respondNotFound(id) {
		Map responseBody = [:]
		responseBody.error = message(code: 'default.not.found.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), id])

		def htmlResponse = {
			flash.message = responseBody.error
			redirect(action: "list")
		}
		withFormat {
			form {htmlResponse()}
			multipartForm {htmlResponse()}
			html {htmlResponse()}
			json {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND)
				render responseBody as JSON
			}
			xml {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND)
				render responseBody as XML
			}
		}
	}

	private void respondConflict(${className} ${propertyName}) {
		${propertyName}.errors.rejectValue("version", "default.optimistic.locking.failure",
				[message(code: '${domainClass.propertyName}.label', default: '${className}')] as Object[],
				"Another user has updated this ${className} while you were editing")
		def responseBody = [:]
		responseBody.errors = ${propertyName}.errors.allErrors.collect {
			message(error: it)
		}
		withFormat {
			html {
				render(view: "edit", model: [${propertyName}: ${propertyName}])
			}
			json {
				response.setStatus(HttpServletResponse.SC_CONFLICT)
				render responseBody as JSON
			}
			xml {
				response.setStatus(HttpServletResponse.SC_CONFLICT)
				render responseBody as XML
			}
		}

	}

	// validation failed
	private void respondUnprocessableEntity(${className} ${propertyName}) {
		List errors = ${propertyName}.errors.allErrors.collect {
			message(error: it)
		}
		def htmlResponse = {
			flash.message = errors
			render(view: "create", model: [${propertyName}: ${propertyName}])
		}
		withFormat {
			form {htmlResponse()}
			multipartForm {htmlResponse()}
			html {htmlResponse()}
			//todo add form & multipartForm
			html {
			}
			json {
				response.status = HttpConstants.SC_UNPROCESSABLE_ENTITY
				render errors as JSON
			}
			xml {
				response.status = HttpConstants.SC_UNPROCESSABLE_ENTITY
				render errors as XML
			}
		}
	}

	private void respondNotDeleted(id) {

		def responseBody = [:]
		responseBody.message = message(code: 'default.not.deleted.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), id])

		def htmlResponse = {
			flash.message = responseBody.message
			redirect(action: "show", id: params.id)
		}
		withFormat {
			form {htmlResponse()}
			multipartForm {htmlResponse()}
			html {htmlResponse()}
			json {
				response.status = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
				render responseBody as JSON
			}
			xml {
				response.status = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
				render responseBody as XML
			}
		}
	}
}
