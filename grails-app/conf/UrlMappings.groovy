class UrlMappings {

	static mappings = {
		
		/* 
		 * Pages without controller 
		 */
//		"/"				(view:"/index")
		"/about"		(view:"/siteinfo/about")
		"/blog"			(view:"/siteinfo/blog")
		"/systeminfo"	(view:"/siteinfo/systeminfo")
		"/contact"		(view:"/siteinfo/contact")
		"/terms"		(view:"/siteinfo/terms")
		"/imprint"		(view:"/siteinfo/imprint")
		
		/* 
		 * Pages with controller
		 * WARN: No domain/controller should be named "api" or "mobile" or "web"!
		 */
        "/"	{
			controller	= 'home'
			action		= { 'index' }
            view		= { 'index' }
        }

		"/$controller/" {action = "list"}

		"/$controller/$id" (parseRequest: true){
			action = [GET: "show", PUT: "update", DELETE: "delete", POST: "save"]
			constraints {
				id(matches: /\d+/) // todo UUID?
			}
		}

		"/$controller/$action/$id?"{
			constraints {
				action(matches: /[A-z]+.*/)
				controller(matches:/^((?!(api|mobile|web)).*)$/)
		  	}
		}

		/* 
		 * System Pages without controller 
		 */
		"403"	(view:'/_errors/403')
		"404"	(view:'/_errors/404')
		"500"	(view:'/_errors/error')
		"503"	(view:'/_errors/503')
	}
}
