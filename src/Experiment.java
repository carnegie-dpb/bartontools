package edu.carnegiescience.dpb.bartonlab;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.util.TreeSet;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Describes an experiment, including fields for GEO accession and such.
 * Implements Comparable because Experiments are ordered alphabetically, except if they have a GEO Series Accession, in which case it is numerical (GSE607 precedes GSE1003);
 *
 * @author Sam Hokin 
 * @version $Revision: 2357 $ $Date: 2013-12-10 09:58:32 -0600 (Tue, 10 Dec 2013) $
 */
public class Experiment implements Comparable {

    /** experiments.schema, primary key */
    public String schema;

    /** experiments.title */
    public String title;

    /** experiments.description */
    public String description;

    /** experiments.notes */
    public String notes;

    /** experiments.geoseries - GEO Series accession ID */
    public String geoseries;

    /** experiments.geodataset - GEO Dataset ID */
    public String geodataset;

    /** experiments.pmid - Pub Med ID */
    public int pmid;

    /** experiments.expressionlabel - label for expression axis on plots */
    public String expressionlabel;

    /** experiments.contributors - list of data contributors (not same as publication authors) */
    public String contributors;

    /** experiments.publicdata - flags whether data is public or not */
    public boolean publicdata;

    /** experiments.assay - short string to indicate assay, like Microarray or RNA-Seq */
    public String assay;

    /** experiments.annotation - the name of the genome annotation used to map data to genes */
    public String annotation;

    /** experiments.genus */
    public String genus;

    /** experiments.species */
    public String species;

    /** --- other stuff --- */

    public boolean isTimewise;

    /**
     * Construct with db connection and schema
     */
    public Experiment(DB db, String schema) throws SQLException {
        select(db, schema);
    }

    /**
     * Construct with servlet context and schema
     */
    public Experiment(ServletContext context, String schema) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            select(db, schema);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Construct with a populated ResultSet
     */
    public Experiment(ResultSet rs) throws SQLException {
        populate(rs);
    }

    /**
     * Do a SELECT query and set instance variables given a DB connection and sample label. Must set public. explicitly since db already is set for schema path.
     */
    protected void select(DB db, String schema) throws SQLException {
        db.executeQuery("SELECT * FROM public.experiments WHERE schema='"+schema+"'");
        if (db.rs.next()) populate(db.rs);
        db.executeQuery("SELECT count(DISTINCT time) AS count FROM "+schema+".samples");
        db.rs.next();
        isTimewise = db.rs.getInt("count")>1;
    }

    /**
     * Populate this instance from a populated ResultSet
     */
    protected void populate(ResultSet rs) throws SQLException {
        schema = rs.getString("schema");
        title = rs.getString("title");
        description = rs.getString("description");
        notes = rs.getString("notes");
        geoseries = rs.getString("geoseries");
        geodataset = rs.getString("geodataset");
        pmid = rs.getInt("pmid");
        expressionlabel = rs.getString("expressionlabel");
        contributors = rs.getString("contributors");
        publicdata = rs.getBoolean("publicdata");
        assay = rs.getString("assay");
        annotation = rs.getString("annotation");
        genus = rs.getString("genus");
        species = rs.getString("species");
    }

    /**
     * Experiments are equal if they have the same schema
     */
    public boolean equals(Object o) {
        Experiment that = (Experiment) o;
        return this.schema.equals(that.schema);
    }

    /**
     * Order alphabetically by schema, and by GEO number within GEO series
     */
    public int compareTo(Object o) {
        Experiment that = (Experiment) o;
        if (this.geoseries!=null && that.geoseries!=null) {
            return Integer.parseInt(this.geoseries.substring(3)) - Integer.parseInt(that.geoseries.substring(3));
        } else {
            return this.schema.compareTo(that.schema);
        }
    }

    /**
     * Get an array of ALL experiments, ordered by Experiment comparator
     */
    public static Experiment[] getAll(DB db) throws SQLException {
        TreeSet<Experiment> set = new TreeSet<Experiment>();
        db.executeQuery("SELECT * FROM experiments");
        while (db.rs.next()) set.add(new Experiment(db.rs));
        return set.toArray(new Experiment[0]);
    }
    /**
     * Get an array of ALL experiments, ordered by Experiment comparator
     */
    public static Experiment[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return getAll(db);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Get an array of PUBLIC experiments, ordered by Experiment comparator
     */
    public static Experiment[] getPublic(DB db) throws SQLException {
        TreeSet<Experiment> set = new TreeSet<Experiment>();
        db.executeQuery("SELECT * FROM experiments WHERE publicdata");
        while (db.rs.next()) set.add(new Experiment(db.rs));
        return set.toArray(new Experiment[0]);
    }
    /**
     * Get an array of PUBLIC experiments, ordered by Experiment comparator
     */
    public static Experiment[] getPublic(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return getPublic(db);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Get an array of PRIVATE experiments for the given user, ordered by Experiment comparator
     */
    public static Experiment[] getPrivate(DB db, User user) throws SQLException {
        TreeSet<Experiment> set = new TreeSet<Experiment>();
        db.executeQuery("SELECT * FROM experiments WHERE schema IN (SELECT schema FROM users_experiments WHERE user_id="+user.getId()+")");
        while (db.rs.next()) set.add(new Experiment(db.rs));
        return set.toArray(new Experiment[0]);
    }
    /**
     * Get an array of PRIVATE experiments for the given user, ordered by Experiment comparator
     */
    public static Experiment[] getPrivate(ServletContext context, User user) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return getPrivate(db, user);
        } finally {
            if (db!=null) db.close();
        }
    }

}
