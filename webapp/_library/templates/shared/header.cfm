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
		<link rel="stylesheet" href="#application.config.domain#/_styles/screen.css">
	</cfoutput>
	</head>
	<body>
		<header>
			<h1><a href="http://milesrauschfamily.com">MilesRauschFamily.com</a></h1>
		</header>
