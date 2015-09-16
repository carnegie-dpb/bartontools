<%@ include file="experiment.inc" %>
<%@ include file="init.inc" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - Log in</title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
		<meta name="description" content="Login to access non-public experiments in Barton Lab Web Tools" />
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
		
		<h1>Log In</h1>

		<p>
			Log into your account so you may view non-public experiments that you own or that have been shared with you.
		</p>

		<form class="login" method="post" action="index.jsp">
			<table class="login">
				<tr>
					<td>Email:</td>
					<td><input type="text" name="email" /></td>
				</tr>
				<tr>
					<td>Password:</td>
					<td><input type="password" name="password" /></td>
				</tr>
				<tr>
					<td></td>
					<td><input class="login" type="submit" name="login" value="Log In"/></td>
				</tr>
			</table>
		</form>

<%@ include file="footer.jhtml" %>
