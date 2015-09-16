package org.bsharp.bio;

import java.text.DecimalFormat;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;

/**
 * Analyze the nearest neighbor genes to one and the other side of a gene that exhibits a low
 * p-value in the analysis of RNA production from REVOLUTA and KANATA transcription factors.
 *
 * Choose a maximum p-value, and a database table; nearest neighbor genes are found and the
 * corresponding p-values printed.
 *
 * Uses Apache Commons Math.
 */

public class NearestNeighbor {

  public static void main(String[] args) {

    if (args.length==0) {
      System.out.println("Usage: NearestNeighbor <tablename>");
      return;
    }

    String table = args[0];

    double pValThresh = 0.01;
    String pValField = "corr_pval_time_genotype";

    DecimalFormat df = new DecimalFormat("0.000000000");

    DB db = null;

    // Get a DescriptiveStatistics instance
    DescriptiveStatistics stats = new DescriptiveStatistics();
    DescriptiveStatistics statsAbove = new DescriptiveStatistics();
    DescriptiveStatistics statsBelow = new DescriptiveStatistics();

    try {

      db = new DB();

      // load ALL the gene labels and p-values into an array
      db.executeQuery("SELECT count(*) AS count FROM "+table+" WHERE transcript_num IS NOT NULL");
      db.rs.next();
      int count = db.rs.getInt("count");
      String[] tId = new String[count];
      double[] pVal = new double[count];
      db.executeQuery("SELECT * FROM "+table+" WHERE transcript_num IS NOT NULL ORDER BY transcript_num");
      int c = 0;
      while (db.rs.next()) {
	tId[c] = db.rs.getString("transcript_id");
	pVal[c] = db.rs.getDouble(pValField);
	c++;
      }

      // loop through the genes, display set when p-value is below threshold
      System.out.println("--- Target Gene Pairs: table="+table+" | p-val field="+pValField+" | p-val threshold="+pValThresh+" ---\n");
      for (int i=1; i<tId.length-2; i++) {

	if (pVal[i]<pValThresh) {

	  // add to stats
	  stats.addValue(pVal[i]);
	  statsBelow.addValue(pVal[i-1]);
	  statsAbove.addValue(pVal[i+1]);
	  if (pVal[i+1]<pValThresh) {
	    stats.addValue(pVal[i+1]);
	    statsBelow.addValue(pVal[i]);
	    statsAbove.addValue(pVal[i+2]);
	  }

	  // output
	  String markAbove = "";
	  if (pVal[i+1]<pValThresh) markAbove = "*";
	  String mark2Above = "";
	  if (pVal[i+2]<pValThresh) mark2Above = "*";
	  String mark3Above = "";
	  if (pVal[i+3]<pValThresh) mark3Above = "*";

	  if (pVal[i+1]<pValThresh && pVal[i+2]<pValThresh) {
	    System.out.println(tId[i-1]+"\t*"+tId[i]+"\t"+markAbove+tId[i+1]+"\t"+mark2Above+tId[i+2]+"\t"+mark3Above+tId[i+3]);
	    System.out.println(df.format(pVal[i-1])+"\t"+df.format(pVal[i])+"\t"+df.format(pVal[i+1])+"\t"+df.format(pVal[i+2])+"\t"+df.format(pVal[i+3]));
	    System.out.println("");
	    i += 3; // increment since we've already shown this triplet plus the extra to the right
	  } else if (pVal[i+1]<pValThresh) {
	    System.out.println(tId[i-1]+"\t*"+tId[i]+"\t"+markAbove+tId[i+1]+"\t"+mark2Above+tId[i+2]);
	    System.out.println(df.format(pVal[i-1])+"\t"+df.format(pVal[i])+"\t"+df.format(pVal[i+1])+"\t"+df.format(pVal[i+2]));
	    System.out.println("");
	    i += 2; // increment since we've already shown this triplet
	  }

	}

      }

      // Compute some statistics
      double mean = stats.getMean();
      double meanBelow = statsBelow.getMean();
      double meanAbove = statsAbove.getMean();

      double std = stats.getStandardDeviation();
      double stdBelow = statsBelow.getStandardDeviation();
      double stdAbove = statsAbove.getStandardDeviation();

      double median = stats.getPercentile(50);
      double medianBelow = statsBelow.getPercentile(50);
      double medianAbove = statsAbove.getPercentile(50);

      // print out the stats
      System.out.println("--- Summary Statistics: table="+table+" | p-val field="+pValField+" | p-val threshold="+pValThresh+" ---\n");
      System.out.println("Low p-value genes:\tmean(p-val)="+df.format(mean)+"\tstd(p-val)="+df.format(std)+"\tmedian(p-val)="+df.format(median));
      System.out.println("Nearest gene below:\tmean(p-val)="+df.format(meanBelow)+"\tstd(p-val)="+df.format(stdBelow)+"\tmedian(p-val)="+df.format(medianBelow));
      System.out.println("Nearest gene above:\tmean(p-val)="+df.format(meanAbove)+"\tstd(p-val)="+df.format(stdAbove)+"\tmedian(p-val)="+df.format(medianAbove));
      System.out.println("");

    } catch (Exception ex) {

      System.err.println(ex.toString());

    } finally {

      try {
	db.close();
      } catch (Exception ex) {
	System.err.println(ex.toString());
      }
	

    }

  }

}
