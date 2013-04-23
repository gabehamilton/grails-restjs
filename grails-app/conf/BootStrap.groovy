import grails.restjs.Author
import grails.restjs.Book

class BootStrap {

    def init = { servletContext ->

		int max = 1001
		for(int i = 0; i< max; i++) {
			Book b = new Book(name: "French Dictionary $i", price: i, quantity: max -i).save(failOnError: true)
			Author a = new Author(firstName: "Denis $i", lastName: "Diderot").save(failOnError: true)
			b.addToAuthors(a)
			if(i % 1000 == 0)
				println "Creating book $i, " + new Date()
		}
    }
    def destroy = {
    }
}
