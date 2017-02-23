<%
/* code common to all analysis routines */
  
// search logic flags
boolean conditionSearch = request.getParameter("conditionSearch")!=null;
boolean idSearch = request.getParameter("idSearch")!=null;
boolean descriptionSearch = request.getParameter("descriptionSearch")!=null;
boolean tagSearch = Util.getBoolean(request, "tagSearch");

// graphics operations
boolean viewSamples = request.getParameter("viewSamples")!=null;
boolean viewHeatmap = request.getParameter("viewHeatmap")!=null;
boolean viewTimes = request.getParameter("viewTimes")!=null;
boolean viewExpressionTable = request.getParameter("viewExpressionTable")!=null;
boolean viewDETable = request.getParameter("viewDETable")!=null;
boolean viewDETimeTable = request.getParameter("viewDETimeTable")!=null;
boolean viewDEIntersection = request.getParameter("viewDEIntersection")!=null;
boolean viewDECorrelation = request.getParameter("viewDECorrelation")!=null;
boolean viewANOVATable = request.getParameter("viewANOVATable")!=null;
boolean viewCorrelation = request.getParameter("viewCorrelation")!=null;  
boolean viewMonotonicity = request.getParameter("viewMonotonicity")!=null;  
boolean viewGOTerms = request.getParameter("viewGOTerms")!=null;  
boolean graphicsOperation = viewSamples || viewHeatmap || viewTimes || viewExpressionTable || viewDETable || viewDETimeTable || viewDEIntersection || viewANOVATable || viewCorrelation || viewMonotonicity || viewDECorrelation || viewGOTerms;

// selected genes for tagging and plotting
String[] geneIDs = Util.getStringValues(request, "id");

// single gene for tag remove
String geneID = Util.getString(request, "geneID");

// Gene id/name search
String searchIDString = Util.getString(request, "searchIDString").trim().replace("\r","").replace("\t","\n").replace(" ","\n").replace("|","\n");
String[] pieces = searchIDString.split("\n");
TreeSet<String> searchIDSet = new TreeSet<String>();
for (int i=0; i<pieces.length; i++) {
    pieces[i] = pieces[i].trim();
    if (pieces[i].length()>0) {
        boolean found = false;
        String[] ids = Gene.getIDsForName(application, pieces[i], experiment);
        if (ids.length>0) {
            // we matched a search on gene name
            found = true;
            for (int j=0; j<ids.length; j++) searchIDSet.add(ids[j]);
        }
        ids = Gene.getIDsForAlias(application, pieces[i], experiment);
        if (ids.length>0) {
            // we matched a search on gene alias
            found = true;
            for (int j=0; j<ids.length; j++) searchIDSet.add(ids[j]);
        }
        if (!found) {
            // we'll assume it's an Ensembl ID, all caps
            searchIDSet.add(pieces[i].toUpperCase());
        }
    }
}
String[] searchIDs = searchIDSet.toArray(new String[0]);

// gene description search
String searchDescriptionString = Util.getString(request,"searchDescriptionString").trim();

// selected tags
String[] tags = Util.getStringValues(request, "tags");
if (request.getParameter("tagClear")!=null) tags = new String[0];

// tag mode: AND or OR
String tagMode = Util.getString(request, "tagMode");
if (tagMode.length()==0) tagMode = "AND"; // default - keeps number smaller

// tagging operations
if (request.getParameter("addTag")!=null) {
    String tag = Util.getString(request, "tagToAdd");
    Gene[] genes = Gene.searchOnIDs(application, geneIDs);
    for (int i=0; i<genes.length; i++) user.addTag(application, genes[i], tag);
    tagSearch = true;
    tags = new String[1];
    tags[0] = tag;
} else if (request.getParameter("removeTag")!=null) {
    String tag = Util.getString(request, "removeTag");
    Gene g = new Gene(geneID);
    user.removeTag(application, g, tag);
    tagSearch = true;
    tags = new String[1];
    tags[0] = tag;
} else if (request.getParameter("deleteTag")!=null) {
    String tag = Util.getString(request, "deleteTag");
    user.deleteTag(application, tag);
    tags = new String[0];
}

// create a heading with tags
String tagHeading = "";
if (tags.length>0) tagHeading = tags[0];
for (int i=1; i<tags.length; i++) {
    if (tagMode.equals("OR")) tagHeading += " or "+tags[i];
    if (tagMode.equals("AND")) tagHeading += " and "+tags[i];
}

// common graphics parameters
String plotTitle = Util.getString(request, "plotTitle");
if (tags.length>0 && plotTitle.length()==0) plotTitle = tagHeading;

// the genes array is built below
Gene[] genes = new Gene[0];

// load the tags
String[] allTags = user.getTags(application);

// experiment data from DB
Sample[] samples = Sample.getAll(application, experiment);
String[] conditions = Sample.getConditions(application, experiment);
int[] times = Sample.getTimes(application, experiment);

// ------------------------ tool or genome-specific initialization (could be put in includes) ------------------------

// TAIR defaults
boolean tairSearch = request.getParameter("tairSearch")!=null;
String tairterm = Util.getString(request, "tairterm");

// ANOVA defaults
String[] anovaConditions = new String[0];
try {
    anovaConditions = ANOVAResult.getConditions(application, experiment);
} catch (Exception ex) {
    // probably don't have ANOVA results on this experiment
}
String anovaCondition = Util.getString(request, "anovaCondition");
double minConditionQ = 0.00; if (request.getParameter("minConditionQ")!=null) minConditionQ = Util.getDouble(request, "minConditionQ");
double maxConditionQ = 1.00; if (request.getParameter("maxConditionQ")!=null) maxConditionQ = Util.getDouble(request, "maxConditionQ");
double minTimeQ = 0.00; if (request.getParameter("minTimeQ")!=null) minTimeQ = Util.getDouble(request, "minTimeQ");
double maxTimeQ = 1.00; if (request.getParameter("maxTimeQ")!=null) maxTimeQ = Util.getDouble(request, "maxTimeQ");
double minConditionTimeQ = 0.00; if (request.getParameter("minConditionTimeQ")!=null) minConditionTimeQ = Util.getDouble(request, "minConditionTimeQ");
double maxConditionTimeQ = 0.05; if (request.getParameter("maxConditionTimeQ")!=null) maxConditionTimeQ = Util.getDouble(request, "maxConditionTimeQ");
double minCtrl = 0.0; if (request.getParameter("minCtrl")!=null) minCtrl = Util.getDouble(request, "minCtrl");

// Cuffdiff, limma defaults
double minBase = 1.0;
double minlogFC = 2.0; 
double maxpq = 0.01;
if (request.getParameter("minlogFC")!=null) minlogFC = Math.abs(Util.getDouble(request, "minlogFC"));
if (request.getParameter("maxpq")!=null) maxpq = Math.abs(Util.getDouble(request, "maxpq"));
String confidenceTerm = Util.getString(request, "confidenceTerm");
if (confidenceTerm.length()==0) confidenceTerm = "q";
int[] directions = new int[conditions.length];
boolean includeDirections = false;
for (int i=0; i<conditions.length; i++) {
    directions[i] = Util.getInt(request, conditions[i]);
    if (directions[i]!=0) includeDirections = true;
}
%>
