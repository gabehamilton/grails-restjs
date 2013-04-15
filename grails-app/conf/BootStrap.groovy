import grails.restjs.Book

class BootStrap {

    def init = { servletContext ->

		for(int i = 0; i< 1000; i++) {
			new Book(name: 'French Dictionary', price: i).save(failOnError: true)
			if(i % 1000 == 0)
				println "Creating book $i, " + new Date()
		}
    }
    def destroy = {
    }
}
