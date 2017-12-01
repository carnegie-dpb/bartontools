import edu.carnegiescience.dpb.bartonlab.*;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStreamReader;

/**
 * Loads the gene records from a RapDB file into the bartonlab.genes table.
 * Gene records in the GFF3 file are assumed to be labeled with type "gene".
 *
 */
public class RapGFF2Genes {
    
    public static void main(String[] args) {
        
        if (args.length!=3) {
            System.out.println("Usage: RapGFF2Genes <GFF3File> <genus> <species>");
            System.exit(1);
        }
        
        String filename = args[0];
        String genus = args[1];
        String species = args[2];
        
        String line = null;
        DB db = null;

        try {

            // instantiate DB from db.properties
            db = new DB();

            // blow away records for this species
            db.executeUpdate("DELETE FROM genes WHERE genus='"+genus+"' AND species='"+species+"'");
            System.out.println("Deleted all genes records for "+genus+" "+species+".");

            // read in the GFF3 lines
            BufferedReader in = new BufferedReader(new FileReader(filename));
            while ((line=in.readLine())!=null) {
                RapGFFRecord gff = new RapGFFRecord(line);
                if (gff.seqid!=null && gff.type.equals("gene")) {
                    String insert = "INSERT INTO rapgenes (" +
                        "seqid, source, type, start, \"end\", strand, id, name, biotype, description, version, genus, species" +
                        ") VALUES (" +
                        Util.charsOrNull(gff.seqid)+","+
                        Util.charsOrNull(gff.source)+"," +
                        Util.charsOrNull(gff.type)+"," +
                        Util.intOrNull(gff.start)+"," +
                        Util.intOrNull(gff.end)+"," +
                        "'"+gff.strand+"'," +
                        Util.charsOrNull(gff.attributeID)+"," +
                        Util.charsOrNull(gff.attributeName)+"," +
                        "'protein_coding'," +
                        Util.charsOrNull(gff.attributeNote)+"," +
                        "NULL," +
                        Util.charsOrNull(genus)+"," +
                        Util.charsOrNull(species) +
                        ")";
                    db.executeUpdate(insert);
                    System.out.println(gff.attributeID+"\t"+gff.attributeName);
                }
            }
            
            db.close();
            
        } catch (Exception ex) {
            System.err.println(ex.toString());
            System.err.println("Offending line:");
            System.err.println(line);
        }
        
    }

}

									  
