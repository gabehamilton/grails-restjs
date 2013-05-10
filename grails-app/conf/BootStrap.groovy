import grails.restjs.Author
import grails.restjs.Book
import grails.converters.JSON
import org.grails.plugins.restjs.JSONDomainMarshaller

class BootStrap {

	def grailsApplication

    def init = { servletContext ->
//		JSON.registerObjectMarshaller(new JSONDomainMarshaller(grailsApplication))

		int max = 1001
		int count = Book.count() ?: 0
		if(count < max) {
			for(int i = count; i< max; i++) {
				Book b = new Book(name: "French Dictionary $i", price: i, quantity: max -i).save(failOnError: true)
				Author a = new Author(firstName: "Denis $i", lastName: "Diderot").save(failOnError: true)
				b.addToAuthors(a)
				if(i % 1000 == 0)
					println "Creating book $i, " + new Date()
			}
		}
    }
    def destroy = {
    }
}
