<cfset request.page = application.helpers.page.init(application.homepath & "/404.cfm") />

<cfinclude template="#application.config.library#/templates/shared/header.cfm">

<nav>
	<a href="/kitchen">Kitchen</a>
	<a href="/livingroom">Living Room</a>
	<a href="/familyroom">Family Room</a>
	<a href="/ians">Ian's Room</a>
</nav>
		
<section id="content" class="fourohfour">
	<div>
		<p>Woops! We can't find the page you were looking for.</p>
	</div>
</section>
	
<cfinclude template="#application.config.library#/templates/shared/footer.cfm">
