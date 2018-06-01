<%
// the schema for this experiment
String SCHEMA = "e-mtab-4316";

// bail if more than this many matches is reached
int MAXMATCHES = 1000;

// the experiment object holds all the metadata
Experiment experiment = new Experiment(application, SCHEMA);  
%>
