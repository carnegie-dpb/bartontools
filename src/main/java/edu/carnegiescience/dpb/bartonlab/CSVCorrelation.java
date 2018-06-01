package edu.carnegiescience.dpb.bartonlab;

import java.io.File; 
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;
import org.apache.commons.math3.stat.correlation.SpearmansCorrelation;

/**
 * Outputs a text file containing Pearson's and Spearman's rank correlations for an array of genes
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2799 $ $Date: 2015-08-07 15:41:11 -0500 (Fri, 07 Aug 2015) $
 */
public class CSVCorrelation extends HttpServlet {

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

    DB db = null;
    try {

      // some preliminaries
      DecimalFormat pFormat = new DecimalFormat("#.###");

      // get posted variables
      String schema = Util.getString(request, "schema");
      String[] geneIDs = Util.getStringValues(request, "geneID");

      // use a single db connection throughout
      db = new DB(request.getSession().getServletContext(), schema);

      // get the genes
      Gene[] genes = new Gene[geneIDs.length];
      for (int i=0; i<genes.length; i++) genes[i] = new Gene(db, geneIDs[i]);
      
      // get the array of conditions
      String[] conditions = Sample.getConditions(db);
    
      // write to a StringBuffer 
      StringBuffer buffer = new StringBuffer();

      // first row = headings
      buffer.append("SourceID,SourceShortName,TargetID,TargetShortName,Condition,CorrPearson");

      // don't know why these aren't static methods
      PearsonsCorrelation pCorr = new PearsonsCorrelation();
      Expression[] expr = new Expression[genes.length];
      for (int k=0; k<genes.length; k++) expr[k] = new Expression(db, genes[k]);

      // dump for each condition plus all samples
      for (int i=0; i<=conditions.length; i++) {

	String condition = "All Samples";
	String deTable = null;
	double logFC[] = new double[genes.length];
	if (i<conditions.length) condition = conditions[i];

	// run through the matrix
	for (int k=0; k<expr.length; k++) {
	  for (int l=k+1; l<expr.length; l++) {
	    double corr = 0.0;
	    if (i<conditions.length) {
	      corr = pCorr.correlation(expr[k].getValues(condition), expr[l].getValues(condition));
	    } else {
	      corr = pCorr.correlation(expr[k].values, expr[l].values);
	    }
	    // output the line
	    add(buffer, genes[k].id, true);
	    add(buffer, Util.blankIfNull(genes[k].name), false);
	    add(buffer, genes[l].id, false);
	    add(buffer, Util.blankIfNull(genes[l].name), false);
	    add(buffer, condition, false);
	    add(buffer, pFormat.format(corr), false);
	  }
	}

      }


      // final return
      buffer.append("\n");

      // setting the content type
      response.setContentType("text/csv");
      // the contentlength is needed for MSIE!!!
      response.setContentLength(buffer.length());
      // setting some response headers
      String prefix = "bartontools-"+schema;
      prefix += "-correlation";
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
    return prefix+"-"+df.format(new java.util.Date())+".csv";
  }

  /**
   * Add a cell to the output stream, indicating whether it is starting a new row
   */
  void add(StringBuffer sb, String s, boolean newRow) {
    if (newRow) {
      sb.append("\n");
    } else {
      sb.append(",");
    }
    sb.append(s);
  }
  
}
