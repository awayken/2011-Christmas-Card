<!---
Plugin Name: oEmbed
Description: Turns oEmbed data for a URL and service into some simple HTML.
Author: Miles Rausch
Version: 1.0
Author URI: http://www.awayken.com
Additional information: http://oembed.com/
--->
<cfcomponent output="no">
	<cfset this.path = application.homepath & "/_library/plugins/oembed" />
	
	<cffunction name="init" output="yes" access="public" returntype="string">
		<cfargument name="service" type="string" required="yes" />
		<cfargument name="url" type="string" required="yes" />
		<cfargument name="maxwidth" type="numeric" required="no" default="450" />
		<cfargument name="maxheight" type="numeric" required="no" default="450" />
		
		<cfset var local = {} />
		
		<cfset local.oembedurl = "" />
		<cfset local.html = "" />
		
		<cfswitch expression="#arguments.service#">
			<cfcase value="flickr">
				<cfset local.oembedurl = "http://www.flickr.com/services/oembed/?url=" & UrlEncodedFormat(arguments.url) />
			</cfcase>
			
			<cfcase value="youtube">
				<cfset local.oembedurl = "http://www.youtube.com/oembed?url=" & UrlEncodedFormat(arguments.url) />
			</cfcase>
			
		</cfswitch>
		
		<cfif Len(local.oembedurl)>
			<cfif Val(arguments.maxwidth)>
				<cfset local.oembedurl = local.oembedurl & "&maxwidth=" & Val(arguments.maxwidth) />
			</cfif>
			<cfif Val(arguments.maxheight)>
				<cfset local.oembedurl = local.oembedurl & "&maxheight=" & Val(arguments.maxheight) />
			</cfif>
			
			<cfif Not DirectoryExists(this.path & "/_files")>
				<cfdirectory action="create" directory="#this.path#/_files" />
			</cfif>
			
			<cfinvoke component="#application.config.library#.filecache" method="cacheFile" returnvariable="local.filecache">
				<cfinvokeargument name="remoteurl" value="#local.oembedurl#&format=xml" />
				<cfinvokeargument name="filepath" value="#this.path#/_files/#hash(local.oembedurl, "md5")#.xml" />
				<cfinvokeargument name="cachetime" value="60" />
				<cfinvokeargument name="forcenewcache" value="#IsDefined('url.reset')#" />
			</cfinvoke>
			
			<cfset local.oembed = XmlParse(local.filecache) />
			
			<cfswitch expression="#arguments.service#">
				<cfcase value="flickr">
					<cfif StructKeyExists(local.oembed.oembed, "title") AND Len(local.oembed.oembed.title.XmlText)>
						<cfset local.imagetitle = HtmlEditFormat(local.oembed.oembed.title.XmlText) />
					<cfelse>
						<cfset local.imagetitle = "This image" />
					</cfif>
					
					<cfif StructKeyExists(local.oembed.oembed, "author_name")>
						<cfset local.imagetitle = local.imagetitle & " by " & HtmlEditFormat(local.oembed.oembed.author_name.XmlText) />
					</cfif>
					
					<cfif StructKeyExists(local.oembed.oembed, "url")>
						<cfset local.html = '<div class="oembed_flickr"><a href="#arguments.url#" target="_blank"><img src="#local.oembed.oembed.url.XmlText#" alt="#local.imagetitle#" title="#local.imagetitle#" class="oembed_flickr"></a></div>' />
					</cfif>
				</cfcase>
				
				<cfcase value="youtube">
					<cfif StructKeyExists(local.oembed.oembed, "html")>
						<cfset local.html = '<div class="oembed_youtube">' & Replace(local.oembed.oembed.html.XmlText, "&", "&amp;", "all") & '</div>' />
					</cfif>
				</cfcase>
				
			</cfswitch>
		</cfif>
		
		<cfreturn local.html />
	</cffunction>
</cfcomponent>