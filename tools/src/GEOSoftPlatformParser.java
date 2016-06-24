import java.io.FileReader;
import java.io.BufferedReader;

import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Parses a GEO Soft file for relationships between platform ID and gene IDs, and updates expression table accordingly.
 *
 * The schema and SOFT input file is given on the command line.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class GEOSoftPlatformParser {

    public static void main(String[] args) {

        if (args.length!=2) {
            System.err.println("Usage: GEOSoftParser schema GEOSoftFile.soft");
            return;
        }

        String schema = args[0];
        String softfile = args[1];

        DB db = null;

        try {

            db = new DB();

            BufferedReader br = new BufferedReader(new FileReader(softfile));
            boolean readingData = false;
            String line = null;
            while ((line=br.readLine()) != null) {

                if (readingData) {
                    String[] parts = line.split("\t");
                    String id = parts[0];
                    String gb_acc = parts[1];
                    String orf = parts[2];
                    String miRNA_ID = parts[3];
                    String accessions = parts[4];
                    String[] aparts = accessions.split("\\|");
                    String geneID = aparts[0].toUpperCase();
                    if (geneID.length()>0) db.executeUpdate("UPDATE "+schema+".expression SET id='"+geneID+"' WHERE probe_set_id='"+id+"'");
                }
				
                if (line.startsWith("!platform_table_begin")) {
                    // skip the field heading, assumed to be:
                    // ID      GB_ACC  ORF     miRNA_ID        Accessions      SEQUENCE        ProbeUID        ControlType     ProbeName       GeneName        Description     SPOT_ID
                    String heading = br.readLine();
                    readingData = true;
                }

            }

        } catch (Exception ex) {

            System.out.println(ex.getMessage());

        } finally {

            if (db!=null) {

                try {
                    db.close();
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }

            }

        }
    
    }

}

