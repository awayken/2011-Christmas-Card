
<cfinclude template="shared/header.cfm">

<cfif !isDefined('url.nopopup')>
<section id="popup">
	@(popup)
</section>
</cfif>

<section id="toolbar">
	<a href="/rooms/">Back to rooms</a>
</section>
		
<section id="content" class="memories">
	<div id="pan">@(pan)</div>
	@(memories)
</section>
	
<cfinclude template="shared/footer.cfm">
