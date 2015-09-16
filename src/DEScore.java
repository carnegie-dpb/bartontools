package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.TreeSet;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

import org.apache.commons.lang3.StringUtils;

/**
 * Contains a descores record which holds a gene ID and string score representing the differential expression across conditions and times.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2346 $ $Date: 2013-11-27 19:35:25 -0600 (Wed, 27 Nov 2013) $
 */
public class DEScore extends AnalysisResult {

	public String score;

	/**
	 * Construct given a gene ID and score.
	 */
	public DEScore(String id, String score) {
		this.gene = new Gene(id);
		this.score = score;
	}
	
	/**
	 * Construct given a DB instance and Gene
	 */
	DEScore(DB db, Gene gene) throws SQLException {
		select(db, gene);
	}

	/**
	 * Construct given a ServletContext, gene and experiment
	 */
	public DEScore(ServletContext context, Gene gene, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			select(db, gene);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Construct from a populated ResultSet
	 */
	DEScore(ResultSet rs) throws SQLException {
		populate(rs);
	}

	/**
	 * Select for a given Gene
	 */
	void select(DB db, Gene gene) throws SQLException {
		db.executeQuery("SELECT * FROM descores WHERE id='"+gene.id+"'");
		if (db.rs.next()) {
			this.gene = gene;
			this.score = db.rs.getString("score");
		}
	}

	/**
	 * Populate from a populated descores ResultSet
	 */
	void populate(ResultSet rs) throws SQLException {
		gene = new Gene(rs.getString("id"));
		score = rs.getString("score");
	}

	/**
	 * Get the Levenshtein Distance between this DEScore and a given DEScore {
	 */
	public int getLevenshteinDistance(DEScore score2) throws SQLException {
		return StringUtils.getLevenshteinDistance(this.score, score2.score);
	}
	
	/**
	 * Get the Levenshtein Distance between this DEScore and a given gene.
	 */
	public int getLevenshteinDistance(DB db, Gene gene2) throws SQLException {
		DEScore score2 = new DEScore(db, gene2);
		return StringUtils.getLevenshteinDistance(this.score, score2.score);
	}
	/**
	 * Get the Levenshtein Distance between this gene's score and a given gene's score
	 */
	public int getLevenshteinDistance(ServletContext context, Gene gene2, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getLevenshteinDistance(db, gene2);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Just a mirror of the StringUtils method to get distance between two scores.
	 */
	public static int getLevenshteinDistance(DEScore descore1, DEScore descore2) throws SQLException {
		return StringUtils.getLevenshteinDistance(descore1.score, descore2.score);
	}

	/**
	 * Return an array of genes with DE scores at or below the given Levenshtein Distance from the given gene.
	 * Note: The genes have only their ID set.
	 */
	public static Gene[] scoreSearch(DB db, Gene gene1, int maxDistance) throws SQLException, UnsupportedEncodingException {
		DEScore descore1 = new DEScore(db, gene1);
		// bail if score is missing or has no U or D values
		if (descore1.isAllN()) return new Gene[0];
		// store winning genes in a TreeSet
		TreeSet<Gene> set = new TreeSet<Gene>();
		// now loop through all the scores
		db.executeQuery("SELECT * FROM descores ORDER BY id");
		while (db.rs.next()) {
			DEScore descore2 = new DEScore(db.rs);
			if (!descore2.isAllN()) {
				int distance = getLevenshteinDistance(descore1, descore2);
				if (distance<=maxDistance) set.add(descore2.gene);
			}
		}
		return set.toArray(new Gene[0]);
	}
	/**
	 * Return an array of genes with line scores at or above the given minumum, where the lines are generated with the other given parameters
	 */
	public static Gene[] scoreSearch(ServletContext context, Experiment experiment, Gene gene1, int maxDistance) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return scoreSearch(db, gene1, maxDistance);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if this instance score is all N (no U or D), or null.
	 */
	public boolean isAllN() {
		if (score==null) return true;
		return score.indexOf('U')==-1 && score.indexOf('D')==-1;
	}

}
