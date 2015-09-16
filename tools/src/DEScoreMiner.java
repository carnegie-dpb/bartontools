import edu.carnegiescience.dpb.bartonlab.*;

import java.sql.SQLException;

import org.apache.commons.lang3.StringUtils;

/**
 * Run through all genes and find scores for the given gene with a Levenshtein Distance equal or less than the requested value.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class DEScoreMiner {

	public static void main(String[] args) {

		if (args.length!=3) {
			System.err.println("Usage: DEScore schema geneID maxLevenshteinDistance");
			return;
		}

		String schema = args[0];
		String geneID = args[1];
		int maxDistance = Integer.parseInt(args[2]);

		try {

			DB db = new DB();
			db.setSearchPath(schema);

			// get the target gene score
			String geneScore = null;
			db.executeQuery("SELECT * FROM descores WHERE id='"+geneID+"'");
			if (db.rs.next()) {
				geneScore = db.rs.getString("score");
			} else {
				System.err.println("The gene "+geneID+" does not have a DE score. Exiting.");
				System.exit(1);
			}
			
			// now loop through all the scores
			db.executeQuery("SELECT * FROM descores ORDER BY id");
			while (db.rs.next()) {
				String thisScore = db.rs.getString("score");
				int distance = StringUtils.getLevenshteinDistance(geneScore, thisScore);
				if (distance<=maxDistance) {
					System.out.println(geneID+"\t"+db.rs.getString("id")+"\t"+geneScore+"\t"+thisScore+"\t"+distance);
				}
			}

			db.close();

		} catch (Exception ex) {

			System.err.println(ex.toString());

		}

	}

}

