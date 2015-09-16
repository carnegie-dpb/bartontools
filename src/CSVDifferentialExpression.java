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
 * Outputs a CSV text file containing differential expression data suitable for import into Cytoscape's jActiveModules app.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2799 $ $Date: 2015-08-07 15:41:11 -0500 (Fri, 07 Aug 2015) $
 */
public class CSVDifferentialExpression extends HttpServlet {

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

      // use a single db connection throughout
      db = new DB(request.getSession().getServletContext(), schema);

      // get the genes
      String[] geneIDs = Util.getStringValues(request, "geneID");
      Gene[] genes = new Gene[geneIDs.length];
      for (int i=0; i<genes.length; i++) genes[i] = new Gene(db, geneIDs[i]);

      // get the de conditions
      String[] conditions = Util.getStringValues(request, "deCondition");

      // write to a StringBuffer 
      StringBuffer buffer = new StringBuffer();

      // first row = headings
      buffer.append("geneID,geneShortName");
      for (int i=0; i<conditions.length; i++) buffer.append(","+conditions[i]+" logFC"+","+conditions[i]+" pAdj");
      
      for (int i=0; i<genes.length; i++) {
	add(buffer, genes[i].id, true);
	add(buffer, Util.blankIfNull(genes[i].name), false);
        for (int j=0; j<conditions.length; j++) {
	  DESeq2Result res = new DESeq2Result(db, "WT", conditions[j], genes[i]);
	  add(buffer, logFCFormat.format(res.logFC), false);
	  add(buffer, pFormat.format(res.pAdj), false);
	}
      }

      // final return
      buffer.append("\n");

      // setting the content type
      response.setContentType("text/csv");
      // the contentlength is needed for MSIE!!!
      response.setContentLength(buffer.length());
      // setting some response headers
      String prefix = "bartontools-"+schema+"-de";
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
