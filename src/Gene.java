package edu.carnegiescience.dpb.bartonlab;

import java.sql.Array;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.TreeSet;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Base class which contains the core gene data for a single gene, based on Ensembl GFF3 fields.
 * Extend this class to hold additional data from an annotation library like TAIR.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2835 $ $Date: 2015-09-16 16:21:26 -0500 (Wed, 16 Sep 2015) $
 */
public class Gene implements Comparable {

    /** sequence id: chromosome or scaffold */
    public String seqid;

    /** source of annotation, e.g. "ensembl" */
    public String source;

    /** type of object, normally "gene" */
    public String type;

    /** start position on sequence */
    public int start;

    /** end position on sequence */
    public int end;

    /** strand */
    public char strand;

    /** unique gene id like "AT1G12345"; primary key */
    public String id;

    /** primary name of gene, like "REV" or "AS2" */
    public String name;

    /** gene biotype, like "protein_coding" */
    public String biotype;

    /** gene description */
    public String description;

    /** genus and species */
    public String genus;
    public String species;

    /** list of other names for this particular gene */
    public String[] aliases = new String[0];

    /**
     * Construct an instance with only the gene id defined (and set equal to name)
     */
    public Gene(String id) {
	this.id = id.toUpperCase();
	this.name = id;
    }

    /**
     * Construct an instance loading all the instance vars
     */
    public Gene(String seqid, String source, String type, int start, int end, char strand, String id, String name, String biotype, String description, String genus, String species, String[] aliases) throws UnsupportedEncodingException {
	this(id);
	this.source = source;
	this.type = type;
	this.start = start;
	this.end = end;
	this.strand = strand;
	this.name = URLDecoder.decode(name, "UTF-8");
	this.biotype = biotype;
	this.description = URLDecoder.decode(description, "UTF-8");
	this.genus = genus;
	this.species = species;
	this.aliases = aliases;
    }

    /**
     * Construct an instance given a DB object and id using the select() method.
     */
    public Gene(DB db, String id) throws SQLException, UnsupportedEncodingException {
	select(db, id);
    }
    /**
     * Construct an instance given an id using the select() method.
     */
    public Gene(ServletContext context, String id) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
	DB db = null;
	try {
	    db = new DB(context);
	    select(db, id);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Construct from a populated ResultSet.
     */
    public Gene(ResultSet rs) throws SQLException, UnsupportedEncodingException {
	populate(rs);
    }


    /**
     * SELECT from the public.genes and public.genealiases tables given a DB object and id (converted to upper case); sets id to null if not found.
     */
    void select(DB db, String id) throws SQLException, UnsupportedEncodingException {
	if (id!=null) {
	    db.executeQuery("SELECT * FROM public.genes WHERE id="+Util.charsOrNull(id.toUpperCase()));
	    if (db.rs.next()) {
		populate(db.rs);
		// now build the aliases array
		db.executeQuery("SELECT * FROM public.genealiases WHERE id="+Util.charsOrNull(id.toUpperCase()));
		TreeSet<String> set = new TreeSet<String>();
		while (db.rs.next()) set.add(db.rs.getString("name"));
		aliases = set.toArray(new String[0]);
	    } else {
		// null id to indicate that this instance is empty
		id = null;
	    }
	}
    }

    /**
     * Populate this instance from a populated ResultSet. Doesn't populate aliases array.
     */
    void populate(ResultSet rs) throws SQLException, UnsupportedEncodingException {
	seqid = rs.getString("seqid");
	source = rs.getString("source");
	type = rs.getString("type");
	start = rs.getInt("start");
	end = rs.getInt("end");
	strand = rs.getString("strand").charAt(0);
	id = rs.getString("id");
	name = URLDecoder.decode(rs.getString("name"), "UTF-8");
	biotype = rs.getString("biotype");
	if (rs.getString("description")!=null) description = URLDecoder.decode(rs.getString("description"), "UTF-8");
	genus = rs.getString("genus");
	species = rs.getString("species");
    }

    /**
     * Comparator for sorting; alphabetically by id
     */
    public int compareTo(Object o) {
	Gene that = (Gene)o;
	return this.id.compareTo(that.id);
    }

    /**
     * Return true if same gene id
     */
    public boolean equals(Object o) {
	Gene that = (Gene) o;
	return this.id.equals(that.id);
    }

    /**
     * Return true if this gene isn't initialized
     */
    public boolean isDefault() {
	return id==null;
    }


    /**
     * Return true if an expression record exists for this gene
     */
    public boolean hasExpression(DB db) throws SQLException {
	db.executeQuery("SELECT count(*) AS count FROM expression WHERE id='"+id+"'");
	db.rs.next();
	return db.rs.getInt("count")>0;
    }
    /**
     * Return true if expression exists in the provided schema for this gene
     */
    public boolean hasExpression(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(context, experiment.schema);
	    return hasExpression(db);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return the URL to the Gene Ontology listing for this gene, by making a call to the GO database
     */
    public String getGOURL() throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(GOTerm.dsName);
	    db.executeQuery("SELECT * FROM gene_product_J_dbxref WHERE id=(SELECT gene_product_id FROM gene_product_synonym WHERE product_synonym='"+id+"')");
	    if (db.rs.next()) {
		return "http://amigo.geneontology.org/cgi-bin/amigo/gp-details.cgi?gp="+db.rs.getString("xref_dbname")+":"+db.rs.getString("xref_key");
	    } else {
		return null;
	    }
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return the ID for the given gene name; returns first id alphabetically if multiple
     */
    public static String getIdForName(DB db, String name) throws SQLException {
	db.executeQuery("SELECT * FROM public.genes WHERE name ILIKE "+Util.charsOrNull(name)+" ORDER BY id");
	if (db.rs.next()) {
	    return db.rs.getString("id");
	} else {
	    return null;
	}
    }
    /**
     * Return the ID for the given gene name; returns first id alphabetically if multiple
     */
    public static String getIdForName(ServletContext context, String name) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(context);
	    return getIdForName(db, name);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return the IDs for the given gene name and experiment (to keep species-specific search) from the public.genes table
     */
    public static String[] getIDsForName(DB db, String name, Experiment experiment) throws SQLException {
	TreeSet<String> set = new TreeSet<String>();
	db.executeQuery("SELECT * FROM public.genes WHERE genus='"+experiment.genus+"' AND species='"+experiment.species+"' AND name ILIKE "+Util.charsOrNull(name));
	while (db.rs.next()) set.add(db.rs.getString("id"));
	return set.toArray(new String[0]);
    }
    /**
     * Return the IDs for the given gene name and experiment (to keep species-specific search) from the public.genes table
     */
    public static String[] getIDsForName(ServletContext context, String name, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(context);
	    return getIDsForName(db, name, experiment);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return the IDs for the given gene alias and experiment (to get the genus and species) from the public.genealiases table.
     */
    public static String[] getIDsForAlias(DB db, String name, Experiment experiment) throws SQLException {
	TreeSet<String> set = new TreeSet<String>();
	db.executeQuery("SELECT * FROM public.genealiases WHERE genus='"+experiment.genus+"' AND species='"+experiment.species+"' AND name ILIKE "+Util.charsOrNull(name));
	while (db.rs.next()) set.add(db.rs.getString("id"));
	return set.toArray(new String[0]);
    }
    /**
     * Return the IDs for the given gene alias and experiment (to get the genus and species) from the public.genealiases table.
     */
    public static String[] getIDsForAlias(ServletContext context, String name, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(context);
	    return getIDsForAlias(db, name, experiment);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return public.genes which match the supplied gene IDs; unique, sorted.
     */
    public static Gene[] searchOnIDs(ServletContext context, String[] ids) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
	DB db = null;
	try {
	    db = new DB(context);
	    TreeSet<Gene> set = new TreeSet<Gene>();
	    for (int i=0; i<ids.length; i++) {
		Gene g = new Gene(db, ids[i]);
		if (g.id!=null) set.add(g);
	    }
	    return set.toArray(new Gene[0]);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return genes which have descriptions containing the supplied string or for which there are aliases containing the supplied string
     */
    public static Gene[] searchOnDescriptions(ServletContext context, Experiment experiment, String term) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
	DB db = null;
	try {
	    db = new DB(context);
	    TreeSet<Gene> set = new TreeSet<Gene>();
	    db.executeQuery("SELECT DISTINCT * FROM public.genes WHERE genus='"+experiment.genus+"' AND species='"+experiment.species+"' AND description ILIKE '%"+term+"%'" +
			    " OR id IN " +
			    "(SELECT id FROM genealiases WHERE genus='"+experiment.genus+"' AND species='"+experiment.species+"' AND name ILIKE '%"+term+"%' OR fullname ILIKE '"+term+"')" +
			    " LIMIT 1000");
	    while (db.rs.next()) set.add(new Gene(db.rs));
	    return set.toArray(new Gene[0]);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return an array of Genes for a given tag (exact match), sorted by Gene comparator.
     */
    public static Gene[] getForTag(DB db, String tag) throws SQLException, UnsupportedEncodingException {
	TreeSet<Gene> set = new TreeSet<Gene>();
	db.executeQuery("SELECT * FROM public.genes WHERE id IN (SELECT id FROM public.genetags WHERE tag='"+tag+"')");
	while (db.rs.next()) set.add(new Gene(db.rs));
	return set.toArray(new Gene[0]);
    }
    /**
     * Return an array of Genes for a given tag (exact match), sorted by Gene comparator.
     */
    public static Gene[] getForTag(ServletContext context, String tag) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
	DB db = null;
	try {
	    db = new DB(context);
	    return getForTag(db, tag);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Return an array of Genes for a given array of tags; sorted by Gene comparator; mode="OR" or "AND".
     */
    public static Gene[] getForTags(ServletContext context, String[] tags, String mode) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
	DB db = null;
	try {
	    db = new DB(context);
	    TreeSet<Gene> set = new TreeSet<Gene>();
	    if (mode.equals("OR")) {
		// just use getForTag() since we're combining them all
		for (int i=0; i<tags.length; i++) {
		    Gene[] genes = getForTag(db, tags[i]);
		    for (int j=0; j<genes.length; j++) set.add(genes[j]);
		}
	    } else {
		// use INTERSECT query on all tags
		String query = "SELECT * FROM public.genes WHERE id IN (";
		for (int i=0; i<tags.length; i++) {
		    if (i>0) query += " INTERSECT ";
		    query += "SELECT id FROM public.genetags WHERE tag='"+tags[i]+"'";
		}
		query += ")";
		db.executeQuery(query);
		while (db.rs.next()) set.add(new Gene(db.rs));
	    }
	    return set.toArray(new Gene[0]);
	} finally {
	    if (db!=null) db.close();
	}
    }


}
