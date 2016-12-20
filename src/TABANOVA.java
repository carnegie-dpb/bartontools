package edu.carnegiescience.dpb.bartonlab;

import java.io.File; 
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;

import javax.naming.NamingException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Outputs a tab-delimited text file containing ANOVA data.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2370 $ $Date: 2013-12-19 13:23:30 -0600 (Thu, 19 Dec 2013) $
 */
public class TABANOVA extends HttpServlet {

    /**
     * @see javax.servlet.GenericServlet#init(javax.servlet.ServletConfig)
     */
    public void init(ServletConfig config) throws ServletException {
	super.init(config);
    }

    /**
     * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	doPost(request, response);
    }
  
    /**
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	// show doubles with scientific notation here
	DecimalFormat expFormat = new DecimalFormat("0.00E0");
    
	// DB connection
	DB db = null;

	try {

	    // get posted variables
	    String schema = Util.getString(request, "schema");

	    // use a single db connection throughout
	    db = new DB(request.getSession().getServletContext(), schema);

	    // get the genes
	    String[] geneIDs = Util.getStringValues(request, "geneID");
	    Gene[] genes = new Gene[geneIDs.length];
	    for (int i=0; i<genes.length; i++) genes[i] = new Gene(db, geneIDs[i]);

	    // write to a StringBuffer 
	    StringBuffer buffer = new StringBuffer();

	    // first row = meta-headings
	    // second row = headings
	    buffer.append("geneID\tgeneShortName\t");
	    buffer.append("conditions\t");
	    buffer.append("meanControl\t");
	    buffer.append("log2meanControl\t");
	    buffer.append("Cond sigma2\tCond F\tCond p\tCond pAdj\t");
	    buffer.append("Time sigma2\tTime F\tTime p\tTime pAdj\t");
	    buffer.append("CxT sigma2\tCxT F\tCxT p\tCxT pAdj");

	    // loop through the conditions
	    String[] anovaConditions = ANOVAResult.getConditions(db);
	    for (int j=0; j<anovaConditions.length; j++) {

		// loop through genes
		for (int i=0; i<genes.length; i++) {
		    ANOVAResult res = new ANOVAResult(db, anovaConditions[j], genes[i]);
		    Expression expr = new Expression(db, genes[i]);
		    double meanExpr = expr.getMeanControlValue();
		    double logMeanExpr = Util.log2(meanExpr);

		    add(buffer, genes[i].id, true);
		    add(buffer, Util.blankIfNull(genes[i].name), false);
		    add(buffer, anovaConditions[j], false);
		    add(buffer, expFormat.format(meanExpr), false);
		    add(buffer, expFormat.format(logMeanExpr), false);

		    add(buffer, expFormat.format(res.condition_meansq), false);
		    add(buffer, expFormat.format(res.condition_f), false);
		    add(buffer, expFormat.format(res.condition_p), false);
		    add(buffer, expFormat.format(res.condition_p_adj), false);

		    add(buffer, expFormat.format(res.time_meansq), false);
		    add(buffer, expFormat.format(res.time_f), false);
		    add(buffer, expFormat.format(res.time_p), false);
		    add(buffer, expFormat.format(res.time_p_adj), false);

		    add(buffer, expFormat.format(res.condition_time_meansq), false);
		    add(buffer, expFormat.format(res.condition_time_f), false);
		    add(buffer, expFormat.format(res.condition_time_p), false);
		    add(buffer, expFormat.format(res.condition_time_p_adj), false);

		}

	    }

	    // final return
	    buffer.append("\n");

	    // setting the content type
	    response.setContentType("text/tab-separated-values");
	    // the contentlength is needed for MSIE!!!
	    response.setContentLength(buffer.length());
	    // setting some response headers
	    String prefix = "bartontools-"+schema+"-anova";
	    response.setHeader("Content-Disposition","attachment; filename="+makeFileName(prefix));
	    response.setHeader("Expires", "0");
	    response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
	    response.setHeader("Pragma", "public");
	
	    // write BufferedOutputStream to the ServletOutputStream
	    ServletOutputStream out = response.getOutputStream();
	    out.print(buffer.toString());
	    out.flush();

	    db.close();

	} catch (Exception ex) {
      
	    System.out.println(ex.getMessage());
      
	}

    }
 
    /**
     * @see javax.servlet.GenericServlet#destroy()
     */
    public void destroy() {
    }

    /**
     * Create a file name from various stuff
     */
    String makeFileName(String prefix) {
	SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
	return prefix+"-"+df.format(new java.util.Date())+".txt";
    }

    /**
     * Add a cell to the output stream, indicating whether it is starting a new row
     */
    void add(StringBuffer sb, String s, boolean newRow) {
	if (newRow) {
	    sb.append("\n");
	} else {
	    sb.append("\t");
	}
	sb.append(s);
    }
  


}
