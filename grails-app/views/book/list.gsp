
<%@ page import="grails.restjs.Book" %>
<!doctype html>
<html>
<head>
	<meta name="layout" content="kickstart" />
	<g:set var="entityName" value="${message(code: 'book.label', default: 'Book')}" />
	<title><g:message code="default.list.label" args="[entityName]" /></title>

	<g:set var="jsHome" value="${request.contextPath}/js/"/>
	<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dojo/resources/dojo.css">
	<link rel="stylesheet" href="${jsHome}dgrid/css/dgrid.css">
	<link rel="stylesheet" href="${jsHome}dgrid/css/skins/claro.css">
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
					]
				};
			}());
		</script>
		<script src="//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dojo/dojo.js"></script>
	<script>
		require(["dgrid/List", "dgrid/OnDemandGrid","dgrid/Selection", "dgrid/editor", "dgrid/Keyboard", "dgrid/tree", "dojo/_base/declare", "dojo/store/JsonRest", "dojo/store/Observable", "dojo/store/Cache", "dojo/store/Memory", "dojo/domReady!"],
			function(List, Grid, Selection, editor, Keyboard, tree, declare, JsonRest, Observable, Cache, Memory){
				var testStore = Observable(Cache(JsonRest({
					target:"./list",
					idProperty: "id"
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

				var columns = [
				]
				window.grid = new (declare([Grid, Selection, Keyboard]))({
					store: testStore,
					getBeforePut: false,
					columns: {name: "Name", price: "Price"}
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

<body class="claro">
<section id="list-book" class="first">

	<div id="grid"></div>

	%{--<table class="table table-bordered">--}%
		%{--<thead>--}%
			%{--<tr>--}%
			%{----}%
				%{--<g:sortableColumn property="name" title="${message(code: 'book.name.label', default: 'Name')}" />--}%
			%{----}%
				%{--<g:sortableColumn property="price" title="${message(code: 'book.price.label', default: 'Price')}" />--}%
			%{----}%
			%{--</tr>--}%
		%{--</thead>--}%
		%{--<tbody>--}%
		%{--<g:each in="${bookList}" status="i" var="book">--}%
			%{--<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">--}%
			%{----}%
				%{--<td><g:link action="show" id="${book.id}">${fieldValue(bean: book, field: "name")}</g:link></td>--}%
			%{----}%
				%{--<td>${fieldValue(bean: book, field: "price")}</td>--}%
			%{----}%
			%{--</tr>--}%
		%{--</g:each>--}%
		%{--</tbody>--}%
	%{--</table>--}%

	%{--<div class="pagination">--}%
		%{--<bs:paginate total="${bookTotal}" />--}%
	%{--</div>--}%
</section>

</body>

</html>
