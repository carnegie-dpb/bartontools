<%@ include file="experiment.inc" %>
<%@ include file="init.inc" %>
<%
String message = "";
boolean showForm = true;

if (request.getParameter("register")!=null) {
	String email = Util.getString(request, "email");
	String password = Util.getString(request, "password");
	try {
		User.sendConfirmation(request, email, password);
		message = "A confirmation of your registration should appear in your email, with a link to activate your account.";
		showForm = false;
	} catch (Exception ex) {
		error = ex.getMessage();
	}
}

if (request.getParameter("confirmationKey")!=null) {
	String confirmationKey = Util.getString(request, "confirmationKey");
	try {
		User.confirmAccount(application, confirmationKey);
		message = "Your account has been activated and you may now log in.";
		showForm = false;
	} catch (Exception ex) {
		error = ex.getMessage();
		showForm = false;
	}
}
%>
<!DOCTYPE html>
<html>
	<head>
		<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - Register</title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
		<meta name="description" content="Register to access non-public experiments in Barton Lab Web Tools" />
		<link rel="stylesheet" type="text/css" href="/root.css" />
	</head>
	<body>

		<table class="header" cellspacing="0">
			<tr>
				<td class="logo"><a href="/index.jsp"><img src="/images/PB_CISLogo_2c_RGB.png" alt="Carnegie Institution for Science - Plant Biology" /></a></td>
				<td class="heading">
					<span class="title">Barton Lab Web Tools</span>
				</td>
			</tr>
		</table>
		
		<h1>Register</h1>

		<p>
			Register an account so your colleagues can share their non-public experiments with you.
		</p>

		<% if (error.length()>0) { %><div class="error"><%=error%></div><% } %>
		<% if (message.length()>0) { %><div class="message"><%=message%></div><% } %>

		<% if (showForm) { %>
			<!-- registration form -->
			<form class="login" method="post" action="register.jsp">
				<table class="login">
					<tr>
						<td>Email:</td>
						<td><input type="text" name="email"/></td>
					</tr>
					<tr>
						<td>Password:</td>
						<td><input type="password" name="password"/></td>
					</tr>
					<tr>
						<td></td>
						<td><input class="login" type="submit" name="register" value="Register"/></td>
					</tr>
				</table>
			</form>
		<% } %>

<%@ include file="footer.jhtml" %>
