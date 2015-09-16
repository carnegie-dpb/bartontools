import edu.carnegiescience.dpb.bartonlab.*;

import java.sql.SQLException;

/**
 * Run through all genes and write a condition- and time-wise DE score to the schema.descores table.
 * The stored Cuffdiff significance value is used (q<0.05, etc.) to write a "U", "D" or "N".
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class DEScoreWriter {

	public static void main(String[] args) {

		if (args.length!=1) {
			System.err.println("Usage: DEScoreWriter schema");
			return;
		}

		String schema = args[0];

		try {

			DB db = new DB();
			db.setSearchPath(schema);

			Experiment experiment = new Experiment(db, schema);
			String[] conditions = Sample.getConditions(db);
			Gene[] genes = Expression.getAllGenes(db);

			if (experiment.assay.equals("RNA-seq")) {
				for (int i=0; i<genes.length; i++) {
					String score = "";
					for (int j=0; j<conditions.length; j++) {
						CuffdiffTimeResult res = new CuffdiffTimeResult(db, conditions[j], genes[i]);
						if (!res.isDefault()) {
							for (int k=0; k<res.logFC.length; k++) {
								if (res.significant[k]) {
									if (res.logFC[k]>0) {
										score += "U";
									} else {
										score += "D";
									}
								} else {
									score += "N";
								}
							}
						}
					}
					db.executeUpdate("INSERT INTO descores (id,score) VALUES ('"+genes[i].id+"','"+score+"')");
					System.out.println(genes[i].id+"\t"+score);
				}
			}

			if (experiment.assay.equals("Microarray")) {
				for (int i=0; i<genes.length; i++) {
					String score = "";
					for (int j=0; j<conditions.length; j++) {
						LimmaTimeResult res = new LimmaTimeResult(db, conditions[j], genes[i]);
						if (!res.isDefault()) {
							for (int k=0; k<res.logFC.length; k++) {
								if (res.q[k]<0.05) {
									if (res.logFC[k]>0) {
										score += "U";
									} else {
										score += "D";
									}
								} else {
									score += "N";
								}
							}
						}
					}
					db.executeUpdate("INSERT INTO descores (id,score) VALUES ('"+genes[i].id+"','"+score+"')");
					System.out.println(genes[i].id+"\t"+score);
				}
			}

			db.close();
			
		} catch (Exception ex) {

			System.err.println(ex.toString());

		}

	}

}

