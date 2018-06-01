<%@ include file="experiment.inc" %>
<%@ include file="../init.inc" %>
<%@ include file="../common.inc" %>
<%
// posted vars
String gene1input = Util.getString(request, "gene1input");
String gene2input = Util.getString(request, "gene2input");

// gene 1 (required) converted to ID
String gene1ID = Gene.getIdForName(application, gene1input);
if (gene1ID==null) gene1ID = gene1input.toUpperCase(); // assume it's an ID
Gene gene1 = new Gene(application, gene1ID);

// gene 2 (optional)
Gene gene2 = null;
if (gene2input.length()>0) {
	String gene2ID = Gene.getIdForName(application, gene2input);
	if (gene2ID==null) gene2ID = gene2input.toUpperCase(); // assume it's an ID
	gene2 = new Gene(application, gene2ID);
}

double corrThreshold = 0.95; // default value
if (request.getParameter("corrThreshold")!=null) corrThreshold = Util.getDouble(request, "corrThreshold");

int polarity = Util.getInt(request, "polarity");

// conditions over which to calculate correlation - if none, then select all conditions
String[] corrConditions = Util.getStringValues(request, "corrConditions");
if (corrConditions.length==0) corrConditions = conditions;

if (conditionSearch && gene1!=null && gene2==null && corrConditions.length>0) {
	genes = CorrelationResult.search(application, experiment, gene1, corrConditions, corrThreshold, polarity);
} else if (conditionSearch && gene1!=null && gene2!=null && corrConditions.length>0) {
	genes = CorrelationResult.search(application, experiment, gene1, gene2, corrConditions, corrThreshold);
} else if (geneIDs.length>0) {
	genes = Gene.searchOnIDs(application, geneIDs);
}

// abort if too many genes for display
boolean tooMany = genes.length>MAXMATCHES;
if (tooMany) {
	error = "Your search returned "+genes.length+" results; please narrow your search criteria.";
	genes = new Gene[0];
}
%>
<%@ include file="../header.jhtml" %>
<%@ include file="nav.jhtml" %>
<%@ include file="viewers.jhtml" %>
<% if (!viewSelected) { %>  
	<%@ include file="cminer.jhtml" %>
<% } %>
<%@ include file="../footer.jhtml" %>
