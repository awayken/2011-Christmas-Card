
<cfinclude template="shared/header.cfm">

<cfif !isDefined('url.close')>
<div id="popup">
	@(popup)
</div>
</cfif>
		
<div id="memories">
	@(pan)
	@(memories)
</div>
	
<cfinclude template="shared/footer.cfm">
