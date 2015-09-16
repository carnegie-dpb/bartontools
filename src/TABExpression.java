package edu.carnegiescience.dpb.bartonlab;

import java.io.File; 
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.Date; 
import java.sql.SQLException;

import java.text.*;
import java.util.*;

import javax.naming.NamingException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Generate an expression chart as a TAB file.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2370 $ $Date: 2013-12-19 13:23:30 -0600 (Thu, 19 Dec 2013) $
 */
public class TABExpression extends HttpServlet {

	// context for DB connection
	ServletContext context = null;

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
		// unlikely to have a GET request
		doPost(request, response);
	}
  
	/**
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// some preliminaries
		DecimalFormat expressionFormat = new DecimalFormat("#.###");
		DecimalFormat numFormat = new DecimalFormat("#");
		DecimalFormat timeFormat = new DecimalFormat("#");
    
		// DB connection
		DB db = null;

		try {

			// get posted variables
			String schema = request.getParameter("schema");
			String[] geneIDs = request.getParameterValues("geneID");

			// use a single db connection throughout
			db = new DB(request.getSession().getServletContext(), schema);

			// get the genes
			Gene[] genes = new Gene[geneIDs.length];
			for (int i=0; i<genes.length; i++) genes[i] = new Gene(db, geneIDs[i]);
      
			// get the array of samples
			Sample[] samples = Sample.getAll(db);

			// generate chart
    
			// write to a StringBuffer (why not?)
			StringBuffer buffer = new StringBuffer();

			// first rows = headings
			add(buffer, "", false); // tab leads data so skip one at very beginning to avoid blank row at start
			for (int j=0; j<samples.length; j++) {
				add(buffer, numFormat.format(samples[j].num), false);
			}
			add(buffer, "", true);
			add(buffer, "", false);
			for (int j=0; j<samples.length; j++) {
				add(buffer, samples[j].label, false);
			}
			add(buffer, "", true);
			add(buffer, "", false);
			for (int j=0; j<samples.length; j++) {
				add(buffer, samples[j].condition, false);
			}
			add(buffer, "locus", true);
			add(buffer, "name", false);
			for (int j=0; j<samples.length; j++) {
				add(buffer, timeFormat.format(samples[j].time), false);
			}
      
			// loop over the genes and dump loci, names and expression
			for (int i=0; i<genes.length; i++) {
				add(buffer, genes[i].id, true);
				add(buffer, Util.blankIfNull(genes[i].name), false);
				Expression expr = new Expression(db, genes[i]);
				for (int j=0; j<expr.values.length; j++) add(buffer, expressionFormat.format(expr.values[j]), false);
			}
      
			// final return
			buffer.append("\n");
      
			// setting the content type
			response.setContentType("text/tab-separated-values");
			// the contentlength is needed for MSIE!!!
			response.setContentLength(buffer.length());
			// setting some response headers
			String prefix = "bartontools-"+schema+"-expression";
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
