<cfcomponent displayname="filecache">

<cffunction name="cacheFile" output="no" access="public" returntype="string">
	<cfargument name="filepath" required="Yes" type="string" hint="Full path with filename of the fileto cache" />
	<cfargument name="remoteurl" required="Yes" type="string" hint="Location of the file to cache, must be a valid url" />
	<cfargument name="cachetime" required="Yes" type="numeric" hint="Time in **DatePart** to cache the file" />
	<cfargument name="datepart" required="No" default="n" type="string" hint="Datepart for cache comparison, defaults to minutes" />
	<cfargument name="urlparams" required="No" default="#structnew()#" type="struct" hint="Additional parameters to be passed to the remoteurl" />
	<cfargument name="method" required="No" default="get" type="string" />
	<cfargument name="forcenewcache" required="No" default="0" type="boolean" hint="Force the cache to update immediatly" />
	<cfargument name="timeout" required="No" default="10" type="numeric" hint="Time in seconds to try to get the file" />
	<cfargument name="username" required="No" default="" type="string" hint="Username for the URL if necessary" />
	<cfargument name="password" required="No" default="" type="string" hint="Password for the URL if necessary" />
	<cfargument name="multiparttype" required="No" default="form-data" type="string" hint="Available options: form-data/related. Default is form-data, but related is required for google/youtube" />
	<cfargument name="useragent" required="No" default="Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3" type="string" hint="User agent, some sites will not process without one" />
	<cfset var file = '' /> <!--- (File to be returned) --->
	<cfset var paramtype = 'url' />
	<cfset var fileObj = '' />
	<cfset var fileDate = '' />

	<cfif arguments.method eq 'post'>
		<cfset paramtype = 'formfield' />
	</cfif>

	<cfif findnocase("gdata.youtube", arguments.remoteurl, 1) neq 0>
		<cfset arguments.multiparttype = "related" />
	</cfif>

	<!--- (If an absolute path is not provided, get one) --->
<!---
	<cfif left(arguments.filepath,1) eq '/'>
		<cfset arguments.filepath = expandpath(filepath) />
	</cfif>
--->
	
	<!--- (Get Last Modifed time) --->
	<cfset fileObj = createObject("java","java.io.File").init(arguments.filepath)>
	<cfset fileDate = createObject("java","java.util.Date").init(fileObj.lastModified())>

	<cftry>
		<cfif (datediff(arguments.datepart,fileDate,now()) gte arguments.cachetime) or (not fileexists(filepath)) or (arguments.forcenewcache)>
			<!--- (File should be updated) --->
			<cfif len(arguments.username) and len(arguments.password)>
				<cfhttp url="#arguments.remoteurl#" method="#arguments.method#" username="#arguments.username#" password="#arguments.password#" timeout="#arguments.timeout#" multiparttype="#arguments.multiparttype#" useragent="#arguments.useragent#" charset="utf-8">
					<cfhttpparam type="Header" name="Accept-Encoding" value="deflate;q=0"> 
					<cfhttpparam type="Header" name="TE" value="deflate;q=0">
					<cfloop collection="#arguments.urlparams#" item="key">
						<cfhttpparam name="#key#" type="#paramtype#" value="#arguments.urlparams[key]#" />
					</cfloop>
				</cfhttp>
			<cfelse>
				<cfhttp url="#arguments.remoteurl#" method="#arguments.method#" timeout="#arguments.timeout#" multiparttype="#arguments.multiparttype#" useragent="#arguments.useragent#" charset="utf-8">
					<cfhttpparam type="Header" name="Accept-Encoding" value="deflate;q=0"> 
					<cfhttpparam type="Header" name="TE" value="deflate;q=0">
					<cfloop collection="#arguments.urlparams#" item="key">
						<cfhttpparam name="#key#" type="#paramtype#" value="#arguments.urlparams[key]#" />
					</cfloop>
				</cfhttp>
			</cfif>
			
			<cfif cfhttp.statuscode eq '200 OK'>
				<cfif len(cfhttp.charset)>
					<cfset charset = cfhttp.charset />
				<cfelse>
					<cfset charset = 'utf-8' />
				</cfif>
				
				<cffile action="write" file="#filepath#" output="#cfhttp.filecontent#" charset="#charset#">
				<cfset file = cfhttp.filecontent />
			<cfelse>
				<!--- (Read in the existing file if there is one) --->
				<cffile action="read" file="#filepath#" variable="file" charset="utf-8">
			</cfif>
		<cfelse>
			<!--- (Read in the existing file) --->
			<cffile action="read" file="#filepath#" variable="file" charset="utf-8">
		</cfif>

		<cfcatch type="any">
			<!--- (Something failed, return nothing) --->
			<cfset file = '' />
		</cfcatch>
	</cftry>
	
	<cfreturn file />
	
</cffunction>

</cfcomponent>