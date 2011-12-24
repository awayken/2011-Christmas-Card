<cfcomponent displayname="Application" output="no" hint="Application file for this Kindling website.">




<!---
	Application properties.
--->
	<cfset this.name = "2011ChristmasCard" />
	<cfset this.status = "live" />
	<cfset this.loginStorage = "session" />
	<cfset this.sessionManagement = true />
	<cfset this.setClientCookies = true />
	<cfset this.setDomainCookies = false />
	<cfset this.scriptprotect = true />
	<cfset this.sessionTimeout = CreateTimeSpan(0,1,0,0) />
	<cfset this.applicationTimeout = CreateTimeSpan(1,0,0,0) />
	
	
	
	
<!---
	Application methods.
--->
	<cffunction name="onApplicationStart" access="public" output="yes" returnType="boolean">
		<!--- Decent way to get the "home" path for this application --->
		<cfset application.homepath = getDirectoryFromPath(getMetaData(this).path) />
		
		<!--- Parse application config file --->
		<cfset application.config = getApplicationConfig() />
		
		<cftry>
			<!--- Application helpers --->
			<cfset application.helpers = StructNew()>
			<cfset application.helpers.page = createObject("component", "#application.config.library#.page") />
			<cfset application.helpers.plugins = createObject("component", "#application.config.library#.plugins.helper") />
			<cfset application.helpers.templates = createObject("component", "#application.config.library#.templates.helper") />
			
			<cfcatch>
				<cfif application.status EQ "local"><cfdump var="#cfcatch#" label="onApplicationStart - application.helpers"></cfif>
			</cfcatch>
		</cftry>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" output="no" returnType="boolean">
		<cfargument name="Template" type="string" required="true" />
	
		<!--- You can reinitialize the application --->
		<cfif isDefined("URL.reinit")>
			<cfinvoke method="onApplicationStart"></cfinvoke>
		</cfif>
		
		<!--- You can set the status of the application --->
		<cfif isDefined("URL.setstatus")>
			<cfset application.status = URL.setstatus />
		</cfif>
		
		<cftry>
			<!--- Use page helper to parse the current page and add to request scope --->
			<cfset request.page = application.helpers.page.init(ExpandPath(arguments.Template)) />
			
			<cfcatch>
				<cfif application.status EQ "local"><cfdump var="#cfcatch#" label="onRequestStart - page.init"></cfif>
			</cfcatch>
		</cftry>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onRequest" access="public" output="yes" returnType="void">
		<cfargument name="Template" type="string" required="true" />
		
		<cfset var html = "" />
		
		<cftry>
			<!--- Save templated page content in a variable --->
			<cfsavecontent variable="html">
				<!--- If we're not asking for raw and the page has a template --->
				<cfif Not IsDefined("URL.raw") AND Len(request.page.getTemplate())>
					<!--- Run page content through template helper using the appropriate template --->
					<cfoutput>#application.helpers.templates.init(arguments.Template, request.page.getTemplate())#</cfoutput>
					
				<cfelse>
					<!--- Just include the page as-is --->
					<cfinclude template="#arguments.Template#" />
					
				</cfif>
			</cfsavecontent>
			
			<cfcatch>
				<cfif application.status EQ "local"><cfdump var="#cfcatch#" label="onRequest - templates.init"></cfif>
			</cfcatch>
		</cftry>
		
		<cftry>
			<!--- Run our template page through the plugin helper --->
			<cfoutput>#application.helpers.plugins.init(html)#</cfoutput>
			
			<cfcatch>
				<cfif application.status EQ "local"><cfdump var="#cfcatch#" label="onRequest - plugins.init"></cfif>
			</cfcatch>
		</cftry>
		
		<cfreturn />
	</cffunction>
	
	<cffunction name="onRequestEnd" access="public" output="no" returnType="void">
	
		<!--- This is not the function you're looking for --->
		
		<cfreturn />
	</cffunction>
	
	<cffunction name="onError" access="public" output="no" returnType="void">
		<cfargument name="Exception" type="any" required="true" />
		<cfargument name="EventName" type="string" required="false" default="" />
		
		<cfset var local = {} />
		<cfset var errordate = { Date=DateFormat(Now(), "short"), Time=TimeFormat(Now(), "medium") } />
		
		<cfparam name="application.config.error_exemptips" default="127.0.0.1" />
		<cfparam name="application.config.error_timeout" default="300" />
		<cfparam name="application.config.error_email" default="error@localhost" />
		
		<cfset local.exemptIPs = application.config.error_exemptips />
		<cfset local.timeout = application.config.error_timeout />
		<cfset local.emailto = application.config.error_email />
		
		<cfif Not IsDefined("session.LastErrorEmail")>
			<cfset session.LastErrorEmail = DateAdd("s", (-1)*local.timeout, Now()) />
		</cfif>
		
		<cfsavecontent variable="local.errorinfo">
			<h1>#application.applicationname# ERROR MESSAGE</h1>

			<p>
				DATE: #errordate.Date# -- #errordate.Time#<br />
				SERVER: #cgi.http_host#<br />
				REFERER: #cgi.http_referer#<br />
				REMOTE ADDRESS: #cgi.remote_addr#<br />
				BROWSER: #cgi.http_user_agent#
			</p>

			<h2>EXCEPTION</h2>
			<cfdump var="#arguments.exception#" />
			
			<cfif Not StructIsEmpty(URL)>
				<h2>URL VARIABLES</h2>
				<cfdump var="#URL#" />
			</cfif>
			
			<cfif Not StructIsEmpty(FORM)>
				<h2>FORM VARIABLES</h2>
				<cfdump var="#FORM#" />
			</cfif>

			<cfif Not StructIsEmpty(CGI)>
				<h2>CGI VARIABLES</h2>
				<cfdump var="#CGI#" />
			</cfif>
			
			<h2>APPLICATION VARIABLES</h2>
			<cfdump var="#application#" hide="helpers" />
			
			<h2>REQUEST VARIABLES</h2>
			<cfdump var="#request#" hide="page" />
			
			<h2>SESSION VARIABLES</h2>
			<cfdump var="#session#" />
		</cfsavecontent>
		
		<cfif (isDefined("application.status") AND Not ListFind("dev,live", application.status)) OR Not ListFind(local.exemptIPs, CGI.remote_addr)>
			<cfif DateDiff("s", session.LastErrorEmail, Now()) GTE local.timeout>
				<cftry>
					<cfmail from="#local.emailto#" to="#local.emailto#" subject="#application.applicationname# ERROR" type="html">#local.errorinfo#</cfmail>
				
					<cfcatch type="any">
						<cfmail from="#local.emailto#" to="#local.emailto#" subject="#application.applicationname# ERROR HANDLER FAILURE" type="html">
							<h1>#application.applicationname# ERROR MESSAGE</h1>
							
							<p>
								DATE: #errordate.Date# -- #errordate.Time#<br />
								SERVER: #cgi.http_host#<br />
								REFERER: #cgi.http_referer#<br />
								REMOTE ADDRESS: #cgi.remote_addr#<br />
								BROWSER: #cgi.http_user_agent#
							</p>
							
							<h2>CATCH</h2>
							<cfdump var="#cfcatch#" />
		
							<h2>EXCEPTION</h2>
							<cfdump var="#arguments.exception#" />
						</cfmail>
					</cfcatch>
				</cftry>
				
				<cfset session.LastErrorEmail = Now() />
			</cfif>
			
			<cfif FileExists(ExpandPath("_error/index.html"))>
				<cfinclude template="_error/index.html" />
			</cfif>
		<cfelse>
			<cfoutput>#local.errorinfo#</cfoutput>
		</cfif>
		
		<cfreturn />
	</cffunction>




<!---
	Private methods.
--->
	<cffunction name="getApplicationConfig" access="private" output="no" returnType="struct">
		
		<cfset var status = false />
		<cfset var config = { name="", domain="", dsn="", library="" } />
		<cfset var folders = ReplaceNoCase(cgi.script_name, "/index.cfm", "") />
		<cfset var domain = lCase(cgi.http_host & folders) />
		
		<!--- Put a protocol on the domain --->
		<cfif cgi.https eq "ON">
			<cfset domain = "https://" & domain />
		<cfelse>
			<cfset domain = "http://" & domain />
		</cfif>
		
		<!--- Can we find an application config --->
		<cfif FileExists(application.homepath & "/_application.json")>
			<!--- Read in application config, parse, and copy into a config object --->
			<cffile action="read" file="#application.homepath#/_application.json" variable="meta" />
			<cfset status = StructAppend(config, DeserializeJSON(meta)) />
			
			<cfif isDefined("config.local_domain") AND lCase(config.local_domain) EQ domain>
				<!--- The application is on a local server. --->
				<cfset config.domain = config.local_domain />
				<cfset config.dsn = config.local_dsn />
				<cfset config.library = config.local_library />
				<cfset application.status = "local" />
			
			<cfelseif isDefined("config.dev_domain") AND lCase(config.dev_domain) EQ domain>
				<!--- The application is on the development server. --->
				<cfset config.domain = config.dev_domain />
				<cfset config.dsn = config.dev_dsn />
				<cfset config.library = config.dev_library />
				<cfset application.status = "dev" />
			
			<cfelse>
				<!--- The application is on a live or unknown server. --->
				<cfset config.domain = config.live_domain />
				<cfset config.dsn = config.live_dsn />
				<cfset config.library = config.live_library />
				<cfset application.status = "live" />
			
			</cfif>
			
		<!--- If not, let's try to figure it out --->
		<cfelse>
			<!--- Is there a _library folder --->
			<cfif DirectoryExists(application.homepath & "/_library")>
				<!--- Let's make up some bare minimum values --->
				<cfset config.name = CreateUUID()>
				<cfset config.domain = domain />
				<cfset config.library = folders & "_library" />
				
			<cfelse>
				<!--- Okay, we can't figure out the configuration details, so let's complain --->
				<cfthrow message="Configurations details cannot be found." detail="No configuration file or #folders#/_library folder could be found to discern the configuration details of your SMS Campfire website." />
				
			</cfif>
		</cfif>
		
		<cfreturn config />
	</cffunction>
	
	
	
	
</cfcomponent>