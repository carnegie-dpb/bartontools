<%@ page import="edu.carnegiescience.dpb.bartonlab.*" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.File,java.util.*,java.text.*,java.util.regex.Pattern" %>
<%@ page import="java.awt.BasicStroke, java.awt.Color, java.awt.Font" %>
<%@ page import="org.jfree.chart.*, org.jfree.chart.annotations.*, org.jfree.chart.axis.*, org.jfree.chart.plot.*, org.jfree.chart.title.*" %>
<%@ page import="org.jfree.chart.renderer.*, org.jfree.chart.renderer.category.*, org.jfree.chart.renderer.xy.*" %>
<%@ page import="org.jfree.data.*, org.jfree.data.general.*, org.jfree.data.xy.*, org.jfree.chart.servlet.*, org.jfree.ui.*" %>
<%@ page import="org.apache.commons.math3.stat.StatUtils,org.apache.commons.math3.stat.correlation.PearsonsCorrelation,org.apache.commons.math3.stat.correlation.SpearmansCorrelation" %>
<%
// generic error message
String error = "";

// define formats here for consistency across the app
DecimalFormat expFormat = new DecimalFormat("0.0E00");
DecimalFormat countFormat = new DecimalFormat("#");
DecimalFormat timeFormat = new DecimalFormat("#");
DecimalFormat fractionFormat = new DecimalFormat("#0.000");
DecimalFormat logFCFormat = new DecimalFormat("#0.00");

DecimalFormat pFormat = new DecimalFormat("#0.00");
DecimalFormat percentFormat = new DecimalFormat("#0.0%");
DecimalFormat corrFormat = new DecimalFormat("#0.000");
DecimalFormat yaxisFormat = new DecimalFormat("0.0E0");

// initialize user
User user = new User();
if (session.getAttribute("user")!=null) user = (User) session.getAttribute("user");

// execute login
if (request.getParameter("login")!=null) {
    user = new User(application, Util.getString(request,"email"), Util.getString(request,"password"));
    if (user.isConfirmed() && !user.isDefault()) {
        session.setAttribute("user", user);
    } else {
        session.removeAttribute("user");
        user = new User();
        error = "You have provided invalid account credentials, or your account has not yet been activated.";
    }
}

// execute logout
if (request.getParameter("logout")!=null) {
    session.removeAttribute("user");
    user = new User();
}

// bump user if not authorized for selected experiment
if (experiment!=null && !experiment.publicdata) {
    if (user.isDefault() || !user.mayView(application,experiment)) {
        response.sendRedirect("/index.jsp");
    }
}
%>
