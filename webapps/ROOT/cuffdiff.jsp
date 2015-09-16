<%@ include file="experiment.inc" %>
<%@ include file="../init.inc" %>
<%@ include file="../common.inc" %>
<%
if (idSearch) {
  genes = Gene.searchOnIDs(application, searchIDs);
} else if (tagSearch && tags.length>0) {
  genes = Gene.getForTags(application, tags, tagMode);
} else if (tairSearch) {
  genes = TAIRGene.searchOnComputationalDescription(application, experiment, tairterm);
} else if (conditionSearch && includeDirections) {
  genes = CuffdiffTimeResult.searchOnDirections(application, experiment, conditions, minlogFC, maxpq, confidenceTerm, directions);
} else if (conditionSearch) {
  genes = CuffdiffTimeResult.search(application, experiment, conditions, minlogFC, maxpq, confidenceTerm);
} else if (geneIDs.length>0) {
  genes = Gene.searchOnIDs(application, geneIDs);
}

// abort if too many genes for display
boolean tooMany = genes.length>MAXMATCHES;
if (tooMany) {
  error = "Your search returned "+genes.length+" results; please narrow your search criteria.";
  genes = new TAIRGene[0];
}
%>
<%@ include file="../header.jhtml" %>
<%@ include file="nav.jhtml" %>
<%@ include file="viewers.jhtml" %>
<% if (!viewSelected) { %>
<%@ include file="cuffdiff.jhtml" %>
<% } %>
<%@ include file="../footer.jhtml" %>