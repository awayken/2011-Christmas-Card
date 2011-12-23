
<cfinclude template="shared/header.cfm">

<cfif !isDefined('url.nopopup')>
<section id="popup">
	@(popup)
</section>
</cfif>

<nav>
	<a href="/kitchen">Kitchen</a>
	<a href="/livingroom">Living Room</a>
	<a href="/familyroom">Family Room</a>
	<a href="/ians">Ian's Room</a>
</nav>
		
<section id="content" class="memories">
	<div id="pan">@(pan)</div>
	@(memories)
</section>
	
<cfinclude template="shared/footer.cfm">
