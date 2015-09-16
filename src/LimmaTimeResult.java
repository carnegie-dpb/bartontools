package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.TreeSet;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a Limma time-wise analysis results record, with values stored in double arrays. Get times from Samples; not stored here.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2346 $ $Date: 2013-11-27 19:35:25 -0600 (Wed, 27 Nov 2013) $
 */
public class LimmaTimeResult extends AnalysisResult {

	/** Flag for UP expression */
	public static final int UP = 1;

	/** Flag for DOWN expression */
	public static final int DN = -1;

	/** Flag for NO CHANGE of expression */
	public static final int NC = 9;

	/** Minimum mean expression in a selectedc condition to pass culling */
	public static final double minMeanExpr = 1.0;

	public String probe_set_id;
	public String condition;       // condition
	public double[] logFC;         // logfc
	public double[] aveExpr;       // aveexpr
	public double[] t;             // t
	public double[] p;             // p_value
	public double[] q;             // q_value
	public double[] b;             // b

	/**
	 * Construct given a condition and gene
	 */
	public LimmaTimeResult(ServletContext context, Experiment experiment, String condition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			select(db, condition, gene);
		} finally {
			if (db!=null) db.close();
		}
	}
	/**
	 * Construct given a condition and gene
	 */
	public LimmaTimeResult(DB db, String condition, Gene gene) throws SQLException {
		select(db, condition, gene);
	}

	/**
	 * Populate intance vars for a given Gene; only sets the instance gene if a result exists
	 */
	void select(DB db, String condition, Gene gene) throws SQLException {
		db.executeQuery("SELECT * FROM limmatimeresults WHERE condition='"+condition+"' AND id='"+gene.id+"'");
		if (db.rs.next()) {
			this.gene = gene;
			populate(db.rs);
		}
	}

	/**
	 * Construct given a ResultSet
	 */
	public LimmaTimeResult(ResultSet rs) throws SQLException {
		populate(rs);
	}

	/**
	 * Populate instance from a loaded ResultSet
	 */
	void populate(ResultSet rs) throws SQLException {
		if (gene==null) gene = new Gene(rs.getString("id"));
		// scalars
		probe_set_id = rs.getString("probe_set_id");
		condition = rs.getString("condition");
		// arrays
		logFC = Util.getDoubles(rs,"logfc");
		aveExpr = Util.getDoubles(rs,"aveexpr");
		t = Util.getDoubles(rs,"t");
		p = Util.getDoubles(rs,"p_value");
		q = Util.getDoubles(rs,"q_value");
		b = Util.getDoubles(rs,"b");
	}

	/**
	 * Return true if this is an uninstantiated instance
	 */
	public boolean isDefault() {
		return gene==null;
	}


	/**
	 * Get array of all DE conditions
	 */
	public static String[] getConditions(DB db) throws SQLException {
		TreeSet<String> set = new TreeSet<String>();
		db.executeQuery("SELECT DISTINCT condition FROM limmatimeresults ORDER BY condition");
		while (db.rs.next()) set.add(new String(db.rs.getString("condition")));
		return set.toArray(new String[0]);
	}
	/**
	 * Get array of all DE conditions
	 */
	public static String[] getConditions(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getConditions(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of genes selected against minimum logFC and max q with given change directions. Confidence term ("p" or "q") to minimize is supplied.
	 * Requires: public.array_avg(double precision[])
	 */
	public static Gene[] searchOnDirections(DB db, String[] conditions, double minlogFC, double maxPQ, String confidenceTerm, int[] directions) throws SQLException {
		// build the query for all the conditions with non-zero directions
		String query = "";
		boolean first = true;
		String pq_value = confidenceTerm+"_value";
		// build the query - NOTE PostgreSQL arrays are 1-based, so j starts with 1!
		for (int i=0; i<conditions.length; i++) {
			int[] times = Sample.getTimes(db, conditions[i]);
			int len = times.length - 1; // t=0 is base condition, len = non-zero conditions
			if (directions[i]!=0) {
				if (first) {
					first = false;
				} else {
					query += " INTERSECT ";
				}
				query += "SELECT id FROM limmatimeresults WHERE condition='"+conditions[i]+"'";
				if (directions[i]==UP) {
					query += " AND (";
					for (int j=1; j<=len; j++) {
						if (j>1) query += " OR ";
						query += "("+pq_value+"["+j+"]<"+maxPQ+" AND logfc["+j+"]>"+minlogFC+")";
					}
					query += ")";
				} else if (directions[i]==DN) {
					query += " AND (";
					for (int j=1; j<=len; j++) {
						if (j>1) query += " OR ";
						query += "("+pq_value+"["+j+"]<"+maxPQ+" AND -logfc["+j+"]>"+minlogFC+")";
					}
					query += ")";
				} else if (directions[i]==NC) {
					for (int j=1; j<=len; j++) {
						query += " AND abs(logfc["+j+"])<1";
					}
				}
			}
		}
		db.executeQuery(query);
		TreeSet<Gene> candidates = new TreeSet<Gene>();
		while (db.rs.next()) candidates.add(new Gene(db.rs.getString("id")));
		// cull genes that don't have expression records
		TreeSet<Gene> set = new TreeSet<Gene>();
		for (Gene g : candidates) {
			if (g.hasExpression(db)) set.add(g);
		}
		return set.toArray(new Gene[0]);
	}
	/**
	 * Return an array of genes selected against minimum logFC and max q with given change directions. Confidence term is supplied.
	 */
	public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String[] conditions, double minlogFC, double maxPQ, String confidenceTerm, int[] directions)
		throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return searchOnDirections(db, conditions, minlogFC, maxPQ, confidenceTerm, directions);
		} finally {
			if (db!=null) db.close();
		}
	}


	/**
	 * Return an array of genes selected against minimum logFC[2] and max q[2] with given change directions.
	 */
	public static Gene[] searchOnDirections(DB db, String[] conditions, double minlogFC, double maxQ, int[] directions) throws SQLException {
		// build the query for all the conditions with non-zero directions
		String query = "";
		boolean first = true;
		// build the query
		for (int i=0; i<conditions.length; i++) {
			int[] times = Sample.getTimes(db, conditions[i]);
			int len = times.length - 1; // t=0 is base condition
			if (directions[i]!=0) {
				if (first) {
					first = false;
				} else {
					query += " INTERSECT ";
				}
				query += "SELECT id FROM limmatimeresults WHERE condition='"+conditions[i]+"'";
				if (directions[i]==UP) {
					query += " AND (";
					for (int j=1; j<=len; j++) {
						if (j>1) query += " OR ";
						query += "(q_value["+j+"]<"+maxQ+" AND logfc["+j+"]>"+minlogFC+")";
					}
					query += ")";
				} else if (directions[i]==DN) {
					query += " AND (";
					for (int j=1; j<=len; j++) {
						if (j>1) query += " OR ";
						query += "(q_value["+j+"]<"+maxQ+" AND -logfc["+j+"]>"+minlogFC+")";
					}
					query += ")";
				} else if (directions[i]==NC) {
					for (int j=1; j<=len; j++) {
						query += " AND (abs(logfc["+j+"])<"+minlogFC+" OR q_value["+j+"]>"+maxQ+")";
					}
				}
			}
		}
		query += " ORDER BY id";
		db.executeQuery(query);
		TreeSet<Gene> candidateSet = new TreeSet<Gene>();
		while (db.rs.next()) candidateSet.add(new Gene(db.rs.getString("id")));
		Gene[] candidates = candidateSet.toArray(new Gene[0]);
      
		// now cull out genes for which expression is missing in relevant samples
		TreeSet<Gene> winnerSet = new TreeSet<Gene>();
		for (int k=0; k<candidates.length; k++) {
			Expression expr = new Expression(db, candidates[k]);
			boolean hasMissingValues = false;
			for (int i=0; i<conditions.length; i++) hasMissingValues = hasMissingValues || expr.getMeanValue(conditions[i])<minMeanExpr;
			if (!hasMissingValues) winnerSet.add(candidates[k]);
		}

		// das it boss
		return winnerSet.toArray(new Gene[0]);

	}
	/**
	 * Return an array of genes selected against minimum logFC[2] and max q[2] with given change directions.
	 */
	public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String[] conditions, double minlogFC, double maxQ, int[] directions)
		throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return searchOnDirections(db, conditions, minlogFC, maxQ, directions);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of genes selected against minimum logFC[2] and max q[2] for at least one condition
	 */
	public static Gene[] search(DB db, String[] conditions, double minlogFC, double maxQ) throws SQLException {
		String query = "";
		boolean first = true;
		// build the query
		for (int i=0; i<conditions.length; i++) {
			int[] times = Sample.getTimes(db, conditions[i]);
			int len = times.length - 1; // t=0 is base condition
			if (first) {
				first = false;
			} else {
				query += " UNION ";
			}
			query += "SELECT id FROM limmatimeresults WHERE array_length(aveexpr,1)="+len+" AND condition='"+conditions[i]+"'";
			query += " AND (";
			for (int j=1; j<=len; j++) {
				if (j>1) query += " OR ";
				query += "(q_value["+j+"]<"+maxQ+" AND abs(logfc["+j+"])>"+minlogFC+")";
			}
			query += ")";
		}
		query += " ORDER BY id";
		db.executeQuery(query);
		TreeSet<Gene> candidateSet = new TreeSet<Gene>();
		while (db.rs.next()) candidateSet.add(new Gene(db.rs.getString("id")));
		Gene[] candidates = candidateSet.toArray(new Gene[0]);

		// now cull out genes for which expression is missing in relevant samples
		TreeSet<Gene> winnerSet = new TreeSet<Gene>();
		for (int k=0; k<candidates.length; k++) {
			Expression expr = new Expression(db, candidates[k]);
			boolean hasMissingValues = false;
			for (int i=0; i<conditions.length; i++) hasMissingValues = hasMissingValues || expr.getMeanValue(conditions[i])<minMeanExpr;
			if (!hasMissingValues) winnerSet.add(candidates[k]);
		}

		return winnerSet.toArray(new Gene[0]);
	}
	/**
	 * Return an array of genes selected against minimum logFC[2] and max q[2] for at least one condition
	 */
	public static Gene[] search(ServletContext context, Experiment experiment, String[] conditions, double minlogFC, double maxQ) 
		throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return search(db, conditions, minlogFC, maxQ);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of genes with line scores at or above the given minumum, where the lines are generated with the other given parameters
	 */
	public static Gene[] scoreSearch(DB db, Gene gene1, double logFCmin, double qmax, boolean timeWise, boolean bothDirections, int minScore) throws SQLException {
		// the source gene's line score
		String line1;
		if (timeWise) {
			line1 = conditionTimeLineScore(db, gene1, logFCmin, qmax);
		} else {
			line1 = conditionLineScore(db, gene1, logFCmin, qmax);
		}
		if (line1==null) return new Gene[0];
		// run through the genome, storing high scorers in a TreeSet
		TreeSet<Gene> set = new TreeSet<Gene>();
		Gene[] genes = Expression.getAllGenes(db);
		for (int k=0; k<genes.length; k++) {
			String line2;
			if (timeWise) {
				line2 = conditionTimeLineScore(db, genes[k], logFCmin, qmax);
			} else {
				line2 = conditionLineScore(db, genes[k], logFCmin, qmax);
			}
			if (line2!=null) {
				int score = Util.score(bothDirections,line1,line2);
				if (score>=minScore) set.add(genes[k]);
			}
		}
		return set.toArray(new Gene[0]);
	}
	/**
	 * Return an array of genes with line scores at or above the given minumum, where the lines are generated with the other given parameters
	 */
	public static Gene[] scoreSearch(ServletContext context, Experiment experiment, Gene gene1, double logFCmin, double qmax, boolean timeWise, boolean bothDirections, int minScore)
		throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return scoreSearch(db, gene1, logFCmin, qmax, timeWise, bothDirections, minScore);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Returns a string representing the No-change, Up or Down DE for each condition; - where there is no data
	 */
	public static String conditionLineScore(DB db, Gene g, double logFCmin, double qmax) throws SQLException {
		boolean significant = false;
		String line = "";
		// loop over conditions
		String[] conditions = Sample.getConditions(db);
		for (int i=0; i<conditions.length; i++) {
			LimmaTimeResult res = new LimmaTimeResult(db, conditions[i], g);
			int timeCount = Sample.getTimeCount(db, conditions[i]);
			if (res.logFC==null || res.logFC.length<timeCount-1) {
				line += "-";
			} else {
				boolean up = false;
				boolean dn = false;
				// loop over times
				for (int j=0; j<res.logFC.length; j++) {
					if (Math.abs(res.logFC[j])>logFCmin && res.q[j]<qmax) {
						significant = true;
						if (res.logFC[j]>0) {
							up = true;
						} else {
							dn = true;
						}
					}
				}
				if (up) {
					line += "U";
				} else if (dn) {
					line += "D";
				} else {
					line += "N";
				}
			}
		}
		if (significant) {
			return line;
		} else {
			return null;
		}
	}
	/**
	 * Returns a string representing the No-change, Up or Down DE for each condition; - where there is no data
	 */
	public static String conditionLineScore(ServletContext context, Experiment experiment, Gene g, double logFCmin, double qmax)
		throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return conditionLineScore(db, g, logFCmin, qmax);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Returns a string representing the No-change, Up or Down DE for each condition and time; - where there is no data
	 */
	static String conditionTimeLineScore(DB db, Gene g, double logFCmin, double qmax) throws SQLException {
		boolean significant = false;
		String line = "";
		// loop over conditions
		String[] conditions = Sample.getConditions(db);
		for (int i=0; i<conditions.length; i++) {
			LimmaTimeResult res = new LimmaTimeResult(db, conditions[i], g);
			int timeCount = Sample.getTimeCount(db, conditions[i]);
			if (res.logFC==null || res.logFC.length<timeCount-1) {
				line += "---";
			} else {
				// loop over times
				for (int j=0; j<res.logFC.length; j++) {
					if (Math.abs(res.logFC[j])>logFCmin && res.q[j]<qmax) {
						significant = true;
						if (res.logFC[j]>0) {
							line += "U";
						} else {
							line += "D";
						}
					} else {
						line += "N";
					}
				}
			}
		}
		if (significant) {
			return line;
		} else {
			return null;
		}
	}
	/**
	 * Returns a string representing the No-change, Up or Down DE for each condition and time; - where there is no data
	 */
	public static String conditionTimeLineScore(ServletContext context, Experiment experiment, Gene g, double logFCmin, double qmax)
		throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return conditionTimeLineScore(db, g, logFCmin, qmax);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of genes selected against minimum logFC and max q for at least one condition. Confidence term "p" or "q" is given.
	 * Requires: public.array_avg(double precision[])
	 */
	public static Gene[] search(DB db, String[] conditions, double minlogFC, double maxPQ, String confidenceTerm) throws SQLException {
		String query = "";
		boolean first = true;
		String pq_value = confidenceTerm+"_value";
		// determine the size of the full arrays, we don't include genes that are not fully populated
		for (int i=0; i<conditions.length; i++) {
			int[] times = Sample.getTimes(db, conditions[i]);
			int len = times.length - 1; // t=0 is base condition
			if (first) {
				first = false;
			} else {
				query += " UNION ";
			}
			query += "SELECT id FROM limmatimeresults WHERE condition='"+conditions[i]+"'";
			query += " AND (";
			for (int j=1; j<=len; j++) {
				if (j>1) query += " OR ";
				query += "("+pq_value+"["+j+"]<"+maxPQ+" AND abs(logfc["+j+"])>"+minlogFC+")";
			}
			query += ")";
		}
		db.executeQuery(query);
		TreeSet<Gene> candidates = new TreeSet<Gene>();
		while (db.rs.next()) candidates.add(new Gene(db.rs.getString("id")));
		// cull genes that don't have expression records
		TreeSet<Gene> set = new TreeSet<Gene>();
		for (Gene g : candidates) {
			if (g.hasExpression(db)) set.add(g);
		}
		return set.toArray(new Gene[0]);
	}
	/**
	 * Return an array of genes selected against minimum logFC[2] and max adjusted p[2] for at least one condition
	 */
	public static Gene[] search(ServletContext context, Experiment experiment, String[] conditions, double minlogFC, double maxPQ, String confidenceTerm) 
		throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return search(db, conditions, minlogFC, maxPQ, confidenceTerm);
		} finally {
			if (db!=null) db.close();
		}
	}



}
