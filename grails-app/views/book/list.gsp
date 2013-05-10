
<%@ page import="grails.restjs.Book"%>
<!doctype html>
<html>
<head>
	<meta name="layout" content="kickstart" />
	<g:set var="entityName" value="${message(code: 'book.label', default: 'Book')}" />
	<title><g:message code="default.list.label" args="[entityName]" /></title>

	<g:set var="jsHome" value="${request.contextPath}/js/"/>
	%{--<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dojo/resources/dojo.css">--}%
	<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dijit/themes/claro/claro.css">
	<link rel="stylesheet" href="${jsHome}dgrid/css/dgrid.css">
	%{--<link rel="stylesheet" href="${jsHome}dgrid/css/skins/claro.css">--}%
	<style>
	#Header .inner {
		padding: 0px 0;
	}
	.footer {
		position: fixed;
		bottom: 0;
		margin-left: 60px;
		margin-right: 60px;
	}
	.dgrid {
		border: 0;
		height: auto;
	}
	.dgrid .dgrid-scroller {
		position: relative;
		max-height: 600px;
		overflow: auto;
	}
	.dgrid-cell-padding {padding: 8px;}
	.dgrid-sortable {color: #0088cc;}
	.dgrid-sortable:hover {text-decoration:underline;}
	.dgrid-cell {border: 0}
	/*#grid { height: 25em}*/
	#grid .field-id {width: 4em;}
	#grid .field-name {width: 15em;}
	#grid .field-edit {width: 3em;}
	#grid .field-delete {width: 4em;}
	.dijitSpinnerButtonContainer {height: 1.5em}


	.dgrid-column-pubDate {
		width: 250px; /* this column will use 200px */
	}	</style>
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
		require(["dgrid/List", "dgrid/OnDemandGrid","dgrid/Selection", "dgrid/editor", "dgrid/Keyboard", "dgrid/tree", 'dgrid/extensions/ColumnResizer',
			"dijit/form/DateTextBox", "dijit/form/CurrencyTextBox", "dijit/form/NumberSpinner",
			"dojo/_base/declare", "dojo/store/JsonRest", "dojo/store/Observable", "dojo/store/Cache", "dojo/store/Memory", "dojo/domReady!"],
			function(List, Grid, Selection, editor, Keyboard, tree, ColumnResizer, DateTextBox, CurrencyTextBox, NumberSpinner, declare, JsonRest, Observable, Cache, Memory){
				var restStore = Observable(Cache(JsonRest({
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
//					,getChildren: function(parent, options){
//						return this.query({}, options);
//					}
//					,mayHaveChildren: function(parent){
//						return parent.type != "city";
//					},
				}), Memory()));
//				testStore.getChildren = function(parent, options){
//					return testStore.query({parent: parent.id}, options);
//				};
				restStore.getChildren = function(parent, options){
					console.log(parent.authors);
					return parent.authors;
	//				return [{"class":"grails.restjs.Book","id":25,"name":"French Dictionary","price":24,"quantity":976},{"class":"grails.restjs.Book","id":26,"name":"French Dictionary","price":25,"quantity":975},{"class":"grails.restjs.Book","id":27,"name":"French Dictionary","price":26,"quantity":974},{"class":"grails.restjs.Book","id":28,"name":"French Dictionary","price":27,"quantity":973},{"class":"grails.restjs.Book","id":29,"name":"French Dictionary","price":28,"quantity":972},{"class":"grails.restjs.Book","id":30,"name":"French Dictionary","price":29,"quantity":971},{"class":"grails.restjs.Book","id":31,"name":"French Dictionary","price":30,"quantity":970},{"class":"grails.restjs.Book","id":32,"name":"French Dictionary","price":31,"quantity":969},{"class":"grails.restjs.Book","id":33,"name":"French Dictionary","price":32,"quantity":968},{"class":"grails.restjs.Book","id":34,"name":"French Dictionary","price":33,"quantity":967},{"class":"grails.restjs.Book","id":35,"name":"French Dictionary","price":34,"quantity":966},{"class":"grails.restjs.Book","id":36,"name":"French Dictionary","price":35,"quantity":965},{"class":"grails.restjs.Book","id":37,"name":"French Dictionary","price":36,"quantity":964},{"class":"grails.restjs.Book","id":38,"name":"French Dictionary","price":37,"quantity":963},{"class":"grails.restjs.Book","id":39,"name":"French Dictionary","price":38,"quantity":962},{"class":"grails.restjs.Book","id":40,"name":"French Dictionary","price":39,"quantity":961},{"class":"grails.restjs.Book","id":41,"name":"French Dictionary","price":40,"quantity":960},{"class":"grails.restjs.Book","id":42,"name":"French Dictionary","price":41,"quantity":959},{"class":"grails.restjs.Book","id":43,"name":"French Dictionary","price":42,"quantity":958},{"class":"grails.restjs.Book","id":44,"name":"French Dictionary","price":43,"quantity":957},{"class":"grails.restjs.Book","id":45,"name":"French Dictionary","price":44,"quantity":956},{"class":"grails.restjs.Book","id":46,"name":"French Dictionary","price":45,"quantity":955},{"class":"grails.restjs.Book","id":47,"name":"French Dictionary","price":46,"quantity":954},{"class":"grails.restjs.Book","id":48,"name":"French Dictionary","price":47,"quantity":953},{"class":"grails.restjs.Book","id":49,"name":"French Dictionary","price":48,"quantity":952},{"class":"grails.restjs.Book","id":50,"name":"French Dictionary","price":49,"quantity":951},{"class":"grails.restjs.Book","id":51,"name":"French Dictionary","price":50,"quantity":950},{"class":"grails.restjs.Book","id":52,"name":"French Dictionary","price":51,"quantity":949},{"class":"grails.restjs.Book","id":53,"name":"French Dictionary","price":52,"quantity":948},{"class":"grails.restjs.Book","id":54,"name":"French Dictionary","price":53,"quantity":947},{"class":"grails.restjs.Book","id":55,"name":"French Dictionary","price":54,"quantity":946},{"class":"grails.restjs.Book","id":56,"name":"French Dictionary","price":55,"quantity":945},{"class":"grails.restjs.Book","id":57,"name":"French Dictionary","price":56,"quantity":944},{"class":"grails.restjs.Book","id":58,"name":"French Dictionary","price":57,"quantity":943},{"class":"grails.restjs.Book","id":59,"name":"French Dictionary","price":58,"quantity":942},{"class":"grails.restjs.Book","id":60,"name":"French Dictionary","price":59,"quantity":941},{"class":"grails.restjs.Book","id":61,"name":"French Dictionary","price":60,"quantity":940},{"class":"grails.restjs.Book","id":62,"name":"French Dictionary","price":61,"quantity":939},{"class":"grails.restjs.Book","id":63,"name":"French Dictionary","price":62,"quantity":938},{"class":"grails.restjs.Book","id":64,"name":"French Dictionary","price":63,"quantity":937},{"class":"grails.restjs.Book","id":65,"name":"French Dictionary","price":64,"quantity":936},{"class":"grails.restjs.Book","id":66,"name":"French Dictionary","price":65,"quantity":935},{"class":"grails.restjs.Book","id":67,"name":"French Dictionary","price":66,"quantity":934},{"class":"grails.restjs.Book","id":68,"name":"French Dictionary","price":67,"quantity":933},{"class":"grails.restjs.Book","id":69,"name":"French Dictionary","price":68,"quantity":932},{"class":"grails.restjs.Book","id":70,"name":"French Dictionary","price":69,"quantity":931},{"class":"grails.restjs.Book","id":71,"name":"French Dictionary","price":70,"quantity":930},{"class":"grails.restjs.Book","id":72,"name":"French Dictionary","price":71,"quantity":929},{"class":"grails.restjs.Book","id":73,"name":"French Dictionary","price":72,"quantity":928},{"class":"grails.restjs.Book","id":74,"name":"French Dictionary","price":73,"quantity":927},{"class":"grails.restjs.Book","id":75,"name":"French Dictionary","price":74,"quantity":926},{"class":"grails.restjs.Book","id":76,"name":"French Dictionary","price":75,"quantity":925},{"class":"grails.restjs.Book","id":77,"name":"French Dictionary","price":76,"quantity":924},{"class":"grails.restjs.Book","id":78,"name":"French Dictionary","price":77,"quantity":923},{"class":"grails.restjs.Book","id":79,"name":"French Dictionary","price":78,"quantity":922},{"class":"grails.restjs.Book","id":80,"name":"French Dictionary","price":79,"quantity":921},{"class":"grails.restjs.Book","id":81,"name":"French Dictionary","price":80,"quantity":920},{"class":"grails.restjs.Book","id":82,"name":"French Dictionary","price":81,"quantity":919},{"class":"grails.restjs.Book","id":83,"name":"French Dictionary","price":82,"quantity":918},{"class":"grails.restjs.Book","id":84,"name":"French Dictionary","price":83,"quantity":917},{"class":"grails.restjs.Book","id":85,"name":"French Dictionary","price":84,"quantity":916},{"class":"grails.restjs.Book","id":86,"name":"French Dictionary","price":85,"quantity":915},{"class":"grails.restjs.Book","id":87,"name":"French Dictionary","price":86,"quantity":914},{"class":"grails.restjs.Book","id":88,"name":"French Dictionary","price":87,"quantity":913},{"class":"grails.restjs.Book","id":89,"name":"French Dictionary","price":88,"quantity":912},{"class":"grails.restjs.Book","id":90,"name":"French Dictionary","price":89,"quantity":911},{"class":"grails.restjs.Book","id":91,"name":"French Dictionary","price":90,"quantity":910},{"class":"grails.restjs.Book","id":92,"name":"French Dictionary","price":91,"quantity":909},{"class":"grails.restjs.Book","id":93,"name":"French Dictionary","price":92,"quantity":908},{"class":"grails.restjs.Book","id":94,"name":"French Dictionary","price":93,"quantity":907},{"class":"grails.restjs.Book","id":95,"name":"French Dictionary","price":94,"quantity":906},{"class":"grails.restjs.Book","id":96,"name":"French Dictionary","price":95,"quantity":905},{"class":"grails.restjs.Book","id":97,"name":"French Dictionary","price":96,"quantity":904},{"class":"grails.restjs.Book","id":98,"name":"French Dictionary","price":97,"quantity":903},{"class":"grails.restjs.Book","id":99,"name":"French Dictionary","price":98,"quantity":902},{"class":"grails.restjs.Book","id":100,"name":"French Dictionary","price":99,"quantity":901},{"class":"grails.restjs.Book","id":101,"name":"French Dictionary","price":100,"quantity":900},{"class":"grails.restjs.Book","id":102,"name":"French Dictionary","price":101,"quantity":899},{"class":"grails.restjs.Book","id":103,"name":"French Dictionary","price":102,"quantity":898},{"class":"grails.restjs.Book","id":104,"name":"French Dictionary","price":103,"quantity":897},{"class":"grails.restjs.Book","id":105,"name":"French Dictionary","price":104,"quantity":896},{"class":"grails.restjs.Book","id":106,"name":"French Dictionary","price":105,"quantity":895},{"class":"grails.restjs.Book","id":107,"name":"French Dictionary","price":106,"quantity":894},{"class":"grails.restjs.Book","id":108,"name":"French Dictionary","price":107,"quantity":893},{"class":"grails.restjs.Book","id":109,"name":"French Dictionary","price":108,"quantity":892},{"class":"grails.restjs.Book","id":110,"name":"French Dictionary","price":109,"quantity":891},{"class":"grails.restjs.Book","id":111,"name":"French Dictionary","price":110,"quantity":890},{"class":"grails.restjs.Book","id":112,"name":"French Dictionary","price":111,"quantity":889},{"class":"grails.restjs.Book","id":113,"name":"French Dictionary","price":112,"quantity":888},{"class":"grails.restjs.Book","id":114,"name":"French Dictionary","price":113,"quantity":887},{"class":"grails.restjs.Book","id":115,"name":"French Dictionary","price":114,"quantity":886},{"class":"grails.restjs.Book","id":116,"name":"French Dictionary","price":115,"quantity":885},{"class":"grails.restjs.Book","id":117,"name":"French Dictionary","price":116,"quantity":884},{"class":"grails.restjs.Book","id":118,"name":"French Dictionary","price":117,"quantity":883},{"class":"grails.restjs.Book","id":119,"name":"French Dictionary","price":118,"quantity":882},{"class":"grails.restjs.Book","id":120,"name":"French Dictionary","price":119,"quantity":881},{"class":"grails.restjs.Book","id":121,"name":"French Dictionary","price":120,"quantity":880},{"class":"grails.restjs.Book","id":122,"name":"French Dictionary","price":121,"quantity":879},{"class":"grails.restjs.Book","id":123,"name":"French Dictionary","price":122,"quantity":878},{"class":"grails.restjs.Book","id":124,"name":"French Dictionary","price":123,"quantity":877}]
				};
//				var columns = [
//					tree({label:'Name', field:'name', sortable: false}),
//					{label:'Id', field:'id', sortable: false},
//					editor({label:'Comment', field:'comment', sortable: false}, "text"),
//					editor({label:'Boolean', field:'boo', sortable: false, autoSave: true}, "checkbox")
//				];

				var columns = { // Slider, NumberSpinner, DateTextBox
					id: {label: 'ID',
						renderCell: function(obj, data, td, options) {
								var str = '<a href="show/' + obj.id + '">' + obj.id + '</a>';
								td.innerHTML = str;
						}},
					name: editor({label: "Name", autoSave: "true"}, "text", "dblclick"),
					price: editor({label: "Price", autoSave: "true"}, CurrencyTextBox, "dblclick"),
					quantity: editor({label: "Qty", autoSave: "true", editorArgs: {style: 'width: 5em; height: 1.5em'}}, NumberSpinner),
					pubDate: editor({label: "Pub Date", autoSave: "true"}, DateTextBox, "dblclick"),
					hardback: editor({label:'Hardback', autoSave: true}, "checkbox", "dblclick"),
					edit: {label: 'Edit', sortable: false,
						renderCell: function(obj, data, td, options) {
								var str = '<a href="edit/' + obj.id + '"><i class="icon-pencil icon-large" alt="Edit"></i></a>';
								td.innerHTML = str;
						}},
					delete: {label: 'Delete', sortable: false,
						renderCell: function(obj, data, td, options) {
								var str = '<a href="delete/' + obj.id + '"><i class="icon-remove icon-large" alt="Delete"></i></a>';
								td.innerHTML = str;
					}}
					,authors: new tree({name:'Author'})
					}; //todo need a column that links to show
//						renderCell: function(obj, data, td, options) {
//											var strClass = 'dijitEdit';//obj.dir ? 'dijitFolderClosed' : 'dijitLeaf';
//											var str = '<span>';
//											str += '<img class="dijitTreeIcon ' + strClass;
//											str += '" alt="" src="' + require.toUrl("dojo/resources/blank.gif") + '"/>' + obj.name;
//											str += '</span>';
//											td.innerHTML = str;					},


				window.grid = new (declare([Grid, Selection, Keyboard, editor, ColumnResizer]))({
					store: restStore,
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


//			grid.on("dgrid-select", function(event){
//				// Report the item from the selected row to the console.
//				console.log("Row selected: ", event.rows[0].data);
//			});
//			grid.on("dgrid-deselect", function(event){
//				console.log("Row de-selected: ", event.rows[0].data);
//			});
//			grid.on(".dgrid-row:click", function(event){
//				var row = grid.row(event);
//				console.log("Row clicked:", row.data);
//			});
		});
	</script>
</head>

<body>
<section id="list-book" class="first">

	<div id="grid" class="claro"></div>
	%{--<button onclick='deleteSelected()'>Delete Selected</button>--}%
	%{--<button onclick='grid.save();'>Save</button>--}%
	%{--<button onclick='grid.revert();'>Revert</button>--}%
</section>
<content tag="page.footer'"></content>
</body>

</html>
