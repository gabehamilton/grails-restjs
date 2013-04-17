<%=packageName ? "package ${packageName}\n\n" : ''%>import org.springframework.dao.DataIntegrityViolationException

import javax.servlet.http.HttpServletResponse
import grails.converters.JSON
import grails.converters.XML
import org.codehaus.groovy.grails.web.json.JSONException

/**
 * ${className}Controller
 * A controller class handles incoming web requests and performs actions such as redirects, rendering views and so on.
 */
class ${className}Controller {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
		String range = request.getHeader('Range')
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
		response.setHeader('Content-Range', "items \${params.offset}-\${params.max + params.offset -1}/\$total")
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

    def create() {
        [${propertyName}: new ${className}(params)]
    }

    def save() {
		withFormat{
			html {}
			json {
				def text = request?.inputStream?.text
				if(text) {
					try {
						JSON.parse(text).entrySet().each {
							params.put it.key, it.value
						  }
					} catch (JSONException ignored) {}
				}
			}
			xml {
				//todo
			}
		}
        def ${propertyName} = new ${className}(params)
        if (!${propertyName}.save(flush: true)) {
			withFormat {
				//todo add form & multipartForm
				html {
					render(view: "create", model: [${propertyName}: ${propertyName}])
				}
				json {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST)
					render ${propertyName}.errors as JSON
				}
				xml {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST)
					render ${propertyName}.errors as XML
				}
			}
            return
        }
		flash.message = message(code: 'default.created.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), ${propertyName}.id])

		def htmlResult = {
			redirect(action: "show", id: ${propertyName}.id)
		}

		withFormat{
			form { htmlResult() }
			html { htmlResult() }
			multipartForm { htmlResult() }
			json {
				response.setStatus(HttpServletResponse.SC_CREATED)
				render ${propertyName} as JSON
			}
			xml {
				response.setStatus(HttpServletResponse.SC_CREATED)
				render ${propertyName} as XML
			}
		}
    }

    def show() {
        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), params.id])
			withFormat {
				// is it possible to need form?
				html {
					flash.message = message
					redirect(action: "list")
				}
				json {
					response.sendError(HttpServletResponse.SC_NOT_FOUND)
					render "{error: '\${message}'}"
				}
				xml {
					response.sendError(HttpServletResponse.SC_NOT_FOUND)
					render "<error>\${message}</error>"
				}
			}
            return
        }

		withFormat {
			html {
				[${propertyName}: ${propertyName}]
			}
			json {
				def o = ${propertyName}.get(params.id)
				render o as JSON
			}
			xml {
				def o = ${propertyName}.get(params.id)
				render o as XML
			}
		}
    }

    def edit() {
        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			// todo factor out into notFound method
			String message = message(code: 'default.not.found.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), params.id])
			// todo form?
			html {
				flash.message = message
				redirect(action: "list")
			}
			json {
				response.sendError(HttpServletResponse.SC_NOT_FOUND)
				render "{error: '\${message}'}"
			}
			xml {
				response.sendError(HttpServletResponse.SC_NOT_FOUND)
				render "<error>\${message}</error>"
			}
            return
        }

        [${propertyName}: ${propertyName}]
    }

    def update() {
		withFormat{
			html {}
			json {
				def text = request?.inputStream?.text
				if(text) {
					try {
						JSON.parse(text).entrySet().each {
							params.put it.key, it.value
						}
					} catch (JSONException ignored) {}
				}
			}
			xml {} // todo
		}

        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			// todo factor out into notFound method
			String message = message(code: 'default.not.found.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), params.id])
			// todo form?
			html {
				flash.message = message
				redirect(action: "list")
			}
			json {
				response.sendError(HttpServletResponse.SC_NOT_FOUND)
				render "{error: '\${message}'}"
			}
			xml {
				response.sendError(HttpServletResponse.SC_NOT_FOUND)
				render "<error>\${message}</error>"
			}
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (${propertyName}.version > version) {<% def lowerCaseName = grails.util.GrailsNameUtils.getPropertyName(className) %>
                ${propertyName}.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: '${domainClass.propertyName}.label', default: '${className}')] as Object[],
                          "Another user has updated this ${className} while you were editing")
				withFormat {
					html {
						${propertyName}.errors.rejectValue("version", "default.optimistic.locking.failure",
                 			[message(code: '${domainClass.propertyName}.label', default: '${className}')] as Object[],
                 			"Another user has updated this ${className} while you were editing")
						render(view: "edit", model: [${propertyName}: ${propertyName}])
					}
					json {
						response.sendError(HttpServletResponse.SC_CONFLICT)
						render "{error: 'Another user has updated this ${className} while you were editing'}"
					}
					xml {
						response.sendError(HttpServletResponse.SC_CONFLICT)
						render "<error>Another user has updated this ${className} while you were editing</error>"
					}
				}
                return
            }
        }

        ${propertyName}.properties = params

        if (!${propertyName}.save(flush: true)) {
			withFormat {
				html {
					render(view: "edit", model: [${propertyName}: ${propertyName}])
				}
				json {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST)
					render ${propertyName}.errors as JSON
				}
				xml {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST)
					render ${propertyName}.errors as XML
				}
			}
            return
        }

		withFormat{
			form {
				flash.message = message(code: 'default.updated.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), ${propertyName}.id])
				redirect(action: "show", id: ${propertyName}.id)
			}
			json {
				render ${propertyName} as JSON
			}
			xml {
				render ${propertyName} as XML
			}
		}
    }

    def delete() {
        def ${propertyName} = ${className}.get(params.id)
        if (!${propertyName}) {
			// todo factor out into notFound method
			String message = message(code: 'default.not.found.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), params.id])
			// todo form?
			html {
				flash.message = message
				redirect(action: "list")
			}
			json {
				response.sendError(HttpServletResponse.SC_NOT_FOUND)
				render "{error: '\${message}'}"
			}
			xml {
				response.sendError(HttpServletResponse.SC_NOT_FOUND)
				render "<error>\${message}</error>"
			}
            return
        }

        try {
            ${propertyName}.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: '${domainClass.propertyName}.label', default: '${className}'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
}
