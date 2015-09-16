import java.io.FileReader;
import java.io.BufferedReader;

import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Parses a GEO Soft file and loads the expression into the database schema given on the command line.
 *
 * The samples will be in the samples table and the expression will be in the expression table.
 *
 * The schema and SOFT input file is given on the command line.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class GEOSoftParser {

	public static void main(String[] args) {

		if (args.length!=2) {
			System.err.println("Usage: GEOSoftParser schema GEOSoftFile.soft");
			return;
		}

		String schema = args[0];
		String softfile = args[1];

		DB db = null;

		try {

			db = new DB();

			BufferedReader br = new BufferedReader(new FileReader(softfile));

			int numSamples = 0;
			boolean readingData = false;
      
			String line = null;
			while ((line=br.readLine()) != null) {

				if (readingData) {
					// insert an expression line
					String[] parts = line.split("\t");
					String probe_set_id = parts[0];
					String id = parts[1].replace("'","");
					String values = "{"+parts[2];
					for (int i=1; i<numSamples; i++) {
						values += ","+parts[i+2];
					}
					values += "}";
					String query = "INSERT INTO "+schema+".expression (probe_set_id,id,values) VALUES ('"+probe_set_id+"','"+id+"','"+values+"')";
					db.executeUpdate(query);
				}

				if (line.startsWith("#GSM")) {
					// parse this sample information
					numSamples++;
					String[] parts = line.split("=");
					String label = parts[0].replace("#","").trim();
					String comment = parts[1].trim();
					System.out.println(numSamples+":"+label+":"+comment);
					db.executeUpdate("INSERT INTO "+schema+".samples (label,num,condition,time,comment) VALUES ('"+label+"',"+numSamples+",'"+comment+"',0,'"+comment+"')");
				}

				if (line.startsWith("!dataset_table_begin")) {
					String heading = br.readLine();
					String[] parts = heading.split("\t");
					int num = 0;
					for (int i=0; i<parts.length; i++) {
						if (parts[i].startsWith("GSM")) {
							num++;
							String label = parts[i];
							db.executeUpdate("UPDATE "+schema+".samples SET label='"+label+"' WHERE num="+num);
						}
					}
					readingData = true;
				}

			}

		} catch (Exception ex) {

			System.out.println(ex.getMessage());

		} finally {

			if (db!=null) {

				try {
					db.close();
				} catch (Exception ex) {
					System.out.println(ex.getMessage());
				}

			}

		}
    
	}

}


