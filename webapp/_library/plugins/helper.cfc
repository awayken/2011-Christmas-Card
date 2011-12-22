<cfcomponent displayname="Plugins Front-end" output="no">
	
	<cffunction name="init" output="yes" returnType="string">
		<cfargument name="html" required="true"
			hint="The html of the page to apply plugins to." />
	
		<cfset var local = {} />
	
		<cfset local.regionregex = "@\[.+?\]" />
		<cfset local.content = arguments.html />
	
		<cfset local.plugins = REMatchNoCase(local.regionregex, arguments.html) />
		<cfloop array="#local.plugins#" index="local.i">
			<cfset local.plugintag = Mid(local.i, 3, Len(local.i) - 3) />
			<cfset local.pluginname = ListFirst(local.plugintag, " ") />
			<cfset local.pluginarguments = getArguments(ListRest(local.plugintag, " "), " ") />
			<cfset local.plugincomponent = application.config.library & ".plugins." & local.pluginname & ".public" />
			<cfset local.pluginpath = "/" & Replace(local.plugincomponent, ".", "/", "all") & ".cfc" />

			<cfif Not FileExists(ExpandPath(local.pluginpath))>
				<cfthrow message="Plugin file does not exist." detail="The plugin file, '#local.pluginpath#', could not be found. Please create this plugin file, or remove the plugin syntax from your page." />
			<cfelse>
				<cfinvoke method="init" component="#local.plugincomponent#" argumentcollection="#local.pluginarguments#" returnvariable="local.plugin"></cfinvoke>
	
				<cfset local.content = ReplaceNoCase(local.content, local.i, local.plugin)>			
			</cfif>
		</cfloop>
	
		<cfreturn local.content />
	</cffunction>
	
	<cffunction name="getArguments" output="no" returntype="struct">
		<cfargument name="list" required="yes" hint="A list of name=value pairs to turn into a struct." />
		<cfargument name="delimiter" required="no" default="," />
		
		<cfset var local = {} />

		<cfset local.pluginarguments = {} />
		<cfset local.pluginvalues = ListToArray(arguments.list, arguments.delimiter) />
		
		<cfloop array="#local.pluginvalues#" index="local.i">
			<cfset local.key = ListFirst(local.i, "=") />
			<cfset local.value = Mid(ListRest(local.i, "="), 2, Len(ListRest(local.i, "=")) - 2) />
			<cfset local.status = StructInsert(local.pluginarguments, local.key, local.value, true) />
		</cfloop>
		
		<cfreturn local.pluginarguments />
	</cffunction>
	
</cfcomponent>