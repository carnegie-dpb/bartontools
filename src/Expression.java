package edu.carnegiescience.dpb.bartonlab;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.math3.stat.StatUtils;

/**
 * Contains the full expression data for a single gene.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 */
public class Expression implements Comparable {

    /** the gene associated with this expression */
    public Gene gene;

    /** the samples associated with each datum */
    public Sample[] samples;

    /** the expression values for each sample */
    public double[] values;

    /**
     * Construct given a Gene
     */
    public Expression(DB db, Gene gene) throws SQLException  {
        select(db, gene);
    }
    /**
     * Construct given a schema and a Gene
     */
    public Expression(ServletContext context, Experiment experiment, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            select(db, gene);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Construct given a populated ResultSet and samples array for scaling.
     */
    public Expression(ResultSet rs, Sample[] samples) throws SQLException {
        this.samples = samples;
        populate(rs);
    }

    /**
     * Query the expression table for values for this instance's gene
     */
    void select(DB db, Gene gene) throws SQLException {
        if (gene!=null) {
            samples = Sample.getAll(db); 
            db.executeQuery("SELECT * FROM expression WHERE id='"+gene.id+"'");
            if (db.rs.next()) {
                this.gene = gene;
                populate(db.rs);
            } else {
                this.gene = null;
            }
        }
    }

    /**
     * Populate instance variables from a populated ResultSet. DOES NOT POPULATE samples, do that before calling this!!
     */
    void populate(ResultSet rs) throws SQLException {
        // instantiate the gene only if it hasn't been already by the caller
        if (gene==null) gene = new Gene(rs.getString("id"));
        try {
            values = Util.getDoubles(rs, "values");
            // normalize for library size
            for (int i=0; i<samples.length; i++) values[i] = values[i]/samples[i].internalscale;
        } catch (Exception e) {
            System.err.println("Expression error on gene "+gene.id+": "+e.toString());
        }
    }

    /**
     * Compare based on the gene
     */
    public int compareTo(Object o) {
        Expression that = (Expression) o;
        return this.gene.compareTo(that.gene);
    }

    /**
     * Equality based on gene
     */
    public boolean equals(Object o) {
        Expression that = (Expression) o;
        return this.gene.equals(that.gene);
    }

    /**
     * Return an array of values that correspond to the given single sample condition
     */
    public double[] getValues(String condition) {
        if (condition.equals("ALL")) return values;
        ArrayList<Double> list = new ArrayList<Double>();
        for (int i=0; i<samples.length; i++) {
            if (samples[i].condition.equals(condition)) list.add(values[i]);
        }
        double[] vals = new double[list.size()];
        for (int i=0; i<vals.length; i++) vals[i] = (double) list.get(i);
        return vals;
    }

    /**
     * Return an array of values that correspond to the given sample conditions
     */
    public double[] getValues(String[] conditions) {
        ArrayList<Double> list = new ArrayList<Double>();
        for (int i=0; i<samples.length; i++) {
            for (int j=0; j<conditions.length; j++) {
                if (samples[i].condition.equals(conditions[j])) list.add(values[i]);
            }
        }
        return ArrayUtils.toPrimitive(list.toArray(new Double[0]));
    }

    /**
     * Return an array of values that correspond to the given sample condition and time
     */
    public double[] getValues(String condition, int time) {
        ArrayList<Double> list = new ArrayList<Double>();
        for (int i=0; i<samples.length; i++) {
            if (samples[i].condition.equals(condition) && samples[i].time==time) list.add(values[i]);
        }
        return ArrayUtils.toPrimitive(list.toArray(new Double[0]));
    }

    /**
     * Return an array of values that correspond to the samples marked as controls
     */
    public double[] getControlValues() {
        ArrayList<Double> list = new ArrayList<Double>();
        for (int i=0; i<samples.length; i++) {
            if (samples[i].control) list.add(values[i]);
        }
        return ArrayUtils.toPrimitive(list.toArray(new Double[0]));
    }

    /**
     * Return true if there are missing (zero) control values
     */
    public boolean hasMissingControl() {
        for (int i=0; i<samples.length; i++) {
            if (samples[i].control && values[i]==0) return true;
        }
        return false;
    }

    /**
     * Return true if there are any missing (zero) values
     */
    public boolean hasMissingValue() {
        if (values==null) {
            return true;
        } else {
            for (int i=0; i<values.length; i++) {
                if (values[i]==0) return true;
            }
            return false;
        }
    }

    /**
     * Return true if there are any missing (zero) values within the given condition
     */
    public boolean hasMissingValue(String condition) {
        double[] v = getValues(condition);
        for (int i=0; i<v.length; i++) {
            if (v[i]==0) return true;
        }
        return false;
    }

    /**
     * Return true if there are any missing (zero) values within the given condition and time
     */
    public boolean hasMissingValue(String condition, int time) {
        double[] v = getValues(condition,time);
        for (int i=0; i<v.length; i++) {
            if (v[i]==0) return true;
        }
        return false;
    }

    /**
     * Return an array of Samples that correspond to the given sample condiion
     * This is NOT a wrapper for Sample.get(DB, condition) since we don't need a DB query here.
     */
    public Sample[] getSamples(String condition) {
        ArrayList<Sample> list = new ArrayList<Sample>();
        for (int i=0; i<samples.length; i++) {
            if (samples[i].condition.equals(condition)) list.add(samples[i]);
        }
        return list.toArray(new Sample[0]);
    }

    /**
     * Return the ARITHMETIC mean value across ALL samples for this gene
     */
    public double getMeanValue() {
        if (values==null || values.length==0 || StatUtils.sum(values)==0) {
            return 0.0;
        } else {
            return StatUtils.mean(values);
        }
    }

    /**
     * Return the arithmetic mean value across the given condition
     */
    public double getMeanValue(String condition) {
        if (values==null || values.length==0) {
            return 0.0;
        } else {
            return StatUtils.mean(getValues(condition));
        }
    }

    /**
     * Return the arithmetic mean value across the given conditions
     */
    public double getMeanValue(String[] conditions) {
        if (values==null || values.length==0) {
            return 0.0;
        } else {
            return StatUtils.mean(getValues(conditions));
        }
    }

    /**
     * Return the arithmetic mean value across the given condition and time
     */
    public double getMeanValue(String condition, int time) {
        if (values==null || values.length==0) {
            return 0.0;
        } else {
            return StatUtils.mean(getValues(condition,time));
        }
    }

    /**
     * Return the timewise mean values across the given condition. Note: assumes samples are time-ordered.
     */
    public double[] getTimewiseMeanValues(String condition) {
        ArrayList<Double> list = new ArrayList<Double>();
        int t = -100;
        for (int i=0; i<samples.length; i++) {
            if (t!=samples[i].time) {
                t = samples[i].time;
                list.add(getMeanValue(condition,t));
            }
        }
        return ArrayUtils.toPrimitive(list.toArray(new Double[0]));
    }

    /**
     * Return the timewise mean values across the given two conditions. Note: assumes samples are time-ordered.
     * ALSO NOTE: the array returned is condition1[t1],condition2[t2],etc.
     */
    public double[] getTimewiseMeanValues(String condition1, String condition2) {
        ArrayList<Double> list = new ArrayList<Double>();
        int t = -100;
        for (int i=0; i<samples.length; i++) {
            if (t!=samples[i].time) {
                t = samples[i].time;
                list.add(getMeanValue(condition1,t));
                list.add(getMeanValue(condition2,t));
            }
        }
        return ArrayUtils.toPrimitive(list.toArray(new Double[0]));
    }

    /**
     * Return the mean of the log2 values across ALL samples for this gene, excluding missing values
     */
    public double getLogMeanValue() {
        if (values==null || values.length==0 || StatUtils.sum(values)==0) {
            return 0.0;
        } else {
            return Util.meanLog(values);
        }
    }


    /**
     * Return the standard deviation of values (wrapper for getVariance())
     */
    public double getStandardDeviation() {
        return Math.sqrt(getVariance());
    }

    /**
     * Return the standard deviation of values over the given condition (wrapper for getVariance(condition))
     */
    public double getStandardDeviation(String condition) {
        return Math.sqrt(getVariance(condition));
    }

    /**
     * Return the standard deviation of values over the given conditions (wrapper for getVariance(conditions))
     */
    public double getStandardDeviation(String[] conditions) {
        return Math.sqrt(getVariance(conditions));
    }

    /**
     * Return the variance of values
     */
    public double getVariance() {
        if (values==null || values.length==0 || StatUtils.sum(values)==0) {
            return 0.0;
        } else {
            return StatUtils.variance(values);
        }
    }

    /**
     * Return the variance of values over the given condition
     */
    public double getVariance(String condition) {
        if (values==null || values.length==0 || StatUtils.sum(values)==0) {
            return 0.0;
        } else {
            return StatUtils.variance(getValues(condition));
        }
    }

    /**
     * Return the variance of values over the given conditions
     */
    public double getVariance(String[] conditions) {
        if (values==null || values.length==0 || StatUtils.sum(values)==0) {
            return 0.0;
        } else {
            return StatUtils.variance(getValues(conditions));
        }
    }

    /**
     * Return the standard deviation of log2 values
     */
    public double getLogStandardDeviation() {
        if (values==null || values.length==0 || StatUtils.sum(values)==0) {
            return 0.0;
        } else {
            return Util.sdLog(values);
        }
    }

    /**
     * Return the ARITHMETIC mean value across CONTROL samples for this gene
     */
    public double getMeanControlValue() {
        if (values==null || values.length==0) {
            return 0.0;
        } else {
            return StatUtils.mean(getControlValues());
        }
    }

    /**
     * Return the standard deviation of values across CONTROL samples for this gene
     */
    public double getControlStandardDeviation() {
        if (values==null || values.length==0) {
            return 0.0;
        } else {
            return Math.sqrt(StatUtils.variance(getControlValues()));
        }
    }

    /**
     * Return the minimum value across ALL samples for this gene
     */
    public double getMinValue() {
        if (values==null || values.length==0) {
            return 1e20; // placeholder
        } else {
            return StatUtils.min(values);
        }
    }

    /**
     * Return the minimum value across the given conditions
     */
    public double getMinValue(String[] conditions) {
        if (values==null || values.length==0) {
            return 1e20; // placeholder
        } else {
            return StatUtils.min(getValues(conditions));
        }
    }

    /**
     * Return the minimum value across CONTROL samples for this gene
     */
    public double getMinControlValue() {
        if (values==null || values.length==0) {
            return 1e20; // placeholder
        } else {
            return StatUtils.min(getControlValues());
        }
    }

    /**
     * Return the maximum value across ALL samples for this gene
     */
    public double getMaxValue() {
        if (values==null || values.length==0) {
            return 0.0; // placeholder
        } else {
            return StatUtils.max(values);
        }
    }

    /**
     * Return the maximum value across CONTROL samples for this gene
     */
    public double getMaxControlValue() {
        if (values==null || values.length==0) {
            return 0.0; // placeholder
        } else {
            return StatUtils.max(getControlValues());
        }
    }

    /**
     * Return an array of all expression rows, ordered by gene ID
     */
    public static Expression[] getAll(DB db) throws SQLException {
        Sample[] samples = Sample.getAll(db); 
        ArrayList<Expression> list = new ArrayList<Expression>();
        db.executeQuery("SELECT * FROM expression ORDER BY id");
        while (db.rs.next()) list.add(new Expression(db.rs, samples));
        return list.toArray(new Expression[0]);
    }

    /**
     * Return an array of all genes that have expression records, ordered alphabetically by id/locus
     */
    public static Gene[] getAllGenes(DB db) throws SQLException {
        ArrayList<Gene> list = new ArrayList<Gene>();
        db.executeQuery("SELECT id FROM expression ORDER BY id");
        while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
        return list.toArray(new Gene[0]);
    }

}
