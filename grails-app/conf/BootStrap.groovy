import grails.restjs.Book

class BootStrap {

    def init = { servletContext ->

		int max = 1000
		for(int i = 0; i< max; i++) {
			new Book(name: 'French Dictionary', price: i, quantity: max -i).save(failOnError: true)
			if(i % 1000 == 0)
				println "Creating book $i, " + new Date()
		}
    }
    def destroy = {
    }
}
