
<cfinclude template="shared/header.cfm">

<cfif !isDefined('url.nopopup')>
<div id="popup">
	@(popup)
</div>
</cfif>
		
<div id="content" class="memories">
	<div id="pan">@(pan)</div>
	@(memories)
</div>
	
<cfinclude template="shared/footer.cfm">
