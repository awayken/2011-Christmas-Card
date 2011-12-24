<cfif application.status EQ "live">
	<cfsetting showDebugOutput="no" />
</cfif>
<!DOCTYPE html>
<html lang="en">
	<head>
	<cfoutput>
		<cfset local.title = request.page.getTitle()>
		<cfset local.desc = request.page.getDescription()>
		<meta charset="utf-8">
		<title><cfif Len(local.title)>#local.title# &mdash; </cfif>2011 Miles Rausch Family Christmas Card</title>
	<cfif Len(local.desc)>
		<meta name="description" content="#local.desc#">
	</cfif>
		<meta name="viewport" content="width=device-width, maximum-scale=1, initial-scale=1">
		<link rel="stylesheet" href="#application.config.domain#/_styles/screen.css">
	</cfoutput>
	</head>
	<body>
		<header>
			<h1><a href="<cfoutput>#application.config.domain#</cfoutput>">Miles<em>Rausch</em>Family<em>.com</em></a></h1>
		</header>
