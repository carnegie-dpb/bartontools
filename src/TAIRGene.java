package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Random;
import java.util.TreeSet;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Gene to contain the data for a TAIR annotation entry.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2835 $ $Date: 2015-09-16 16:21:26 -0500 (Wed, 16 Sep 2015) $
 */
public class TAIRGene extends Gene {

    /** TAIR version, e.g. "TAIR10", which is also the database schema in lower case, e.g. "tair10" */
    public String version;
 
    /** TAIR functional description - model names for this gene */
    public String[] modelname;

    /** TAIR functional description - type */
    public String[] type;

    /** TAIR functional description - short description */
    public String[] shortDescription;

    /** TAIR functional description - curator summary */
    public String[] curatorSummary;

    /** tair.computational_description */
    public String[] computationalDescription;

    /**
     * Construct given a gene id and experiment (for TAIR version)
     */
    public TAIRGene(DB db, String id, Experiment experiment) throws SQLException, UnsupportedEncodingException {
        super(db, id);
        select(db, id, experiment);
    }
    /**
     * Construct given a gene id and experiment (for TAIR version)
     */
    public TAIRGene(ServletContext context, String id, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
        super(context, id);
        DB db = null;
        try {
            db = new DB(context);
            select(db, id, experiment);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Construct given a Gene and experiment (for TAIR version)
     */
    public TAIRGene(DB db, Gene g, Experiment experiment) throws SQLException, UnsupportedEncodingException {
        super(db, g.id);
        select(db, g.id, experiment);
    }
    /**
     * Construct given a Gene and experiment (for TAIR version)
     */
    public TAIRGene(ServletContext context, Gene g, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
        super(context, g.id);
        DB db = null;
        try {
            db = new DB(context);
            select(db, g.id, experiment);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Do a SELECT query and set instance variables given a DB connection, a gene id and experiment for annotation version
     */
    void select(DB db, String id, Experiment experiment) throws SQLException {
        if (id!=null) {
            // each gene model for this locus
            ArrayList<String> modelnameList = new ArrayList<String>();
            ArrayList<String> typeList = new ArrayList<String>();
            ArrayList<String> shortDescriptionList = new ArrayList<String>();
            ArrayList<String> curatorSummaryList = new ArrayList<String>();
            ArrayList<String> computationalDescriptionList = new ArrayList<String>();
            db.executeQuery("SELECT * FROM "+experiment.annotation.toLowerCase()+".annotation WHERE modelname LIKE '"+id+".%' ORDER BY modelname");
            while (db.rs.next()) {
                modelnameList.add(db.rs.getString("modelname"));
                typeList.add(db.rs.getString("type"));
                shortDescriptionList.add(db.rs.getString("shortdescription"));
                curatorSummaryList.add(db.rs.getString("curatorsummary"));
                computationalDescriptionList.add(db.rs.getString("computationaldescription"));
            }
            this.modelname = modelnameList.toArray(new String[0]);
            this.type = typeList.toArray(new String[0]);
            this.shortDescription = shortDescriptionList.toArray(new String[0]);
            this.curatorSummary = curatorSummaryList.toArray(new String[0]);
            this.computationalDescription = computationalDescriptionList.toArray(new String[0]);
        }
    }

    /**
     * Try to parse the gene's long and short names out of the beginning of the computational description
     */
    void parseNames(String s) {
        if (s!=null) {
            String[] pieces1 = s.split(";"); // short name is in parens just before semicolon or only thing before semicolon
            String[] pieces2 = pieces1[0].split(" \\("); // short name will be in second piece ending in ) if parens version
            if (pieces2.length==1) { // no parens
                if (pieces1[0].length()<=8) {
                    name = pieces1[0]; // only short name before semicolon
                } else {
                    description = pieces1[0]; // no short name
                }
            } else {
                String shortPart = pieces2[1];
                if (shortPart.endsWith(")") && shortPart.length()<10) { // we have a short-ish name!
                    name = shortPart.substring(0, shortPart.length()-1);
                    description = pieces2[0];
                } else {
                    description = pieces1[0]; // everything in front of semicolon
                }
            }
        }
        // block some common mistakes
        if (name!=null && name.equals("binding")) name = null;
    }

    /**
     * Parse the gene ID from the model name
     */
    void parseId(String mn) {
        if (mn!=null) id = mn.substring(0,9);
    }

    /**
     * Return genes which match the computational description field; case-insensitive.
     */
    public static Gene[] searchOnComputationalDescription(ServletContext context, Experiment experiment, String searchterm)
        throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
        DB db1 = null;
        DB db2 = null;
        try {
            TreeSet<Gene> set = new TreeSet<Gene>();
            db1 = new DB(context, experiment.schema);
            db2 = new DB(context, experiment.schema);
            db1.executeQuery("SELECT DISTINCT substring(modelname for 9) AS id FROM "+experiment.annotation.toLowerCase()+".annotation WHERE computationaldescription ILIKE '%"+searchterm+"%'");
            while (db1.rs.next()) {
                String id = db1.rs.getString("id");
                Gene g = new Gene(db2, id);
                if (!g.isDefault()) set.add(g);
            }
            return set.toArray(new Gene[0]);
        } finally {
            if (db1!=null) db1.close();
            if (db2!=null) db2.close();
        }
    }

    /**
     * Return an array of all gene IDs from the given TAIR experiment.annotation
     */
    public static String[] getGeneIDs(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            db.executeQuery("SELECT DISTINCT substring(modelname for 9) AS id FROM "+experiment.annotation.toLowerCase()+".annotation");
            TreeSet<String> set = new TreeSet<String>();
            while (db.rs.next()) set.add(db.rs.getString("id"));
            return set.toArray(new String[0]);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Get an array of TAIRGenes for the given set of genes; if the gene isn't in TAIR it does not appear in the output.
     */
    public static TAIRGene[] get(ServletContext context, Experiment experiment, Gene[] genes) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UnsupportedEncodingException {
        DB db = null;
        try {
            db = new DB(context);
            TreeSet<TAIRGene> set = new TreeSet<TAIRGene>();
            for (int i=0; i<genes.length; i++) {
                TAIRGene tg = new TAIRGene(db, genes[i], experiment);
                if (tg.id!=null) set.add(tg);
            }
            return set.toArray(new TAIRGene[0]);
        } finally {
            if (db!=null) db.close();
        }
    }

}
