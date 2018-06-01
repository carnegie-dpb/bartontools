<%@ page import="edu.carnegiescience.dpb.bartonlab.*" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.File" %>
<%@ page import="java.awt.BasicStroke, java.awt.Color, java.awt.Font" %>
<%@ page import="java.util.Arrays,java.util.ArrayList,java.util.HashMap,java.util.List,java.util.TreeSet,java.util.regex.Pattern,java.text.DecimalFormat" %>
<%@ page import="org.apache.commons.math3.stat.StatUtils,org.apache.commons.math3.stat.correlation.PearsonsCorrelation,org.apache.commons.math3.stat.correlation.SpearmansCorrelation" %>
<%@ page import="org.jfree.chart.JFreeChart,org.jfree.chart.ChartFactory,org.jfree.chart.axis.LogAxis,org.jfree.chart.axis.LogarithmicAxis,org.jfree.chart.axis.NumberAxis,org.jfree.chart.axis.SymbolAxis,org.jfree.chart.plot.PlotOrientation,org.jfree.chart.plot.XYPlot,org.jfree.data.xy.DefaultXYDataset,org.jfree.data.xy.DefaultXYZDataset,org.jfree.chart.renderer.xy.XYBlockRenderer,org.jfree.chart.servlet.ServletUtilities,org.jfree.data.general.DatasetUtils,org.jfree.chart.annotations.XYLineAnnotation,org.jfree.chart.annotations.XYTextAnnotation,org.jfree.chart.ui.RectangleAnchor,org.jfree.chart.ui.TextAnchor,org.jfree.chart.renderer.LookupPaintScale,org.jfree.chart.title.TextTitle" %>
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
        response.sendRedirect("../index.jsp");
    }
}
%>
