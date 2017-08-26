import edu.carnegiescience.dpb.bartonlab.*;

/**
 * This tool merges expression from multiple expression records for the same gene ID. This often happens on microchip arrays.
 * You have the choice of arithmetic or geometric mean with the geometricMean flag.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class MergeExpression {

	public static void main(String[] args) {
		
		if (args.length!=2) {
			System.out.println("Usage: MergeExpression schema geometricMean[true|false]");
			return;
		}

		String schema = args[0];
		boolean geometricMean = args[1].toLowerCase().equals("true");

		try {

			DB db1 = new DB(); db1.setSearchPath(schema);
			DB db2 = new DB(); db2.setSearchPath(schema);

			db1.executeQuery("SELECT count(*),id FROM expression WHERE id IS NOT NULL GROUP BY id ORDER BY id");
			while (db1.rs.next()) {
				String id = db1.rs.getString("id");
				int count = db1.rs.getInt("count");
				if (count>1) {
					db2.executeQuery("SELECT * FROM expression WHERE id='"+id+"'");
					if (db2.rs.next()) {
						String mergedProbesetId = "["+db2.rs.getString("probe_set_id")+"]";
						Expression ex = new Expression(db2.rs);
						double[] values = ex.values;
						if (geometricMean) values = Util.log(values);
						while (db2.rs.next()) {
							ex = new Expression(db2.rs);
							if (geometricMean) {
								mergedProbesetId += "*["+db2.rs.getString("probe_set_id")+"]";
							} else {
								mergedProbesetId += "+["+db2.rs.getString("probe_set_id")+"]";
							}
							for (int i=0; i<ex.values.length; i++) {
								if (geometricMean) {
									values[i] += Math.log(ex.values[i]);
								} else {
									values[i] += ex.values[i];
								}
							}
						}
						for (int i=0; i<ex.values.length; i++) {
							if (geometricMean) {
								values[i] = Math.exp(values[i]/count);
							} else {
								values[i] = values[i]/count;
							}
						}
						// replace the records with the single merged record
						String insert = "INSERT INTO expression (id,probe_set_id, \"values\") VALUES ('"+id+"','"+mergedProbesetId+"','{";
						boolean first = true;
						for (int i=0; i<values.length; i++) {
							if (first) {
								first = false;
							} else {
								insert += ",";
							}
							insert += values[i];
						}
						insert += "}');";
						db2.executeUpdate("DELETE FROM expression WHERE id='"+id+"'");
						db2.executeUpdate(insert);
						System.out.println(id+"\t"+count+"\t"+mergedProbesetId);
					}
				}
			}

			db1.close();
			db2.close();
			
		} catch (Exception ex) {

			System.err.println(ex.toString());

		}

	}

}
