<%@ include file="experiment.inc" %>
<%@ include file="init.inc" %>
<%
String message = "";

// posted vars
String schema = Util.getString(request, "schema");
Experiment exp = new Experiment(application, schema);

// boot if user is not an admin of this experiment
if (!user.mayAdminister(application, exp)) {
	response.sendRedirect("/index.jsp");
	return;
}

// grant or revoke view privs
if (Util.getInt(request,"user_id")!=0) {
	User sharee = new User(application, Util.getInt(request,"user_id"));
	boolean share = Util.getBoolean(request,"share");
	if (share) {
		sharee.grantView(application, exp);
		message = sharee.getEmail()+" may now view this experiment.";
	} else {
		sharee.revokeView(application, exp);
		message = sharee.getEmail()+" may no longer view this experiment.";
	}
}
%>
<!DOCTYPE html>
<html>
	<head>
		<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - share an experiment</title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
		<meta name="description" content="Share a non-public experiment with a colleague in Barton Lab Web Tools" />
		<link rel="stylesheet" type="text/css" href="/root.css" />
	</head>
	<body>

		<div class="header">
			<a href="/index.jsp"><img class="cis_logo" src="/images/carnegie-dpb.png" alt="Carnegie Institution for Science - Plant Biology" /></a>
			<div class="heading">Barton Lab Web Tools</div>
		</div>
		
		<h1>Share experiment: <%=exp.title%></h1>

		<div class="message"><%=message%></div>

		<%
		User[] users = User.getAll(application);
		for (int i=0; i<users.length; i++) {
			boolean check = users[i].mayView(application,exp);
			boolean disable = users[i].mayAdminister(application,exp);
		%>
		<form method="post">
			<input type="hidden" name="user_id" value="<%=users[i].getId()%>"/>
			<table>
				<tr>
					<td><input type="checkbox" name="share" onClick="submit()" value="true" <% if (check) out.print("checked"); %> <% if (disable) out.print("disabled"); %> /></td>
					<td><%=users[i].getEmail()%></td>
				</tr>
			</table>
		</form>
		<%
		}
		%>



<%@ include file="footer.jhtml" %>


