import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStreamReader;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeSet;

import edu.carnegiescience.dpb.bartonlab.DB;
import edu.carnegiescience.dpb.bartonlab.Util;

/**
 * Loads gene records from an Ensembl GFF3 file into the given database table. The database connection is specified in db.properties.
 */
public class EnsemblGeneLoader {

    public static void main(String[] args) {

		if (args.length!=4) {
			System.out.println("java EnsembleGeneLoader input.gff3 dbTable genus species");
			System.exit(0);
		}

		String gffFile = args[0];
		String dbTable = args[1];
		String genus = args[2];
		String species = args[3];

		try {
			
			DB db = new DB();
			db.executeUpdate("DELETE FROM "+dbTable+" WHERE genus='"+genus+"' AND species='"+species+"'");
			
			String line = null;
			BufferedReader in = new BufferedReader(new FileReader(gffFile));
			int count = 0;
			while ((line=in.readLine())!=null) {
				GFFRecord gff = new GFFRecord(line);
				if (gff.type!=null && gff.type.equals("gene")) {
					// strip "gene:" from ID and Name, typical of Ensembl GFFs
					if (gff.attributeID.startsWith("gene:")) gff.attributeID = gff.attributeID.substring(5);
					if (gff.attributeName.startsWith("gene:")) gff.attributeName = gff.attributeName.substring(5);
					db.executeUpdate("INSERT INTO "+dbTable+" (seqid,source,\"type\",\"start\",\"end\",strand,id,name,biotype,description,version,genus,species) VALUES (" +
									 Util.charsOrNull(gff.seqid)+"," +
									 Util.charsOrNull(gff.source)+"," +
									 Util.charsOrNull(gff.type)+"," +
									 Util.intOrNull(gff.start)+"," +
									 Util.intOrNull(gff.end)+"," +
									 Util.charOrNull(gff.strand)+"," +
									 Util.charsOrNull(gff.attributeID)+"," +
									 Util.charsOrNull(gff.attributeName)+"," +
									 Util.charsOrNull(gff.attributeBiotype)+"," +
									 Util.charsOrNull(gff.attributeDescription)+"," +
									 gff.attributeVersion+"," +
									 Util.charsOrNull(genus)+"," +
									 Util.charsOrNull(species) +
									 ")");
					// output line every 1000 genes so we see progress
					if ((count++)%1000==0) System.out.println(gff.attributeID+"\t"+gff.attributeName);
				}
			}
			in.close();
			
			db.close();

		} catch (Exception ex) {
			System.err.println(ex.toString());
		}

    }

}
