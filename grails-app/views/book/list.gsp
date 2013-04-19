
<%@ page import="grails.restjs.Book" %>
<!doctype html>
<html>
<head>
	<meta name="layout" content="kickstart" />
	<g:set var="entityName" value="${message(code: 'book.label', default: 'Book')}" />
	<title><g:message code="default.list.label" args="[entityName]" /></title>

	<g:set var="jsHome" value="${request.contextPath}/js/"/>
	%{--<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dojo/resources/dojo.css">--}%
	<link rel="stylesheet" href="${jsHome}dgrid/css/dgrid.css">
	%{--<link rel="stylesheet" href="${jsHome}dgrid/css/skins/claro.css">--}%
	<style>
	.dgrid-cell-padding {padding: 8px;}
	.dgrid-sortable {color: #0088cc;}
	.dgrid-sortable:hover {text-decoration:underline;}
	#grid { height: 20em}
	</style>
	<script>
			var dojoConfig;
			(function(){
				var baseUrl = '${jsHome}'; //location.pathname.replace(/\/[^/]+$/, "/../../../js/");
				console.log
				dojoConfig = {
					async: 1,
					packages: [
						{ name: "dgrid", location: baseUrl + "dgrid" },
						{ name: "xstyle", location: baseUrl + "xstyle" },
						{ name: "put-selector", location: baseUrl + "put-selector" }
//						,{ name: 'dbootstrap', location: baseUrl + 'dbootstrap'}
					]
				};
			}());
		</script>
		<script src="//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dojo/dojo.js"></script>
	<script>
		require(["dgrid/List", "dgrid/OnDemandGrid","dgrid/Selection", "dgrid/editor", "dgrid/Keyboard", "dgrid/tree", "dojo/_base/declare", "dojo/store/JsonRest", "dojo/store/Observable", "dojo/store/Cache", "dojo/store/Memory", "dojo/domReady!"],
			function(List, Grid, Selection, editor, Keyboard, tree, declare, JsonRest, Observable, Cache, Memory){
				var testStore = Observable(Cache(JsonRest({
					target:"./",
					idProperty: "id"
					,sortParam: 'sort'
//					,query: function(query, options){
////						// have to manually adjust the query to get rid of the double ?? that trips php up
////						if(query.parent){
////							query = "parent=" + query.parent;
////						}
//						return JsonRest.prototype.query.call(this, query, options);
//					}
				}), Memory()));
//				testStore.getChildren = function(parent, options){
//					return testStore.query({parent: parent.id}, options);
//				};
//				var columns = [
//					tree({label:'Name', field:'name', sortable: false}),
//					{label:'Id', field:'id', sortable: false},
//					editor({label:'Comment', field:'comment', sortable: false}, "text"),
//					editor({label:'Boolean', field:'boo', sortable: false, autoSave: true}, "checkbox")
//				];

				var columns = {name: "Name", price: "Price", quantity: "Qty"}; //todo need a column that links to show
				window.grid = new (declare([Grid, Selection, Keyboard]))({
					store: testStore,
					getBeforePut: false
					,columns: columns
					,loadingMessage: "Loading data..."
					,noDataMessage: "No results found."
				}, "grid");
//				deleteSelected = function(){
//					for(var i in grid.selection){
//						testStore.remove(i);
//					}
//				}


			grid.on("dgrid-select", function(event){
				// Report the item from the selected row to the console.
				console.log("Row selected: ", event.rows[0].data);
			});
			grid.on("dgrid-deselect", function(event){
				console.log("Row de-selected: ", event.rows[0].data);
			});
			grid.on(".dgrid-row:click", function(event){
				var row = grid.row(event);
				console.log("Row clicked:", row.data);
			});
		});
	</script>
</head>

<body>
<section id="list-book" class="first">

	<div id="grid"></div>
	%{--<button onclick='deleteSelected()'>Delete Selected</button>--}%
	%{--<button onclick='grid.save();'>Save</button>--}%
	%{--<button onclick='grid.revert();'>Revert</button>--}%
</section>

</body>

</html>
