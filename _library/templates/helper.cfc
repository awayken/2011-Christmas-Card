<cfcomponent displayname="Templates Front-end" output="no">
	
	<cffunction name="init" output="yes" returnType="string">
		<cfargument name="targetpagepath" required="true"
			hint="The expanded path of the page to apply templates to." />
		<cfargument name="template" required="true" />
		
		<cfset var local = {} />
		
		<cfset local.regionregex = "@\(.+?\)" />
		<cfset local.templatefile = arguments.template & ".cfm" />
		<cfset local.templatefilepath = application.config.library & "/templates/" & local.templatefile />
		
		<cfif Not FileExists(ExpandPath(local.templatefilepath))>
			<cfthrow message="Template file does not exist." detail="The template file, '#local.templatefilepath#', could not be found. Please create this template file or set your page to use an alternate template." />
			
		<cfelse>
			<cfsavecontent variable="local.template">
				<cfinclude template="#local.templatefile#" />
			</cfsavecontent>
			
			<cfsavecontent variable="local.page">
				<cfinclude template="#arguments.targetpagepath#" />
			</cfsavecontent>
		
			<cfset local.regions = REMatchNoCase(local.regionregex, local.template) />
			<cfloop array="#local.regions#" index="local.i">
				<cfset local.regionopen = lCase(local.i) />
				<cfset local.regionstart = FindNoCase(local.regionopen, local.page) + Len(local.regionopen) />
				<cfset local.regionclose = lCase(Left(local.i, 2) & "/" & Right(local.i, Len(local.i) - 2)) />
				<cfset local.regionend = FindNoCase(local.regionclose, local.page) />
				
				<cfif local.regionend GT 0>
					<cfset local.regionsize = local.regionend - local.regionstart />
					<cfset local.regionhtml = Mid(local.page, local.regionstart, local.regionsize) />
				<cfelse>
					<cfset local.regionhtml = "" />
				</cfif>
	
				<cfset local.template = ReplaceNoCase(local.template, local.regionopen, local.regionhtml) />
			</cfloop>
		
		</cfif>
	
		<cfreturn local.template />
	</cffunction>
	
</cfcomponent>