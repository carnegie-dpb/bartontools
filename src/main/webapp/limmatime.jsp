<%@ include file="experiment.inc" %>
<%@ include file="../init.inc" %>
<%@ include file="../common.inc" %>
<%
if (idSearch) {
	genes = Gene.searchOnIDs(application, searchIDs);
} else if (descriptionSearch) {
	genes = Gene.searchOnDescriptions(application, experiment, searchDescriptionString);
} else if (tagSearch) {
	genes = Gene.getForTags(application, tags, tagMode);
} else if (tairSearch) {
	genes = TAIRGene.searchOnComputationalDescription(application, experiment, tairterm);
} else if (conditionSearch && includeDirections) {
	genes = LimmaTimeResult.searchOnDirections(application, experiment, conditions, minlogFC, maxpq, confidenceTerm, directions);
} else if (conditionSearch) {
	genes = LimmaTimeResult.search(application, experiment, conditions, minlogFC, maxpq, confidenceTerm);
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
<%@ include file="limmatime.jhtml" %>
<% } %>
<%@ include file="../footer.jhtml" %>
