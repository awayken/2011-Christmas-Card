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
		<link rel="stylesheet" href="#application.config.domain#/_styles/screen.css">
	</cfoutput>
	<!--[if lt IE 9]>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
	<cfif application.status EQ "live">
		<script type="text/javascript">
			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', 'UA-96981-7']);
			_gaq.push(['_setDomainName', 'milesrauschfamily.com']);
			_gaq.push(['_trackPageview']);
			
			(function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			})();
		</script>
	</cfif>
	</head>
	<body>
		<header>
			<h1><a href="<cfoutput>#application.config.domain#</cfoutput>">Miles<em>Rausch</em>Family<em>.com</em></a></h1>
		</header>
