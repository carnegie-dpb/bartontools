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
 * Outputs a space-delimited text file containing the matrix of Spearman and Pearson's correlation coeffs for import into R.
 * Since only one correlation matrix can be output, this currently only does ALL-sample correlations.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2370 $ $Date: 2013-12-19 13:23:30 -0600 (Thu, 19 Dec 2013) $
 */
public class RCorrelation extends HttpServlet {

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
		DecimalFormat fraction = new DecimalFormat("#.######");

		// DB connection
		DB db = null;

		try {

			// get posted variables
			String schema = Util.getString(request, "schema");
			String[] geneIDs = Util.getStringValues(request, "geneID");

			// use a single db connection throughout
			db = new DB(request.getSession().getServletContext(), schema);

			// get the genes
			Gene[] genes = new Gene[geneIDs.length];
			for (int i=0; i<genes.length; i++) genes[i] = new Gene(db, geneIDs[i]);
      
			// write to a StringBuffer 
			StringBuffer buffer = new StringBuffer();

			// gene names are gene short names unless no short name or name already in use (it happens), in which case it's ID
			ArrayList<String> list = new ArrayList<String>();
			String[] names = new String[genes.length];
			for (int i=0; i<genes.length; i++) {
				if (genes[i].name!=null && !list.contains(genes[i].name)) {
					names[i] = genes[i].name;
				} else {
					names[i] = genes[i].id;
				}
				list.add(names[i]);
			}

			// lay out the column names
			for (int i=0; i<genes.length; i++) {
				buffer.append(names[i]+" ");
			}
			buffer.append("\n");

			// get the expression for every gene
			Expression[] expr = new Expression[genes.length];
			for (int i=0; i<genes.length; i++) expr[i] = new Expression(db, genes[i]);

			// non-static because can contain results
			SpearmansCorrelation sCorr = new SpearmansCorrelation();
			PearsonsCorrelation pCorr = new PearsonsCorrelation();

			// spin through the genes, output correlations of both types with 1 on the diagonal
			for (int i=0; i<genes.length; i++) {
				buffer.append(names[i]+" ");
				for (int j=0; j<genes.length; j++) {
					double corr = 1.0;
					if (i<j) corr = pCorr.correlation(expr[i].values, expr[j].values);
					if (i>j) corr = sCorr.correlation(expr[i].values, expr[j].values);
					buffer.append(fraction.format(corr)+" ");
				}
				buffer.append("\n");
			}

			// setting the content type
			response.setContentType("plain/text");
			// the contentlength is needed for MSIE!!!
			response.setContentLength(buffer.length());
			// setting some response headers
			String prefix = "bartontools-"+schema;
			prefix += "-corrmatrix";
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

}
