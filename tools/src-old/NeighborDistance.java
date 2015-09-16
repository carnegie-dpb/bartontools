package org.bsharp.bio;

import java.text.DecimalFormat;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;

/**
 * Calculate the distance between neighbors in a table of regulated genes (all with low p-value).
 * Idea is that genes will come in groups.
 *
 * Uses Apache Commons Math.
 */

public class NeighborDistance {

  public static void main(String[] args) {

    if (args.length==1) {
      System.out.println("Usage: NearestNeighbor <tablename> <threshold bp distance>");
      return;
    }

    String table = args[0];
    int threshold = Integer.parseInt(args[1]);

    DB db = null;

    try {

      db = new DB();

      // load the relevant data into arrays
      db.executeQuery("SELECT count(*) AS count FROM "+table+" WHERE agi_number IS NOT NULL");
      db.rs.next();
      int count = db.rs.getInt("count");
      String[] probesetId = new String[count];
      String[] agi = new String[count];
      int[] agiNumber = new int[count];

      db.executeQuery("SELECT * FROM "+table+" WHERE agi_number IS NOT NULL ORDER BY agi_number,probe_set_id");
      int c = 0;
      while (db.rs.next()) {
	probesetId[c] = db.rs.getString("probe_set_id");
	agi[c] = db.rs.getString("agi");
	agiNumber[c] = db.rs.getInt("agi_number");
	c++;
      }

      // loop through the genes, display near neighbors together with distance in base pairs
      System.out.println("");
      System.out.println("--- Neighbor Distance: table="+table+" distance threshold="+threshold+" base pairs");
      System.out.println("");

      count = 0;
      boolean found = false;
      String neighbors = agi[0]+" ";
      for (int i=1; i<agiNumber.length; i++) {
	int delta = agiNumber[i] - agiNumber[i-1];
	if (delta<=threshold) {
	  found = true;
	  neighbors += "["+delta+"]\t"+agi[i]+" ";
	} else {
	  if (found) {
	    count++;
	    System.out.println(count+".\t"+neighbors);
	  }
	  found = false;
	  neighbors = agi[i]+" ";
	}
      }
      if (found) {
	count++;
	System.out.println(count+".\t"+neighbors);
      }
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
