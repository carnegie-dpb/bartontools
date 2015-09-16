import edu.carnegiescience.dpb.bartonlab.*;

/**
 * This tool merges limmatimeresults records from multiple records for the same gene ID (but different probe_set_id).
 * We take the ARITHMETIC mean of logFC values, which corresponds to the GEOMETRIC mean of raw values.
 * We take the BEST value of the significance parameters, t, p and q, to not toss any potentially significant results.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class MergeLimmaTimeResults {

	public static void main(String[] args) {
		
		if (args.length!=1) {
			System.out.println("Usage: MergeLimmaTimeResults schema");
			return;
		}

		String schema = args[0];

		try {

			DB db1 = new DB(); db1.setSearchPath(schema);
			DB db2 = new DB(); db2.setSearchPath(schema);

			db1.executeQuery("SELECT count(*),id,condition FROM limmatimeresults GROUP BY id,condition ORDER BY id,condition");
			while (db1.rs.next()) {
				String id = db1.rs.getString("id");
				String condition = db1.rs.getString("condition");
				int count = db1.rs.getInt("count");
				if (count>1) {
					db2.executeQuery("SELECT * FROM limmatimeresults WHERE id='"+id+"' AND condition='"+condition+"'");
					db2.rs.next();
					LimmaTimeResult res = new LimmaTimeResult(db2.rs);
					String mergedProbesetId = "["+res.probe_set_id+"]";
					double[] logFC = res.logFC;
					double[] aveExpr = res.aveExpr;
					double[] t = res.t;
					double[] p = res.p;
					double[] q = res.q;
					double[] b = res.b;
					while (db2.rs.next()) {
						res = new LimmaTimeResult(db2.rs);
						mergedProbesetId += "["+res.probe_set_id+"]";
						for (int i=0; i<res.t.length; i++) {
							logFC[i] += res.logFC[i];     // corresponds to logFC(geometric mean of linear expression)
							aveExpr[i] += res.aveExpr[i]; // corresponds to geometric mean of linear expression since aveExpr is log2
							// store stats for LOWEST p value => if significant on one probe set, it's significant
							if (res.p[i]<p[i]) {
								t[i] = res.t[i];
								p[i] = res.p[i];
								q[i] = res.q[i];
								b[i] = res.b[i];
							}
						}
					}
					// means of quantitative values
					for (int i=0; i<res.t.length; i++) {
						logFC[i] = logFC[i]/count;
						aveExpr[i] = aveExpr[i]/count;
					}
					// replace the records with the one merged record
					String insert = "INSERT INTO limmatimeresults (probe_set_id,id,condition,logfc,aveexpr,t,p_value,q_value,b) VALUES (" +
						"'"+mergedProbesetId+"'," +
						"'"+id+"'," +
						"'"+condition+"'," +
						"'"+bracketArray(logFC)+"'," +
						"'"+bracketArray(aveExpr)+"'," +
						"'"+bracketArray(t)+"'," +
						"'"+bracketArray(p)+"'," +
						"'"+bracketArray(q)+"'," +
						"'"+bracketArray(b)+"'" +
						")";
					db2.executeUpdate("DELETE FROM limmatimeresults WHERE id='"+id+"' AND condition='"+condition+"'");
					db2.executeUpdate(insert);
					System.out.println(id+"\t"+condition+"\t"+count+"\t"+mergedProbesetId);
				}
			}
			
			db1.close();
			db2.close();
			
		} catch (Exception ex) {

			System.err.println(ex.toString());
			
		}

	}

	static String bracketArray(double[] values) {
		String bracket = "{";
		boolean first = true;
		for (int i=0; i<values.length; i++) {
			if (first) {
				first = false;
			} else {
				bracket += ",";
			}
			bracket += values[i];
		}
		bracket += "}";
		return bracket;
	}

}
