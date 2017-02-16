package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a ANOVA analysis results record, and methods for getting the DE tables, etc.
 *
 * @author Sam Hokin
 */
public class ANOVAResult extends AnalysisResult implements Comparable {

    public String conditions;

    public int condition_df;
    public double condition_meansq;
    public double condition_f;
    public double condition_p;
    public double condition_p_adj;

    public int time_df;
    public double time_meansq;
    public double time_f;
    public double time_p;
    public double time_p_adj;

    public int condition_time_df;
    public double condition_time_meansq;
    public double condition_time_f;
    public double condition_time_p;
    public double condition_time_p_adj;

    public int residuals_df;
    public double residuals_meansq;

    /**
     * Construct given a results table and a gene
     */
    public ANOVAResult(DB db, String conditions, Gene gene) throws SQLException {
	select(db, conditions, gene);
    }

    /**
     * Construct given a results table and a gene
     */
    public ANOVAResult(ServletContext context, Experiment experiment, String conditions, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(context, experiment.schema);
	    select(db, conditions, gene);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Construct given a ResultSet
     * NOTE: does NOT populate gene or conditions!
     */
    ANOVAResult(ResultSet rs) throws SQLException {
	populate(rs);
    }

    /**
     * Populate intance vars for a given condition and Gene; only sets the instance gene if a result exists
     */
    void select(DB db, String conditions, Gene gene) throws SQLException {
	db.executeQuery("SELECT * FROM anovaresults WHERE conditions='"+conditions+"' AND id='"+gene.id+"'");
	if (db.rs.next()) {
	    this.gene = gene;
	    this.conditions = conditions;
	    populate(db.rs);
	}
    }

    /**
     * Populate instance variables from a loaded ResultSet
     */
    void populate(ResultSet rs) throws SQLException {
	condition_df = rs.getInt("condition_df");
	condition_meansq = rs.getDouble("condition_meansq");
	condition_f = rs.getDouble("condition_f");
	condition_p = rs.getDouble("condition_p");
	time_df = rs.getInt("time_df");
	time_meansq = rs.getDouble("time_meansq");
	time_f = rs.getDouble("time_f");
	time_p = rs.getDouble("time_p");
	condition_time_df = rs.getInt("condition_time_df");
	condition_time_meansq = rs.getDouble("condition_time_meansq");
	condition_time_f = rs.getDouble("condition_time_f");
	condition_time_p = rs.getDouble("condition_time_p");
	residuals_df = rs.getInt("residuals_df");
	residuals_meansq = rs.getInt("residuals_meansq");
	condition_p_adj = rs.getDouble("condition_p_adj");
	time_p_adj = rs.getDouble("time_p_adj");
	condition_time_p_adj = rs.getDouble("condition_time_p_adj");
    }

    /**
     * Default comparator: alpha on gene ID and conditions
     */
    public int compareTo(Object o) {
	ANOVAResult that = (ANOVAResult) o;
	if (this.gene.id.equals(that.gene.id)) {
	    return this.conditions.compareTo(that.conditions);
	} else {
	    return this.gene.id.compareTo(that.gene.id);
	}
    }

    /**
     * Equal if same gene and conditions
     */
    public boolean equals(Object o) {
	ANOVAResult that = (ANOVAResult) o;
	return this.gene.id.equals(that.gene.id) && this.conditions.equals(that.conditions);
    }
	
    /**
     * Get an array of ANOVA results for all conditions for the given gene (sorting conditions alphabetically)
     */
    public static List<ANOVAResult> getResults(ServletContext context, Experiment experiment, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	List<ANOVAResult> list = new ArrayList<ANOVAResult>();
	DB db = null;
	try {
	    db = new DB(context, experiment.schema);
	    db.executeQuery("SELECT * FROM anovaresults WHERE id='"+gene.id+"' ORDER BY conditions");
	    while (db.rs.next()) {
		ANOVAResult res = new ANOVAResult(db.rs);
		// have to set the gene and conditions separately
		res.gene = gene;
		res.conditions = db.rs.getString("conditions");
		list.add(res);
	    }
	} finally {
	    if (db!=null) db.close();
	}
	return list;
    }

    /**
     * Return an array of Genes selected against the given result values. Does NOT cull on mean control expression, do that downstream.
     */
    public static Gene[] searchOnValues(DB db, String conditions,
					double minConditionPAdj, double minTimePAdj, double minConditionTimePAdj, double maxConditionPAdj, double maxTimePAdj, double maxConditionTimePAdj)
	throws SQLException {
	db.executeQuery("SELECT id FROM anovaresults WHERE conditions='"+conditions+"' " +
			"AND condition_p_adj>="+minConditionPAdj+" AND condition_p_adj<="+maxConditionPAdj+" " +
			"AND time_p_adj>="+minTimePAdj+" AND time_p_adj<="+maxTimePAdj+" " +
			"AND condition_time_p_adj>="+minConditionTimePAdj+" AND condition_time_p_adj<="+maxConditionTimePAdj+" " +
			"ORDER BY id");
	ArrayList<Gene> candidateList = new ArrayList<Gene>();
	while (db.rs.next()) candidateList.add(new Gene(db.rs.getString("id")));
	Gene[] candidates = candidateList.toArray(new Gene[0]);

	// now cull out genes for which we don't have non-zero expression for all samples
	// TO DO: update anovaresults table to store specific conditions of analysis so we can restrict cull to just those conditions that are used in ANOVA
	//ArrayList<Gene> winnerList = new ArrayList<Gene>();
	//for (int k=0; k<candidates.length; k++) {
	//  Expression expr = new Expression(db, candidates[k]);
	//  if (!expr.hasMissingValue()) winnerList.add(candidates[k]);
	// }
    
	//return winnerList.toArray(new Gene[0]);
	return candidates;  
    }
    /**
     * Return an array of Genes selected against the given result values
     */
    public static Gene[] searchOnValues(ServletContext context, Experiment experiment, String conditions,
					double minConditionPAdj, double minTimePAdj, double minConditionTimePAdj, double maxConditionPAdj, double maxTimePAdj, double maxConditionTimePAdj) 
	throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(context, experiment.schema);
	    return searchOnValues(db, conditions, minConditionPAdj, minTimePAdj, minConditionTimePAdj, maxConditionPAdj, maxTimePAdj, maxConditionTimePAdj);
	} finally {
	    if (db!=null) db.close();
	}
    }
  
    /**
     * Get array of all analysis conditions by querying the given table; ordered alphabetically
     */
    public static String[] getConditions(DB db) throws SQLException {
	ArrayList<String> list = new ArrayList<String>();
	db.executeQuery("SELECT DISTINCT conditions FROM anovaresults ORDER BY conditions");
	while (db.rs.next()) list.add(new String(db.rs.getString("conditions")));
	return list.toArray(new String[0]);
    }
    /**
     * Get array of all analysis conditions by querying the given table; ordered alphabetically
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
     * Compare based on gene name; ties use default comparator
     */
    public static final Comparator<ANOVAResult> NameComparator = new Comparator<ANOVAResult>() {
	    public int compare(ANOVAResult res1, ANOVAResult res2) {
		if (res1.gene.name.equals(res2.gene.name)) {
		    return res1.compareTo(res2);
		} else {
		    return res1.gene.name.compareTo(res2.gene.name);
		}
	    }
	};

    /**
     * Compare based on condition_p; ties use default comparator (so equals is consistent)
     */
    public static final Comparator<ANOVAResult> ConditionPComparator = new Comparator<ANOVAResult>() {
	    public int compare(ANOVAResult res1, ANOVAResult res2) {
		if (res1.condition_p==res2.condition_p) {
		    return res1.compareTo(res2);
		} else {
		    return Double.compare(res1.condition_p, res2.condition_p);
		}
	    }
	};
    /**
     * Compare based on condition_p_adj; ties use default comparator
     */
    public static final Comparator<ANOVAResult> ConditionPAdjComparator = new Comparator<ANOVAResult>() {
	    public int compare(ANOVAResult res1, ANOVAResult res2) {
		if (res1.condition_p_adj==res2.condition_p_adj) {
		    return res1.compareTo(res2);
		} else {
		    return Double.compare(res1.condition_p_adj, res2.condition_p_adj);
		}
	    }
	};

    /**
     * Compare based on time_p; ties use default comparator (so equals is consistent)
     */
    public static final Comparator<ANOVAResult> TimePComparator = new Comparator<ANOVAResult>() {
	    public int compare(ANOVAResult res1, ANOVAResult res2) {
		if (res1.time_p==res2.time_p) {
		    return res1.compareTo(res2);
		} else {
		    return Double.compare(res1.time_p, res2.time_p);
		}
	    }
	};
    /**
     * Compare based on time_p_adj; ties use default comparator
     */
    public static final Comparator<ANOVAResult> TimePAdjComparator = new Comparator<ANOVAResult>() {
	    public int compare(ANOVAResult res1, ANOVAResult res2) {
		if (res1.time_p_adj==res2.time_p_adj) {
		    return res1.compareTo(res2);
		} else {
		    return Double.compare(res1.time_p_adj, res2.time_p_adj);
		}
	    }
	};

    /**
     * Compare based on condition_time_p; ties use default comparator (so equals is consistent)
     */
    public static final Comparator<ANOVAResult> ConditionTimePComparator = new Comparator<ANOVAResult>() {
	    public int compare(ANOVAResult res1, ANOVAResult res2) {
		if (res1.condition_time_p==res2.condition_time_p) {
		    return res1.compareTo(res2);
		} else {
		    return Double.compare(res1.condition_time_p, res2.condition_time_p);
		}
	    }
	};
    /**
     * Compare based on condition_time_p_adj; ties use default comparator
     */
    public static final Comparator<ANOVAResult> ConditionTimePAdjComparator = new Comparator<ANOVAResult>() {
	    public int compare(ANOVAResult res1, ANOVAResult res2) {
		if (res1.condition_time_p_adj==res2.condition_time_p_adj) {
		    return res1.compareTo(res2);
		} else {
		    return Double.compare(res1.condition_time_p_adj, res2.condition_time_p_adj);
		}
	    }
	};


}
