<%@ include file="experiment.inc" %>
<%@ include file="init.inc" %>
<!DOCTYPE html>
<html>
    <head>
	<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools</title>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<meta name="description" content="Tools for analysing Arabidopsis thaliana gene data from the Barton Lab in the Department of Plant Biology, Carnegie Institution for Science." />
	<link rel="stylesheet" type="text/css" href="/root.css" />
	<link rel="stylesheet" type="text/css" href="/root-print.css" media="print" />
    </head>
    <body>

	<table class="header" cellspacing="0">
	    <tr>
		<td class="logo"><a href="/index.jsp"><img class="logo" src="/images/carnegie-dpb.png" alt="Carnegie Institution for Science - Plant Biology" /></a></td>
		<td class="heading">
		    <span class="title">Barton Lab Web Tools</span>
		    <br/>
		    <span class="loginStatus">
			<% if (user.isDefault()) { %>
			    <a href="/login.jsp">log in</a> | <a href="/register.jsp">register</a>
			<% } else { %>
			    <%=user.getEmail()%> | <a href="/index.jsp?logout">log out</a>
			<% } %>
		    </span>
		</td>
	    </tr>
	</table>
	
	<% if (error.length()>0) { %><div class="error"><%=error%></div><% } %>
	
	<h1>Public experiments</h1>
	
	<table class="experimentIndex" cellspacing="0">
	    <%
	    Experiment[] publicExperiments = Experiment.getPublic(application);
	    for (int i=0; i<publicExperiments.length; i++) {
	    %>
	    <tr>
		<td class="schema"><a href="<%=publicExperiments[i].schema%>"><%=publicExperiments[i].schema.toUpperCase()%></a></td>
		<td class="species"><%=publicExperiments[i].genus%>&nbsp;<%=publicExperiments[i].species%></td>
		<td class="assay"><%=publicExperiments[i].assay%></td>
		<td class="title"><%=publicExperiments[i].title%></td>
	    </tr>
        <%
        }
        %>
	</table>

	<h1>Non-public experiments</h1>
	<% if (user.isDefault()) { %>
	    <h2><a href="login.jsp">Log in</a> to view experiments shared with you. <a href="register.jsp">Register</a> to create an account.</h2>
	<% } else { %>
	    <h2><%=user.getEmail()%> | <a href="index.jsp?logout">log out</a></h2>
	<% } %>
	<table class="experimentIndex" cellspacing="0">
	    <%
	    Experiment[] privateExperiments = Experiment.getPrivate(application,user);
	    for (int i=0; i<privateExperiments.length; i++) {
	    %>
	    <tr>
		<td class="schema"><a href="<%=privateExperiments[i].schema%>"><%=privateExperiments[i].schema.toUpperCase()%></a></td>
		<td class="species"><%=privateExperiments[i].genus%>&nbsp;<%=privateExperiments[i].species%></td>
		<td class="assay"><%=privateExperiments[i].assay%></td>
		<td class="title"><%=privateExperiments[i].title%> - <a href="share.jsp?schema=<%=privateExperiments[i].schema%>">share</a></td>
	    </tr>
        <%
        }
        %>
	</table>
	

        <%@ include file="footer.jhtml" %>


