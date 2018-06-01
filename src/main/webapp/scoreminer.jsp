<%@ include file="experiment.inc" %>
<%@ include file="../init.inc" %>
<%@ include file="../common.inc" %>
<%
// max Levenshtein distance
int maxDistance = 0; // default
if (request.getParameter("maxDistance")!=null) maxDistance = Util.getInt(request, "maxDistance");

// convert gene name to ID
String id = Gene.getIdForName(application, geneID);
if (id==null) id = geneID.toUpperCase(); // assume it's an ID
Gene gene = new Gene(application, id);
geneID = gene.id;

if (idSearch) {
  genes = Gene.searchOnIDs(application, searchIDs);
} else if (tagSearch) {
  genes = Gene.getForTags(application, tags, tagMode);
} else if (tairSearch) {
  genes = TAIRGene.searchOnComputationalDescription(application, experiment, tairterm);
} else if (conditionSearch) {
      genes = DEScore.scoreSearch(application, experiment, gene, maxDistance);
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
<%@ include file="scoreminer.jhtml" %>
<% } %>
<%@ include file="../footer.jhtml" %>
