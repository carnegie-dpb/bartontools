import edu.carnegiescience.dpb.bartonlab.*;

import java.io.FileReader;
import java.io.BufferedReader;
import java.util.ArrayList;

/**
 * Parses a GEO Series Matrix file and loads the expression into the database schema given on the command line.
 * The samples will be in the samples table;
 * The expression will be in the expression table.
 *
 * The GEO Series Matrix input file is given on the command line.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class GEOSeriesMatrixParser {

	public static void main(String[] args) {

		if (args.length!=3) {
			System.err.println("Usage: GEOSeriesMatrixParser schema logBase[0,2,10] GEOSeriesMatrixFile");
			return;
		}

		String schema = args[0];
		int logBase = Integer.parseInt(args[1]);
		String smfile = args[2];
		boolean logData = (logBase!=0);

		if (logData) System.out.println("*** Values will be stored as "+logBase+"^value ***");

		DB db = null;

		try {

			// instantiate DB from db.properties
			db = new DB();

			// drop/create the schema and child tables
			try {
				db.executeUpdate("DROP SCHEMA "+schema+" CASCADE");
			} catch (Exception ex) {
				// probably just that schema doesn't already exist
				System.out.println(ex.getMessage());
			}
			db.executeUpdate("CREATE SCHEMA "+schema);
			db.executeUpdate("CREATE TABLE "+schema+".samples () INHERITS (public.samples)");
			db.executeUpdate("CREATE TABLE "+schema+".expression () INHERITS (public.expression)");

			// delete this row from experiments table
			db.executeUpdate("DELETE FROM experiments WHERE schema='"+schema+"'");

			// meta-data
			String title = "";
			String accession = "";
			String pubmed_id = "";
			String summary = "";
			String overall_design = "";
			String series_type = "";
			String contributors = "";
      
			// samples stuf
			int numSamples = 0;
			ArrayList<String> conditions = new ArrayList<String>();

			// true when we're reading expression data
			boolean readingData = false;

			BufferedReader br = new BufferedReader(new FileReader(smfile));
			String line = null;
			while ((line=br.readLine()) != null && !line.equals("!series_matrix_table_end")) {

				if (line.length()>0) {

					// insert an expression line
					if (readingData) {
						try {
							String[] parts = line.split("\t",-1);
							String probe_set_id = parts[0].replace("\"","");
							String valueString = "{";
							if (parts.length==numSamples+1) {
								for (int i=0; i<numSamples; i++) {
									double v = 0.0; // data missing
									if (parts[i+1].length()>0) v = Double.parseDouble(parts[i+1]); // we have data?
									if (logData && v!=0.0) v = Math.pow(logBase, v);
									if (i==0) {
										valueString += v;
									} else {
										valueString += ","+v;
									}
								}
								valueString += "}";
								String query = "INSERT INTO "+schema+".expression (probe_set_id,values) VALUES ('"+probe_set_id+"','"+valueString+"')";
								db.executeUpdate(query);
							} else {
								System.out.println("Skipping "+probe_set_id+": only "+(parts.length-1)+" samples in line.");
							}
						} catch (Exception ex) {
							System.err.println(ex.toString());
						}
					}

					// title
					if (line.startsWith("!Series_title")) title = getInsideQuotes(line);
					// accession
					if (line.startsWith("!Series_geo_accession")) accession = getInsideQuotes(line);
					// pubmed_id
					if (line.startsWith("!Series_pubmed_id")) pubmed_id = getInsideQuotes(line);
					// summary
					if (line.startsWith("!Series_summary")) summary = getInsideQuotes(line);
					// overall_design
					if (line.startsWith("!Series_overall_design")) overall_design = getInsideQuotes(line);
					// type (assay)
					if (line.startsWith("!Series_type")) series_type += getInsideQuotes(line)+" ";
					// contributors
					if (line.startsWith("!Series_contributor")) contributors += getInsideQuotes(line)+" ";

					// sample conditions - can be many lines per sample, so store in samples.comment for manual population of samples.condition
					if (line.startsWith("!Sample_title")) {
						String[] parts = line.split("\t");
						numSamples = parts.length - 1;
						for (int i=0; i<numSamples; i++) {
							int num = i+1;
							String condition = parts[num].replace("\"","");
							if (conditions.size()<num) {
								// insert new sample
								conditions.add(num-1, condition+"; ");
							} else {
								// update existing sample
								condition = (String)conditions.get(num-1) + condition+"; ";
								conditions.set(num-1, condition);
							}
							System.out.println(num+":"+condition);
						}
					}

					// get sample labels from matrix heading and insert along with conditions in both conditions and comment field
					if (line.startsWith("!series_matrix_table_begin")) {
						String heading = br.readLine();
						String[] parts = heading.split("\t");
						for (int i=0; i<numSamples; i++) {
							int num = i+1;
							String label = parts[num].replace("\"","");
							String condition = (String)conditions.get(num-1);
							db.executeUpdate("INSERT INTO "+schema+".samples (label,num,condition,comment) VALUES ('"+label+"',"+num+",'"+condition+"','"+condition+"')");
						}
						// store the experiment meta-data
						db.executeUpdate("INSERT INTO experiments (schema,title,description,notes,geoseries,pmid,contributors,assay) VALUES (" +
										 "'"+schema+"'," +
										 "'"+title+"'," +
										 "'"+summary+"'," +
										 "'"+overall_design+"'," +
										 "'"+accession+"'," +
										 "'"+pubmed_id+"'," +
										 "'"+contributors+"'," +
										 "'"+series_type+"'" +
										 ")");
						// flag that we're reading expression data now
						readingData = true;
						System.out.println("Reading data...");
					}

				}

			}

			System.out.println("done.");

		} catch (Exception ex) {

			System.out.println("ERROR: "+ex.getMessage());

		} finally {

			if (db!=null) {

				try {
					db.close();
				} catch (Exception ex) {
					System.out.println("ERROR: "+ex.getMessage());
				}

			}

		}
    
	}


	/**
	 * Grab the text between the quotes
	 */
	static String getInsideQuotes(String str) {
		String[] parts = str.split("\"");
		return parts[1];
	}

}


