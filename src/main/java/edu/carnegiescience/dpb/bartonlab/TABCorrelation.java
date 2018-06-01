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

import org.apache.commons.math3.stat.correlation.SpearmansCorrelation;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Outputs a tab-delimited text file containing Pearsons's and Spearman's rank correlation matrix for an array of genes
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2370 $ $Date: 2013-12-19 13:23:30 -0600 (Thu, 19 Dec 2013) $
 */
public class TABCorrelation extends HttpServlet {

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

		// some preliminaries
		DecimalFormat float5 = new DecimalFormat("#.#####");

		// DB connection
		DB db = null;

		try {

			// get posted variables
			String schema = Util.getString(request, "schema");
			String[] geneIDs = Util.getStringValues(request, "geneID");
			String correlationType = Util.getString(request, "correlationType");

			// logic flags for correlation group
			if (correlationType.length()==0) correlationType = "Normal";
			boolean normal = correlationType.equals("Normal");
			boolean conditional = correlationType.equals("Conditional");
			boolean differential = correlationType.equals("Differential");

			// use a single db connection throughout
			db = new DB(request.getSession().getServletContext(), schema);

			// get the genes
			Gene[] genes = new Gene[geneIDs.length];
			for (int i=0; i<genes.length; i++) genes[i] = new Gene(db, geneIDs[i]);
      
			// get the array of conditions
			String[] conditions = Sample.getConditions(db);

			// correlation groups - follow conditions if few enough, else all samples
			String[] groups;
			if (normal) {
				if (conditions.length<10) {
					// include WT and ALL as well
					groups = new String[conditions.length+1];
					for (int i=0; i<conditions.length; i++) groups[i] = conditions[i];
					groups[conditions.length] = "ALL";
				} else {
					groups = new String[1];
					groups[0] = "ALL";
				}
			} else {
				// skip WT
				groups = new String[conditions.length-1];
				for (int i=0; i<groups.length; i++) groups[i] = conditions[i+1];
			}
    
			// write to a StringBuffer 
			StringBuffer buffer = new StringBuffer();

			// first row = headings
			buffer.append("SourceID\tSourceShortName\tTargetID\tTargetShortName\tConditions\tCorrPearson\tCorrSpearman");

			// non-static because can contain results
			SpearmansCorrelation sCorr = new SpearmansCorrelation();
			PearsonsCorrelation pCorr = new PearsonsCorrelation();

			// get the expression values for every gene
			Expression[] expr = new Expression[genes.length];
			for (int k=0; k<genes.length; k++) expr[k] = new Expression(db, genes[k]);

			// dump for each correlation group
			for (int i=0; i<groups.length; i++) {

				// group string labels each table
				String group = "";
				if (normal) group = groups[i];
				if (conditional) group = "WT + "+groups[i];
				if (differential) group = groups[i]+" - WT";

				System.out.println("groups[i]="+groups[i]);

				// run through the matrix
				for (int k=0; k<expr.length; k++) {
					double[] kValues = Util.log2(expr[k].getValues(groups[i]));
					double[] kValuesWT = Util.log2(expr[k].getValues("WT"));
					System.out.println("kValues.length="+kValues.length+" expr[k].values.length="+expr[k].values.length);
					for (int l=k+1; l<expr.length; l++) {
						double[] lValues = Util.log2(expr[l].getValues(groups[i]));
						double[] lValuesWT = Util.log2(expr[l].getValues("WT"));
						System.out.println("lValues.length="+lValues.length+" expr[l].values.length="+expr[l].values.length);
						double p = 1.0;
						double s = 1.0;
						if (normal && k<l) {
							p = pCorr.correlation(kValues, lValues);
							s = sCorr.correlation(kValues, lValues);
						} else if (conditional && k<l) {
							p = pCorr.correlation(kValues, lValues);
							s = sCorr.correlation(kValues, lValues);
						} else if (differential && k<l) {
							p = pCorr.correlation(kValues, lValues) - pCorr.correlation(kValuesWT, lValuesWT);
							s = sCorr.correlation(kValues, lValues) - sCorr.correlation(kValuesWT, lValuesWT);
						}
						// output the line
						add(buffer, genes[k].id, true);
						if (genes[k].name==null) {
							// repeat ID if no short name
							add(buffer, genes[k].id, false);
						} else {
							add(buffer, genes[k].name, false);
						}
						add(buffer, genes[l].id, false);
						if (genes[l].name==null) {
							// repeat ID if no short name
							add(buffer, genes[l].id, false);
						} else {
							add(buffer, genes[l].name, false);
						}
						add(buffer, group, false);
						add(buffer, float5.format(p), false);
						add(buffer, float5.format(s), false);
					}
				}

			}

			// final return
			buffer.append("\n");

			// setting the content type
			response.setContentType("text/tab-separated-values");
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
