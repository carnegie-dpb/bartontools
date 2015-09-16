package org.bsharp.bio;


/**
 * Append Ensembl data to an existing table in the local database.
 */

public class EnsemblData {

  public static void main(String[] args) {

    if (args.length==0) {
      System.out.println("Usage: EnsemblData <tablename>");
      return;
    }

    String table = args[0];

    DB dbSelect = null;
    DB dbUpdate = null;
    DB dbEnsembl = null;

    try {

      dbSelect = new DB();
      dbUpdate = new DB();
      dbEnsembl = new DB("ensembl.properties");

      dbSelect.executeQuery("SELECT * FROM "+table);
      while (dbSelect.rs.next()) {
	dbEnsembl.executeQuery("SELECT * FROM transcript WHERE stable_id LIKE '"+dbSelect.rs.getString("agi")+"%'");
	if (dbEnsembl.rs.next()) {
	  dbUpdate.executeUpdate("UPDATE "+table+" SET "+
				 "transcript_id="+dbEnsembl.rs.getInt("transcript_id")+", " +
				 "gene_id="+dbEnsembl.rs.getInt("gene_id")+", " +
				 "analysis_id="+dbEnsembl.rs.getInt("analysis_id")+", " +
				 "seq_region_id="+dbEnsembl.rs.getInt("seq_region_id")+", " +
				 "seq_region_start="+dbEnsembl.rs.getInt("seq_region_start")+", " +
				 "seq_region_end="+dbEnsembl.rs.getInt("seq_region_end")+", " +
				 "seq_region_strand="+dbEnsembl.rs.getInt("seq_region_strand")+", " +
				 "display_xref_id="+dbEnsembl.rs.getInt("display_xref_id")+", " +
				 "biotype='"+dbEnsembl.rs.getString("biotype")+"', " +
				 "status='"+dbEnsembl.rs.getString("status")+"', " +
				 "description='"+dbEnsembl.rs.getString("description")+"', " +
				 "is_current="+dbEnsembl.rs.getBoolean("is_current")+", " +
				 "canonical_translation_id="+dbEnsembl.rs.getInt("canonical_translation_id")+", " +
				 "stable_id='"+dbEnsembl.rs.getString("stable_id")+"', " +
				 "version="+dbEnsembl.rs.getInt("version")+" " +
				 "WHERE agi='"+dbSelect.rs.getString("agi")+"'"
				 );
	  System.out.println(dbSelect.rs.getString("agi")+"\t"+dbEnsembl.rs.getString("stable_id"));
	}
      }

    } catch (Exception ex) {

      System.err.println(ex.toString());

    } finally {

      try {
	dbSelect.close();
	dbUpdate.close();
	dbEnsembl.close();
      } catch (Exception ex) {
	System.err.println(ex.toString());
      }
	

    }

  }

}
