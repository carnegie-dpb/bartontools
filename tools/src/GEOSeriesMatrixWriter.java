import edu.carnegiescience.dpb.bartonlab.*;
import java.text.DecimalFormat;

/**
 * Writes a GEO Series Matrix file from the expression drawn from the database schema given on the command line.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class GEOSeriesMatrixWriter {

	static DecimalFormat df = new DecimalFormat("0.######");

	public static void main(String[] args) {
		
		if (args.length!=1) {
			System.out.println("Usage: GEOSeriesMatrixParser schema");
			return;
		}

		String schema = args[0];

		DB db = null;

		try {

			// instantiate DB from db.properties
			db = new DB();

			// select this row from experiments table
			db.executeQuery("SELECT * FROM experiments WHERE schema='"+schema+"'");
			if (!db.rs.next()) {
				System.err.println("The experiments table does not contain a row with schema='"+schema+"'. Aborting.");
				System.exit(1);
			}

			// meta-data
			String title = db.rs.getString("title");
			String accession = db.rs.getString("geoseries");
			String pubmed_id = db.rs.getString("pmid");
			String summary = db.rs.getString("description");
			String overall_design = db.rs.getString("notes");
			String series_type = "";
			if (db.rs.getString("assay").equals("RNA-seq")) {
				series_type = "Expression profiling by high throughput sequencing";
			} else if (db.rs.getString("assay").equals("Microarray")) {
				series_type = "Expression profiling by array";
			}
			String[] contributors = db.rs.getString("contributors").split(",");

			// write Series meta data, including placeholders
			outputLine("Series_title",title);
			outputLine("Series_geo_accession",accession);
			outputLine("Series_status","");
			outputLine("Series_submission_date","");
			outputLine("Series_last_update_date","");
			outputLine("Series_pubmed_id",pubmed_id);
			outputLine("Series_summary",summary);
			outputLine("Series_overall_design",overall_design);
			outputLine("Series_type",series_type);
			for (int i=0; i<contributors.length; i++) {
				outputLine("Series_contributor",contributors[i].trim());
			}
			outputLine("Series_contact_name","");
			outputLine("Series_contact_email","");
			outputLine("Series_contact_department","");
			outputLine("Series_contact_institute","");
			outputLine("Series_contact_address","");
			outputLine("Series_contact_city","");
			outputLine("Series_contact_zip/postal_code","");
			outputLine("Series_contact_country","");
			outputLine("Series_supplementary_file","");
			outputLine("Series_platform_id","");
			outputLine("Series_platform_taxid","");
			outputLine("Series_sample_taxid","");
			outputLine("Series_relation","");

			// switch to schema from here on out
			db.executeUpdate("SET search_path TO "+schema);
      
			// samples stuff
			db.executeQuery("SELECT count(*) AS count FROM samples");
			db.rs.next();
			int numSamples = db.rs.getInt("count");
			String[] labels = new String[numSamples];
			String[] conditions = new String[numSamples];
			boolean[] control = new boolean[numSamples];
			int[] time = new int[numSamples];
			String[] comment = new String[numSamples];
			db.executeQuery("SELECT * FROM samples ORDER BY num");
			int n=0;
			boolean showTime = false;
			while (db.rs.next()) {
				labels[n] = db.rs.getString("label");
				conditions[n] = db.rs.getString("condition");
				control[n] = db.rs.getBoolean("control");
				time[n] = db.rs.getInt("time");
				if (time[n]>0) showTime = true;
				comment[n] = db.rs.getString("comment");
				n++;
			}

			// sample labels
			System.out.print("!Series_sample_id");
			for (int i=0; i<labels.length; i++) {
				System.out.print("\t"+"\""+labels[i]+"\"");
			}
			System.out.println("");

			// blank line between Series and Sample stuff
			System.out.println("");

			// sample titles cond.num.time
			System.out.print("!Sample_title");
			String lastCondition = "";
			int lastTime = -1;
			int rep = 0;
			for (int i=0; i<conditions.length; i++) {
				if (conditions[i].equals(lastCondition) && time[i]==lastTime) {
					rep++;
				} else {
					rep = 1;
				}
				System.out.print("\t");
				if (showTime) {
					System.out.print("\""+conditions[i]+"."+time[i]+"."+rep+"\"");
				} else {
					System.out.print("\""+conditions[i]+"."+rep+"\"");
				}
				lastCondition = conditions[i];
				lastTime = time[i];
			}
			System.out.println("");

			// series matrix table header
			System.out.println("!series_matrix_table_begin");
			System.out.print("ID_REF");
			for (int i=0; i<labels.length; i++) {
				System.out.print("\t"+"\""+labels[i]+"\"");
			}
			System.out.println("");

			// series matrix table
			db.executeQuery("SELECT * FROM expression ORDER BY id");
			while (db.rs.next()) {
				String id = db.rs.getString("id");
				String valueString = db.rs.getString("values");
				valueString = valueString.replace("{","");
				valueString = valueString.replace("}","");
				String[] values = valueString.split(",");
				System.out.print(id);
				for (int i=0; i<values.length; i++) {
					System.out.print("\t"+df.format(Double.parseDouble(values[i])));
				}
				System.out.println("");
			}
	
			System.out.println("!series_matrix_table_end");
	
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

	/** output a single line with a lable and quote-encased value */
	static void outputLine(String label, String value) {
		System.out.println("!"+label+"\t"+"\""+value+"\"");
	}

}


