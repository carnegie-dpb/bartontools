import edu.carnegiescience.dpb.bartonlab.*;

import java.io.FileReader;
import java.io.BufferedReader;
import java.util.ArrayList;

/**
 * Parses a text file containing the output from R: write.table(exprs(ExpressionSet), quote=FALSE).
 * The samples will be in the samples table; the expression will be in the expression table.
 *
 * The schema and input file are given on the command line. If data is in log2(intensity) format (as
 * returned by rma) set log2Data=true. Output expression is always linear.
 *
 * Records are identified by probe_set_id. There is likely multiple probe_set_id records corresponding to
 * a single gene.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class ExprsParser {

	public static void main(String[] args) {

		if (args.length!=3) {
			System.err.println("Usage: ExprsParser schema log2Data[true/false] exprs.txt");
			return;
		}

		String schema = args[0];
		boolean log2Data = Boolean.parseBoolean(args[1]);
		String exprsFile = args[2];

		if (log2Data) System.out.println("*** Values will be stored as 2^input_value ***");

		DB db = null;

		try {

			// instantiate DB from db.properties
			db = new DB();

			// drop/create the schema and child tables
			db.executeUpdate("DROP SCHEMA "+schema+" CASCADE");
			db.executeUpdate("CREATE SCHEMA "+schema);
			db.executeUpdate("CREATE TABLE "+schema+".samples () INHERITS (public.samples)");
			db.executeUpdate("CREATE TABLE "+schema+".expression () INHERITS (public.expression)");
			db.executeUpdate("CREATE UNIQUE INDEX expression_probe_set_id ON expression (probe_set_id)");

			BufferedReader br = new BufferedReader(new FileReader(exprsFile));

			// samples are in first line
			String line = br.readLine();
			String[] parts = line.split(" ");
			int numSamples = parts.length;
			for (int i=0; i<numSamples; i++) {
				int num = i+1;
				String label = parts[i];
				db.executeUpdate("INSERT INTO "+schema+".samples (label,num,condition) VALUES ('"+label+"',"+num+",'"+label+"')");
				System.out.print(label+" ");
			}
			System.out.println("");

			// rest of file is data
			System.out.print("Reading data...");
			while ((line=br.readLine())!=null) {
				parts = line.split(" ");
				String probe_set_id = parts[0];
				String valueString = "{";
				System.out.print(probe_set_id+" ");
				for (int i=0; i<numSamples; i++) {
					double v = Double.parseDouble(parts[i+1]);
					if (log2Data) v = Math.pow(2, v);
					if (i==0) {
						valueString += v;
					} else {
						valueString += ","+v;
					}
				}
				valueString += "}";
				db.executeUpdate("INSERT INTO "+schema+".expression (probe_set_id,values) VALUES ('"+probe_set_id+"','"+valueString+"')");
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

}


