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
	
	<cffunction name="init" output="no" access="public" returntype="string">
		<cfargument name="service" type="string" required="yes" />
		<cfargument name="url" type="string" required="yes" />
		
		<cfset var local = {} />
		
		<cfset local.oembedurl = "" />
		<cfset local.html = "" />
		
		<cfswitch expression="#arguments.service#">
			<cfcase value="flickr">
				<cfset local.oembedurl = "http://www.flickr.com/services/oembed/?maxheight=450&maxwidth=450&url=" & UrlEncodedFormat(arguments.url) />
			</cfcase>
			
			<cfcase value="youtube">
				<cfset local.oembedurl = "http://www.youtube.com/oembed?maxheight=450&maxwidth=450&url=" & UrlEncodedFormat(arguments.url) />
			</cfcase>
			
		</cfswitch>
		
		<cfif Len(local.oembedurl)>
			<cfhttp method="get" url="#local.oembedurl#&format=xml"></cfhttp>
			
			<cfif cfhttp.StatusCode EQ "200 OK">
				<cfset local.oembed = XmlParse(cfhttp.filecontent) />
				
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
							<cfset local.html = '<a href="#arguments.url#" target="_blank"><img src="#local.oembed.oembed.url.XmlText#" alt="#local.imagetitle#" title="#local.imagetitle#" class="oembed_flickr"></a>' />
						</cfif>
					</cfcase>
					
					<cfcase value="youtube">
						<cfif StructKeyExists(local.oembed.oembed, "html")>
							<cfset local.html = local.oembed.oembed.html.XmlText />
						</cfif>
					</cfcase>
					
				</cfswitch>
			</cfif>
		</cfif>
		
		<cfreturn local.html />
	</cffunction>
</cfcomponent>