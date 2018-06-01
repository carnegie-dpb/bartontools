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
 * Outputs a CSV text file containing time-wise differential expression data.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CSVTimewiseDifferentialExpression extends HttpServlet {

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
      DecimalFormat logFCFormat = new DecimalFormat("#.###");
      DecimalFormat pFormat = new DecimalFormat("#.###");

      // get posted variables
      String schema = Util.getString(request, "schema");
      String analysisType = Util.getString(request, "analysisType");
      System.out.println("analysisType="+analysisType);

      // use a single db connection throughout
      db = new DB(request.getSession().getServletContext(), schema);

      // get the genes
      String[] geneIDs = Util.getStringValues(request, "geneID");
      Gene[] genes = new Gene[geneIDs.length];
      for (int i=0; i<genes.length; i++) genes[i] = new Gene(db, geneIDs[i]);

      // get the de conditions
      String[] conditions = Util.getStringValues(request, "deCondition");

      // get the times
      int[] times = Util.getIntValues(request, "times");
      
      // write to a StringBuffer 
      StringBuffer buffer = new StringBuffer();

      // first row = headings
      buffer.append("geneID"+","+"geneShortName");
      for (int j=0; j<conditions.length; j++) {
	for (int k=0; k<times.length; k++) {
	  String label = conditions[j]+"."+times[k];
	  buffer.append(","+label+" logFC"+","+label+" pAdj");
	}
      }

      // now the gene rows
      for (int i=0; i<genes.length; i++) {
	add(buffer, genes[i].id, true);
	add(buffer, Util.blankIfNull(genes[i].name), false);
        for (int j=0; j<conditions.length; j++) {
	  if (analysisType.equals("DESeq2")) {
	    DESeq2TimeResult res = new DESeq2TimeResult(db, conditions[j], genes[i]);
	    for (int k=0; k<times.length; k++) {
	      add(buffer, logFCFormat.format(res.logFC[k]), false);
	      add(buffer, pFormat.format(res.q[k]), false);
	    }
	  }
	  if (analysisType.equals("limma")) {
	    LimmaTimeResult res = new LimmaTimeResult(db, conditions[j], genes[i]);
	    for (int k=0; k<times.length; k++) {
	      add(buffer, logFCFormat.format(res.logFC[k]), false);
	      add(buffer, pFormat.format(res.q[k]), false);
	    }
	  }
	  if (analysisType.equals("Cuffdiff")) {
	    CuffdiffTimeResult res = new CuffdiffTimeResult(db, conditions[j], genes[i]);
	    System.out.println(conditions[j]+" "+genes[i].id+" logFC[0]="+res.logFC[0]+" logFC[1]="+res.logFC[1]);
	    for (int k=0; k<times.length; k++) {
	      add(buffer, logFCFormat.format(res.logFC[k]), false);
	      add(buffer, pFormat.format(res.q[k]), false);
	    }
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
      String prefix = "bartontools-"+schema+"-diffexpression";
      response.setHeader("Content-Disposition","attachment; filename="+makeFileName(prefix));
      response.setHeader("Expires", "0");
      response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
      response.setHeader("Pragma", "public");
	
      // write BufferedOutputStream to the ServletOutputStream
      ServletOutputStream out = response.getOutputStream();
      out.print(buffer.toString());
      out.flush();

    } catch (Exception ex) {
      
      System.out.println(ex.toString());
      
    } finally {

      try {
	if (db!=null) db.close();
      } catch (Exception ex) {
	System.out.println(ex.toString());
      }

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
