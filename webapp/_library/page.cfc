<cfcomponent displayname="Page Front-end" output="no">

	<cfset pagepath = "" />
	<cfset pageurl = "" />
	<cfset template = "" />
	<cfset name = "" />
	<cfset title = "" />
	<cfset description = "" />
	<cfset keywords = "" />
	<cfset visible = false />
	<cfset headers = StructNew() />
	<cfset footers = StructNew() />
	
	<cffunction name="init" output="no" returnType="page">
		<cfargument name="targetpagepath" required="true"
			hint="The expanded path of the page to initialize." />
	
		<cfscript>
			var pagedata = getPage(arguments.targetpagepath);
			
			setPath(lCase(Replace(arguments.targetpagepath, "\", "/", "all")));
			setURL(application.config.domain & "/" & ReplaceNoCase(getPath(), application.homepath, ""));
			setTemplate(pagedata.template);
			setName(pagedata.name);
			setTitle(pagedata.title);
			setDescription(pagedata.description);
			setKeywords(pagedata.keywords);
			setVisibility(YesNoFormat(pagedata.visible));
			setHeaders(pagedata.headers);
			setFooters(pagedata.footers);
		</cfscript>
	
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPage" output="no" access="private" returnType="struct">
		<cfargument name="targetpagepath" required="true"
			hint="The relative path of the page to get metadata for." />
	
		<cfset var fullpath = arguments.targetpagepath />
		<cfset var meta = StructNew() />
		
		<cfif DirectoryExists(fullpath)>
			<cfset fullpath = fullpath & "/index.json" />
		<cfelseif FileExists(fullpath)>
			<cfset fullpath = Left(fullpath, Len(fullpath) - Find(".", Reverse(fullpath))) & ".json" />
		</cfif>
	
		<cfif FileExists(fullpath)>
			<cffile action="read" file="#fullpath#" variable="metafile" />
			
			<cfset meta = DeserializeJson(metafile) />
		</cfif>
		
		<cfparam name="meta.template" default="" />
		<cfparam name="meta.name" default="#Replace(arguments.targetpagepath, "index.cfm", "")#" />
		<cfparam name="meta.title" default="" />
		<cfparam name="meta.description" default="" />
		<cfparam name="meta.keywords" default="" />
		<cfparam name="meta.visible" default="false" />
		<cfparam name="meta.headers" default="#StructNew()#" />
		<cfparam name="meta.footers" default="#StructNew()#" />
	
		<cfreturn meta />
	</cffunction>
	
	<!--- Page URL --->
	<cffunction name="getURL" output="no" returnType="any">
		<cfreturn pageurl />
	</cffunction>
	<cffunction name="setURL" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset pageurl = arguments.input />
	</cffunction>
	<cffunction name="displayURL" output="yes" returnType="void">
		<cfoutput>#getURL()#</cfoutput>
	</cffunction>
	
	<!--- Page Path --->
	<cffunction name="getPath" output="no" returnType="string">
		<cfreturn pagepath />
	</cffunction>
	<cffunction name="setPath" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset pagepath = arguments.input />
	</cffunction>
	<cffunction name="displayPath" output="yes" returnType="void">
		<cfoutput>#getPath()#</cfoutput>
	</cffunction>
	
	<!--- Template --->
	<cffunction name="getTemplate" output="no" returnType="string">
		<cfreturn template />
	</cffunction>
	<cffunction name="setTemplate" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset template = arguments.input />
	</cffunction>
	<cffunction name="displayTemplate" output="yes" returnType="void">
		<cfoutput>#getTemplate()#</cfoutput>
	</cffunction>

	<!--- Name --->
	<cffunction name="getName" output="no" returnType="string">
		<cfreturn name />
	</cffunction>
	<cffunction name="setName" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset name = arguments.input />
	</cffunction>
	<cffunction name="displayName" output="yes" returnType="void">
		<cfoutput>#getName()#</cfoutput>
	</cffunction>
	
	<!--- Title --->
	<cffunction name="getTitle" output="no" returnType="string">
		<cfreturn title />
	</cffunction>
	<cffunction name="setTitle" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset title = arguments.input />
	</cffunction>
	<cffunction name="displayTitle" output="yes" returnType="void">
		<cfoutput>#getTitle()#</cfoutput>
	</cffunction>
	
	<!--- Description --->
	<cffunction name="getDescription" output="no" returnType="string">
		<cfreturn description />
	</cffunction>
	<cffunction name="setDescription" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset description = arguments.input />
	</cffunction>
	<cffunction name="displayDescription" output="yes" returnType="void">
		<cfoutput>#getDescription()#</cfoutput>
	</cffunction>
	
	<!--- Keywords --->
	<cffunction name="getKeywords" output="no" returnType="string">
		<cfreturn keywords />
	</cffunction>
	<cffunction name="setKeywords" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset keywords = arguments.input />
	</cffunction>
	<cffunction name="displayKeywords" output="yes" returnType="void">
		<cfoutput>#getKeywords()#</cfoutput>
	</cffunction>
	
	<!--- Visibility --->
	<cffunction name="getVisibility" output="no" returnType="string">
		<cfreturn visible />
	</cffunction>
	<cffunction name="setVisibility" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset visible = arguments.input />
	</cffunction>
	<cffunction name="displayVisibility" output="yes" returnType="void">
		<cfoutput>#getVisibility()#</cfoutput>
	</cffunction>
	
	<!--- Headers --->
	<cffunction name="getHeaders" output="no" returnType="struct">
		<cfreturn headers />
	</cffunction>
	<cffunction name="setHeaders" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset headers = arguments.input />
	</cffunction>
	<cffunction name="displayHeaders" output="yes" returnType="void">
		<cfoutput>#makeHeaderFooterHTML(getHeaders())#</cfoutput>
	</cffunction>
	
	<!--- Footers --->
	<cffunction name="getFooters" output="no" returnType="struct">
		<cfreturn footers />
	</cffunction>
	<cffunction name="setFooters" output="no" returnType="void">
		<cfargument name="input" required="true" />
		<cfset footers = arguments.input />
	</cffunction>
	<cffunction name="displayFooters" output="yes" returnType="void">
		<cfoutput>#makeHeaderFooterHTML(getFooters())#</cfoutput>
	</cffunction>
	
	<!--- Make the HTML for the Headers and Footers --->
	<cffunction name="makeHeaderFooterHTML" output="no" returnType="string">
		<cfargument name="input" required="true" />
		
		<cfset var styles = "" />
		<cfset var htmls = "" />
		<cfset var scripts = "" />
		<cfset var i = "" />
		
		<cfif StructKeyExists(arguments.input, "styles")>
			<cfsavecontent variable="styles"><cfoutput>
			<cfloop list="#arguments.input.styles#" index="i">
				<link rel="stylesheet" type="text/css" href="#i#" />
			</cfloop>
			</cfoutput></cfsavecontent>
		</cfif>
		
		<cfif StructKeyExists(arguments.input, "html")>
			<cfsavecontent variable="htmls"><cfoutput>
				#arguments.input.html#
			</cfoutput></cfsavecontent>
		</cfif>
		
		<cfif StructKeyExists(arguments.input, "scripts")>
			<cfsavecontent variable="scripts"><cfoutput>
			<cfloop list="#arguments.input.scripts#" index="i">
				<script language="javascript" type="text/javascript" src="#i#"></script>
			</cfloop>
			</cfoutput></cfsavecontent>
		</cfif>
		
		<cfreturn styles & htmls & scripts />
	</cffunction>
	
	<!--- Get a query of the child pages and directories to the request page. --->
	<cffunction name="getChildren" output="yes" access="public" returnType="query">
		<cfargument name="ShowAll" type="boolean" default="false" hint="If true, will show all children instead of just those with true Visible." />
		
		<cfset var dir = { Path = getPath(), URL = getURL(), list = QueryNew("") } />
		<cfset var child = {} />
		<cfset var children = QueryNew("URL, Name, Title, Description, Visible", "varchar, varchar, varchar, varchar, bit") />
		
		<!--- If the path isn't a directory, remove index.cfm from the path --->
		<cfif Not DirectoryExists(dir.path)>
			<cfset dir.path = ReplaceNoCase(dir.path, "index.cfm", "") />
			<cfset dir.url = ReplaceNoCase(dir.url, "index.cfm", "") />
		</cfif>

		<!--- Is it a directory now? --->
		<cfif DirectoryExists(dir.path)>
			<cfdirectory action="list" directory="#dir.path#" name="dir.list" />
			
			<!--- Loop the children --->
			<cfloop query="dir.list">
				<cfset child.url = "" />
				
				<!--- Find all JSON files --->
				<cfif FindNoCase(".json", dir.list.name)>
				
					<!--- Set the URL, path, and JSON values --->
					<cfset child.url = dir.url & ReplaceNoCase(dir.list.name, ".json", ".cfm") />
					<cfset child.path = dir.path & ReplaceNoCase(dir.list.name, ".json", ".cfm") />
					<cfset child.json = dir.path & "/" & dir.list.name />
					
				<!--- Find all child directories --->
				<cfelseif lCase(dir.list.type) EQ "dir">
				
					<!--- Set the URL, path, and JSON values --->
					<cfset child.url = dir.url & dir.list.name & "/index.cfm" />
					<cfset child.path = dir.path & dir.list.name & "/index.cfm" />
					<cfset child.json = dir.path & "/" & dir.list.name & "/index.json" />
					
				</cfif>
				
				<!--- We need a URL, a JSON file and an actual file to continue --->
				<cfif len(child.url) AND FileExists(child.json) AND FileExists(child.path) AND (lCase(child.url) NEQ lCase(getURL()))>
					<!--- Read in JSON file --->
					<cffile action="read" file="#child.json#" variable="child.file" />
					
					<cfscript>
						// Set default meta values
						child.meta = { URL = "", Name = "", Title = "", Description = "", Visible = false };
						
						// Copy in the values from the JSON file
						StructAppend(child.meta, DeserializeJSON(child.file));
						
						// If we chose ShowAll or not ShowAll and page is visible
						if (arguments.ShowAll OR (Not arguments.ShowAll AND child.meta.visible)) {
						
							// Add a new row to our Children query
							QueryAddRow(children);
							QuerySetCell(children, "URL", child.url);
							QuerySetCell(children, "Name", child.meta.name);
							QuerySetCell(children, "Title", child.meta.title);
							QuerySetCell(children, "Description", child.meta.description);
							QuerySetCell(children, "Visible", child.meta.visible);
						}
					</cfscript>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn children />
	</cffunction>
	
</cfcomponent>