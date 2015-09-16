package org.bsharp.bio;

/**
 * Count the number of genes which have less than the provided distance between in base pairs.
 *
 */

public class GeneGroups {

  public static void main(String[] args) {

    if (args.length<2) {
      System.out.println("Usage: GeneGroups <tablename> <max bp separation>");
      return;
    }

    String table = args[0];
    int maxsep = Integer.parseInt(args[1]);

    DB db = null;

    try {

      db = new DB();

      // load the relevant data into arrays
      db.executeQuery("SELECT count(*) AS count FROM "+table);
      db.rs.next();
      int count = db.rs.getInt("count");
      String[] agi = new String[count];
      int[] seq_region_id = new int[count];
      int[] seq_region_start = new int[count];
      int[] seq_region_end = new int[count];
      int[] seq_region_strand = new int[count];

      db.executeQuery("SELECT * FROM "+table+" WHERE seq_region_start IS NOT NULL ORDER BY seq_region_id,seq_region_start");
      int c = 0;
      while (db.rs.next()) {
	agi[c] = db.rs.getString("agi");
	seq_region_id[c] = db.rs.getInt("seq_region_id");
	seq_region_start[c] = db.rs.getInt("seq_region_start");
	seq_region_end[c] = db.rs.getInt("seq_region_end");
	seq_region_strand[c] = db.rs.getInt("seq_region_strand");
	c++;
      }

      // loop through the genes, display group counts
      System.out.println("");
      System.out.println("--- Gene Groups: table="+table+"; max separation="+maxsep+" base pairs");
      System.out.println("");

      count = 0;
      int currentRegion = 0;
      boolean found = false;
      String neighbors = "";
      for (int i=0; i<agi.length; i++) {
	if (seq_region_id[i]!=currentRegion) {
	  currentRegion = seq_region_id[i];
	  // output if last gene in chromasome was part of group
	  if (found) {
	    count++;
	    System.out.println(count+".\t"+neighbors);
	  }
	  // skip first gene in new chromasome
	  found = false;
	  neighbors = agi[i]+"["+seq_region_start[i]+":"+seq_region_end[i]+"]";
	} else {
	  int delta = seq_region_start[i] - seq_region_end[i-1];
	  if (delta<=maxsep) {
	    found = true;
	    neighbors += "\t"+delta+"\t"+agi[i]+"["+seq_region_start[i]+":"+seq_region_end[i]+"]";
	  } else {
	    if (found) {
	      count++;
	      System.out.println(count+".\t"+neighbors);
	    }
	    found = false;
	    neighbors = agi[i]+"["+seq_region_start[i]+":"+seq_region_end[i]+"]";
	  }
	}
      }
      // output if very last gene was part of group
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
