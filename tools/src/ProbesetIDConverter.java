import java.io.FileReader;
import java.io.BufferedReader;
import java.util.HashMap;

import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Parses a tab-delimited file with probe_set_id and updates the expression table with corresponding Ensemble IDs (where missing).
 * This file can be downloaded from the Ensembl BioMart app.
 *
 * The schema and input file are given on the command line.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class ProbesetIDConverter {

	public static void main(String[] args) {

		if (args.length!=2) {
			System.err.println("Usage: ProbesetIDConverter schema probeset2ensemble.txt");
			return;
		}

		String schema = args[0];
		String probefile = args[1];

		DB db1 = null;
		DB db2 = null;

		try {

			// db1 is select query, db2 is update query
			db1 = new DB();
			db2 = new DB();

			// load the map into a HashMap
			HashMap<String,String> map = new HashMap<String,String>();
			BufferedReader br = new BufferedReader(new FileReader(probefile));
			String line = null;
			while ((line=br.readLine()) != null) {
				// don't really care what we read in since we won't get update unless probesetID matches a record
				String[] parts = line.split("\t");
				if (parts.length>1) {
					String ensembleID = parts[0];
					String probesetID = parts[1].toLowerCase();
					if (ensembleID.length()>0 && probesetID.length()>0) {
						map.put(probesetID,ensembleID);
					}
				}
			}

			// update records with missing IDs
			db1.executeQuery("SELECT probe_set_id FROM "+schema+".expression WHERE id IS NULL ORDER BY probe_set_id");
			while (db1.rs.next()) {
				String probesetID = db1.rs.getString("probe_set_id").toLowerCase();
				String ensembleID = map.get(probesetID);
				if (ensembleID!=null) {
					db2.executeUpdate("UPDATE "+schema+".expression SET id='"+ensembleID+"' WHERE lower(probe_set_id)='"+probesetID+"'");
				} else {
					System.out.println(probesetID+"\t*** missing ***");
				}
			}
			
			db1.close();
			db2.close();

		} catch (Exception ex) {

			System.out.println(ex.getMessage());

		}
    
	}

}
