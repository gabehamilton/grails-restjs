<footer class="footer">
	<div class="container">
		<div class="row">
			<div class="span2">
				<h4>Product</h4>
				<ul class="unstyled">
					<li>
						<a href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
					</li>
					<li>
						<a href="${createLink(uri: '/')}"><g:message code="default.tour.label"/></a>
					</li>
					<li>
						<a href="${createLink(uri: '/')}"><g:message code="default.pricing.label"/></a>
					</li>
					<li>
						<a href="${createLink(uri: '/')}"><g:message code="default.faq.label"/></a>
					</li>
				</ul>
			</div>
			<div class="span2">
				<h4>Company</h4>
				<ul class="unstyled">
					<li><a href="${createLink(uri: '/about')}"><g:message code="default.about.label"/></a></li>
					<li><a href="${createLink(uri: '/contact')}"><g:message code="default.contact.label"/></a></li>
				</ul>
			</div>
			<div class="span8">
				<h4> Information </h4>
				<p></p>
			</div>
		</div>
		%{--<h4>Disclaimer</h4>--}%
		<p class="pull-right"><a href="#">Back to top</a></p>
	</div>
</footer>
