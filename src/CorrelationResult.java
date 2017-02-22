package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.TreeSet;
import java.util.List;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;
import org.apache.commons.math3.stat.correlation.SpearmansCorrelation;

/**
 * Analyses correlation between two genes; method to searches for correlating genes subject to user-specified cutoffs and conditions.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2357 $ $Date: 2013-12-10 09:58:32 -0600 (Tue, 10 Dec 2013) $
 */
public class CorrelationResult extends AnalysisResult {

    /** Pearsons's correlation coefficient */
    public double corrPearson;

    /** Spearman's rank correlation coefficient */
    public double corrSpearman;

    /** p-value computed from Pearson's correlation */
    public double p;

    /** the second gene */
    public Gene gene2;

    /** the sample conditions that were used for this correlation */
    public String[] conditions;

    /**
     * Construct a CorrelationResult for two genes across the given conditions
     */
    public CorrelationResult(DB db, Gene gene, Gene gene2, String[] conditions) throws SQLException {
        this.gene = gene;
        this.gene2 = gene2;
        this.conditions = conditions;
        corr(db);
    }
    /**
     * Construct a CorrelationResult for two genes across the given conditions
     */
    public CorrelationResult(ServletContext context, Experiment experiment, Gene gene, Gene gene2, String[] conditions) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        this.gene = gene;
        this.gene2 = gene2;
        this.conditions = conditions;
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            corr(db);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Compute correlation between the two instance genes
     */
    void corr(DB db) throws SQLException {

        // first (instance) gene's expression
        Expression expr1 = new Expression(db, gene);

        // second gene's expression
        Expression expr2 = new Expression(db, gene2);

        // samples over which to compute correlation
        Sample[] samples = Sample.get(db, conditions);

        // compute Pearson's correlation of log2 values
        corrPearson = pearsonsCorrelation(Util.log2(expr1.values), Util.log2(expr2.values), samples);

        // Spearman's correlation is based on rank, so no need to log-transform the values
        corrSpearman = spearmansCorrelation(expr1.values, expr2.values, samples);

        // p-value
        p = Util.pPearson(corrPearson, samples.length);

    }

    /**
     * Search for genes that exceed the given Pearson's correlation coefficient with the given gene across the given conditions.
     * USES LOG2 VALUES so down-expression is treated equally with up-expression.
     * Supply polarity flag to determine whether co- (1), anti- (-1) or both (0) are returned.
     */
    public static Gene[] search(DB db, Gene gene1, String[] conditions, double threshold, int polarity) throws SQLException {

        // first gene's expression
        Expression expr1 = new Expression(db, gene1);
        if (expr1.gene==null) return new Gene[0];
        double[] values1 = Util.log2(expr1.values);

        // expression for all genes
        Expression[] exprAll = Expression.getAll(db);

        // samples over which to compute correlation
        Sample[] samples = Sample.get(db, conditions);
		
        // scan across all genes
        TreeSet<Gene> set = new TreeSet<Gene>();
        for (int j=0; j<exprAll.length; j++) {
            double[] values2 = Util.log2(exprAll[j].values);
            double corr = pearsonsCorrelation(values1, values2, samples);
            if ((+corr>threshold && (polarity==0 || polarity==+1)) || (-corr>threshold && (polarity==0 || polarity==-1))) set.add(exprAll[j].gene);
        }
        return set.toArray(new Gene[0]);

    }
    /**
     * Search for genes that exceed the given Pearson's correlation coefficient with the given gene across the given conditions
     */
    public static Gene[] search(ServletContext context, Experiment experiment, Gene gene1, String[] conditions, double threshold, int polarity)
        throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            return search(db, gene1, conditions, threshold, polarity);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Search for genes that exceed the given Pearson's correlation coefficient with the given two genes across the given conditions.
     * No polarity flag on this one.
     */
    public static Gene[] search(DB db, Gene gene1, Gene gene2, String[] conditions, double threshold) throws SQLException {

        // first gene's expression
        Expression expr1 = new Expression(db, gene1);
        if (expr1.gene==null) return new Gene[0];
        double[] values1 = Util.log2(expr1.values);

        // second gene's expression
        Expression expr2 = new Expression(db, gene2);
        if (expr2.gene==null) return new Gene[0];
        double[] values2 = Util.log2(expr2.values);

        // expression for all genes
        Expression[] exprAll = Expression.getAll(db);

        // samples for given conditions
        Sample[] samples = Sample.get(db, conditions);

        // scan across all genes
        TreeSet<Gene> set = new TreeSet<Gene>();
        for (int j=0; j<exprAll.length; j++) {
            double[] valuesj = Util.log2(exprAll[j].values);
            double corr1 = pearsonsCorrelation(values1, valuesj, samples);
            double corr2 = pearsonsCorrelation(values2, valuesj, samples);
            if (Math.abs(corr1)>threshold && Math.abs(corr2)>threshold) set.add(exprAll[j].gene);
        }
        return set.toArray(new Gene[0]);

    }
    /**
     * Search for genes that exceed the given Pearson's correlation coefficient with the given two genes across the given conditions
     */
    public static Gene[] search(ServletContext context, Experiment experiment, Gene gene1, Gene gene2, String[] conditions, double threshold) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            return search(db, gene1, gene2, conditions, threshold);
        } finally {
            if (db!=null) db.close();
        }
    }

    // -----------------------------------------------------------------------------------------

    /**
     * Compute Pearson's correlation over all values (just a wrapper)
     */
    public static double pearsonsCorrelation(double[] values1, double[] values2) {
        PearsonsCorrelation pCorr = new PearsonsCorrelation();
        return pCorr.correlation(values1, values2);
    }

    /**
     * Correlate values over the given set of samples
     */
    public static double pearsonsCorrelation(double[] values1, double[] values2, Sample[] samples) {
        PearsonsCorrelation pCorr = new PearsonsCorrelation();
        // get values for the given samples
        double[] corrValues1 = new double[samples.length];
        double[] corrValues2 = new double[samples.length];
        for (int i=0; i<samples.length; i++) {
            corrValues1[i] = values1[samples[i].num-1];
            corrValues2[i] = values2[samples[i].num-1];
        }
        // compute correlation, ignoring samples where one or the other is exactly 0
        double c = pCorr.correlation(corrValues1, corrValues2);
        if (Double.isNaN(c)) {
            return 0.0;
        } else {
            return c;
        }
    }
    
    // -----------------------------------------------------------------------------------------

    /**
     * Compute Spearman's rank correlation over all values (just a wrapper)
     */
    public static double spearmansCorrelation(double[] values1, double[] values2) {
        SpearmansCorrelation sCorr = new SpearmansCorrelation();
        return sCorr.correlation(values1, values2);
    }

    /**
     * Correlate values over the given set of samples
     */
    public static double spearmansCorrelation(double[] values1, double[] values2, Sample[] samples) {
        SpearmansCorrelation sCorr = new SpearmansCorrelation();
        // get values for the given samples
        double[] corrValues1 = new double[samples.length];
        double[] corrValues2 = new double[samples.length];
        for (int i=0; i<samples.length; i++) {
            corrValues1[i] = values1[samples[i].num-1];
            corrValues2[i] = values2[samples[i].num-1];
        }
        // compute correlation, ignoring samples where one or the other is exactly 0
        double c = sCorr.correlation(corrValues1, corrValues2);
        if (Double.isNaN(c)) {
            return 0.0;
        } else {
            return c;
        }
    }

}
