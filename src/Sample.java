package edu.carnegiescience.dpb.bartonlab;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Describes a single sample in a study over various conditions and times, along with appropriate methods.
 *
 * @author Sam Hokin 
 * @version $Revision: 2799 $ $Date: 2015-08-07 15:41:11 -0500 (Fri, 07 Aug 2015) $
 */
public class Sample implements Comparable {

	/** samples.label, primary key */
	public String label = null;
  
	/** samples.num, ordering number */
	public int num = 0;

	/** samples.condition, identifies sample in sample*/
	public String condition = null;

	/** samples.time, identifies the time associated with the sample, if exists */
	public int time = 0;

	/** samples.control, flags control samples */
	public boolean control = false;

	/** samples.comment, provides a comment on a particular sample */
	public String comment = null;


	/**
	 * Construct given DB connection and a sample label
	 */
	public Sample(DB db, String label) throws SQLException {
		select(db, label);
	}

	/**
	 * Construct given a Servlet context and a sample label
	 */
	public Sample(ServletContext context, Experiment experiment, String label) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			select(db, label);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Construct given a populated ResultSet.
	 */
	Sample(ResultSet rs) throws SQLException {
		populate(rs);
	}

	/**
	 * Do a SELECT query and set instance variables given a DB connection and sample label
	 */
	protected void select(DB db, String label) throws SQLException {
		db.executeQuery("SELECT * FROM samples WHERE label='"+label+"'");
		if (db.rs.next()) populate(db.rs);
	}

	/**
	 * Populate this instance from a populated ResultSet
	 */
	protected void populate(ResultSet rs) throws SQLException {
		label = rs.getString("label");
		num = rs.getInt("num");
		condition = rs.getString("condition");
		time = rs.getInt("time");
		control = rs.getBoolean("control");
		comment = rs.getString("comment");
	}

	/**
	 * Comparator for sorting; alphabetically by sample number
	 */
	public int compareTo(Object o) {
		Sample that = (Sample)o;
		return this.num - that.num;
	}

	/**
	 * Return true if same sample number
	 */
	public boolean equals(Object o) {
		Sample that = (Sample) o;
		return this.num==that.num;
	}

	/**
	 * Return true if at least one control sample is present in the given array
	 */
	public static boolean hasControls(Sample[] samples) {
		boolean exists = false;
		for (int i=0; i<samples.length; i++) {
			if (samples[i].control) exists = true;
		}
		return exists;
	}

	/**
	 * Return an array of all samples, ordered by num
	 */
	public static Sample[] getAll(DB db) throws SQLException {
		ArrayList<Sample> list = new ArrayList<Sample>();
		db.executeQuery("SELECT * FROM samples ORDER BY num");
		while (db.rs.next()) list.add(new Sample(db.rs));
		return list.toArray(new Sample[0]);
	}
	/**
	 * Return an array of all samples, ordered by num
	 */
	public static Sample[] getAll(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getAll(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of samples for the given condition
	 */
	public static Sample[] get(DB db, String condition) throws SQLException {
		ArrayList<Sample> list = new ArrayList<Sample>();
		db.executeQuery("SELECT * FROM samples WHERE condition='"+condition+"' ORDER BY num");
		while (db.rs.next()) list.add(new Sample(db.rs));
		return list.toArray(new Sample[0]);
	}
	/**
	 * Return an array of samples for the given condition
	 */
	public static Sample[] get(ServletContext context, Experiment experiment, String condition) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return get(db,condition);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of samples for the given set of conditions
	 */
	public static Sample[] get(DB db, String[] conditions) throws SQLException {
		ArrayList<Sample> list = new ArrayList<Sample>();
		String query = "SELECT * FROM samples WHERE condition='"+conditions[0]+"'";
		for (int i=1; i<conditions.length; i++) query += " OR condition='"+conditions[i]+"'";
		query += " ORDER BY num";
		db.executeQuery(query);
		while (db.rs.next()) list.add(new Sample(db.rs));
		return list.toArray(new Sample[0]);
	}
	/**
	 * Return an array of samples for the given set of conditions
	 */
	public static Sample[] get(ServletContext context, Experiment experiment, String[] conditions) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return get(db,conditions);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of distinct conditions, ordered alphabetically
	 */
	public static String[] getConditions(DB db) throws SQLException {
		ArrayList<String> list = new ArrayList<String>();
		db.executeQuery("SELECT DISTINCT condition FROM samples ORDER BY condition");
		while (db.rs.next()) list.add(db.rs.getString("condition"));
		return list.toArray(new String[0]);
	}
	/**
	 * Return an array of distinct conditions, ordered alphabetically
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
	 * Return an array of distinct times, ordered by increasing time; covers all conditions, some may not have all times
	 */
	public static int[] getTimes(DB db) throws SQLException {
		ArrayList<Integer> list = new ArrayList<Integer>();
		db.executeQuery("SELECT DISTINCT time FROM samples ORDER BY time");
		while (db.rs.next()) list.add(db.rs.getInt("time"));
		int[] times = new int[list.size()];
		for (int i=0; i<times.length; i++) times[i] = (int) list.get(i);
		return times;
	}
	/**
	 * Return an array of distinct times, ordered by increasing time; covers all conditions, some may not have all times
	 */
	public static int[] getTimes(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getTimes(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of distinct times for the given condition, ordered by increasing time
	 */
	public static int[] getTimes(DB db, String condition) throws SQLException {
		ArrayList<Integer> list = new ArrayList<Integer>();
		db.executeQuery("SELECT DISTINCT time FROM samples WHERE condition='"+condition+"' ORDER BY time");
		while (db.rs.next()) list.add(db.rs.getInt("time"));
		int[] times = new int[list.size()];
		for (int i=0; i<times.length; i++) times[i] = (int) list.get(i);
		return times;
	}
	/**
	 * Return an array of distinct times for the given condition, ordered by increasing time
	 */
	public static int[] getTimes(ServletContext context, Experiment experiment, String condition) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getTimes(db,condition);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return the count of conditions
	 */
	public static int getConditionCount(DB db) throws SQLException {
		db.executeQuery("SELECT count(DISTINCT condition) AS count FROM samples");
		db.rs.next();
		return db.rs.getInt("count");
	}
	/**
	 * Return the count of conditions
	 */
	public static int getConditionCount(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getConditionCount(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return the count of times for the given condition
	 */
	public static int getTimeCount(DB db, String condition) throws SQLException {
		db.executeQuery("SELECT count(DISTINCT time) AS count FROM samples WHERE condition='"+condition+"'");
		db.rs.next();
		return db.rs.getInt("count");
	}
	/**
	 * Return the count of times for the given condition
	 */
	public static int getTimeCount(ServletContext context, Experiment experiment, String condition) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getTimeCount(db,condition);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return the total count of conditions and times (i.e. total number of sample types)
	 */
	public static int getConditionTimeCount(DB db) throws SQLException {
		int count = 0;
		String[] conditions = getConditions(db);
		for (int i=0; i<conditions.length; i++) count += getTimeCount(db, conditions[i]);
		return count;
	}
	/**
	 * Return the total count of conditions and times (i.e. total number of sample types)
	 */
	public static int getConditionTimeCount(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			return getConditionTimeCount(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if the given experiment has time-based samples
	 */
	public static boolean hasTimes(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context, experiment.schema);
			db.executeQuery("SELECT count(DISTINCT time) AS count FROM samples");
			db.rs.next();
			return (db.rs.getInt("count")>1);
		} finally {
			if (db!=null) db.close();
		}
	}
	
}
