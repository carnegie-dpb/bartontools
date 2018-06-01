package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.TreeSet;

import javax.naming.NamingException;

/**
 * Encapulates a single GO term.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2357 $ $Date: 2013-12-10 09:58:32 -0600 (Tue, 10 Dec 2013) $
 */
public class GOTerm implements Comparable {

    /** the JNDI datasource name used by the servlet context */
    static final String dsName = "java:comp/env/jdbc/GODataSource";

    /** the term fields */
    public int id;            // e.g. 33278
    public String type;       // e.g. biological function
    public String acc;        // e.g. GO:0003677
    public String name;       // e.g. DNA binding

    /** other query fields */
    public String symbol;         // e.g. REV
    public String fullName;       // e.g. AT5G60690
    public String xrefDBname;     // e.g. TAIR
    public String xrefKey;        // e.g. locus:2175856
    public String genus;          // e.g. Arabidopsis
    public String species;        // e.g. thaliana
    public int associationIsNot;  // e.g. 0
    public String evidenceCode;   // e.g. ISS

    /** derived from term_descendent table */
    // public int distanceFromRoot;

    /** if !isRoot then parents exist */
    // public GOTerm[] parents;

    /** Instantiate from a filled term ResultSet, doesn't include distanceFromRoot or setParents */
    public GOTerm(ResultSet rs) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        // term stuff
        id = rs.getInt("id");
        type = rs.getString("term_type");
        acc = rs.getString("acc");
        name = rs.getString("name");
        // gene stuff
        symbol = rs.getString("symbol");
        fullName = rs.getString("full_name");
        xrefDBname = rs.getString("xref_dbname");
        xrefKey = rs.getString("xref_key");
        genus = rs.getString("genus");
        species = rs.getString("species");
        associationIsNot = rs.getInt("is_not");
        evidenceCode = rs.getString("code");
    }

    /** Required by Comparable interface */
    public boolean equals(Object o) {
        GOTerm that = (GOTerm) o;
        return this.id==that.id;
    }

    /** Requred by Comparable interface, use distance from root, then alpha */
    public int compareTo(Object o) {
        GOTerm that = (GOTerm) o;
        // if (this.distanceFromRoot==that.distanceFromRoot) {
        //   return this.name.compareTo(that.name);
        // } else {
        //   return this.distanceFromRoot - that.distanceFromRoot;
        // }
        if (this.type.equals(that.type)) {
            return this.name.compareTo(that.name);
        } else {
            return this.type.compareTo(that.type);
        }
    }

    /** Get an array of GO terms for single gene; have to query full_name or symbol because one or other can be missing */
    public static GOTerm[] get(Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(dsName);
            db.executeQuery(
                            "SELECT DISTINCT gene_product.symbol,gene_product.full_name," +
                            "dbxref.xref_dbname,dbxref.xref_key,"+
                            "species.genus,species.species,"+
                            "association.is_not,"+
                            "evidence.code,"+
                            "term.id,term.term_type,term.acc,term.name "+
                            "FROM       gene_product " +
                            "INNER JOIN dbxref ON (gene_product.dbxref_id=dbxref.id) "+
                            "INNER JOIN species ON (gene_product.species_id=species.id) "+
                            "INNER JOIN association ON (gene_product.id=association.gene_product_id) "+
                            "INNER JOIN evidence ON (association.id=evidence.association_id) "+
                            "INNER JOIN term ON (association.term_id=term.id) "+
                            "WHERE genus='"+gene.genus+"' AND species='"+gene.species+"' "+
                            "AND (full_name='"+gene.id+"' OR symbol='"+gene.name+"')");
            // use a TreeSet so the elements are ordered
            TreeSet<GOTerm> set = new TreeSet<GOTerm>();
            while (db.rs.next()) {
                GOTerm g = new GOTerm(db.rs);
                // if (!g.isRoot) {
                //   g.setDistanceFromRoot();
                //   g.setParents(); // non-recursive, just immediate parents
                // }
                set.add(g);
            }
            return set.toArray(new GOTerm[0]);
        } finally {
            if (db!=null) db.close();
        }
    }

    /** Get an array of GO terms for an array of genes; have to query full_name or symbol because one or other can be missing */
    public static GOTerm[] get(Gene[] genes) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(dsName);
            String query = "SELECT DISTINCT gene_product.symbol,gene_product.full_name," +
                "dbxref.xref_dbname,dbxref.xref_key,"+
                "species.genus,species.species,"+
                "association.is_not,"+
                "evidence.code,"+
                "term.id,term.term_type,term.acc,term.name "+
                "FROM       gene_product " +
                "INNER JOIN dbxref ON (gene_product.dbxref_id=dbxref.id) "+
                "INNER JOIN species ON (gene_product.species_id=species.id) "+
                "INNER JOIN association ON (gene_product.id=association.gene_product_id) "+
                "INNER JOIN evidence ON (association.id=evidence.association_id) "+
                "INNER JOIN term ON (association.term_id=term.id) "+
                "WHERE genus='"+genes[0].genus+"' AND species='"+genes[0].species+"' "+
                "AND (full_name IN (";
            boolean first = true;
            for (int i=0; i<genes.length; i++) {
                if (first) {
                    first = false;
                } else {
                    query += ",";
                }
                query += "'"+genes[i].id+"'";
            }
            query += ") OR symbol in (";
            first = true;
            for (int i=0; i<genes.length; i++) {
                if (first) {
                    first = false;
                } else {
                    query += ",";
                }
                query += "'"+genes[i].name+"'";
            }
            query += "))";
            db.executeQuery(query);
            // use a TreeSet so the elements are ordered
            TreeSet<GOTerm> set = new TreeSet<GOTerm>();
            while (db.rs.next()) {
                GOTerm g = new GOTerm(db.rs);
                // if (!g.isRoot) {
                //   g.setDistanceFromRoot();
                //   g.setParents(); // non-recursive, just immediate parents
                // }
                set.add(g);
            }
            return set.toArray(new GOTerm[0]);
        } finally {
            if (db!=null) db.close();
        }
    }

    /** Set the distance from root by querying term_descendent table */
    /*
    void setDistanceFromRoot() throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
      DB db = null;
      try {
        db = new DB(dsName);
        db.executeQuery("SELECT max(distance) AS max_distance FROM term_descendent WHERE descendent_id="+id);
        if (db.rs.next()) distanceFromRoot = db.rs.getInt("max_distance");
      } finally {
        if (db!=null) db.close();
      }
    }
    */

    /** Set the parents of this term */
    /*
    void setParents() throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
      DB db = null;
      try {
        TreeSet<GOTerm> set = new TreeSet<GOTerm>();
        db = new DB(dsName);
        db.executeQuery("SELECT * FROM term_descendent WHERE descendent_id="+id+" AND distance=1");
        while (db.rs.next()) {
    	GOTerm g = new GOTerm(db.rs); // has same fields as term table
    	set.add(g);
        }
        parents = set.toArray(new GOTerm[0]);
      } finally {
        if (db!=null) db.close();
      }
    }
    */
    
}
