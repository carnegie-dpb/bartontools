import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import java.util.Map;
import java.util.TreeMap;

/**
 * Update genes.fpkm_tracking records, replacing CUFF.n with GENE from GENE.1, GENE.2 in isoforms.fpkm_tracking.
 */
public class UpdateCufflinksGenes {


    public static void main(String[] args) {

        if (args.length!=1) {
            System.out.println("Usage: UpdateCufflinksGenes <directory>");
            System.exit(1);
        }

        String dirName = args[0];
        String genesFilename = dirName+"/genes.fpkm_tracking";
        String isoformsFilename = dirName+"/isoforms.fpkm_tracking";

        File genesFile = new File(genesFilename);
        File isoformsFile = new File(isoformsFilename);

        if (!genesFile.exists()) {
            System.err.println("Error: "+genesFilename+" does not exist.");
            System.exit(1);
        }
        if (!isoformsFile.exists()) {
            System.err.println("Error: "+isoformsFilename+" does not exist.");
            System.exit(1);
        }

            
        // isoforms.fpkm_tracking:
        // AT1G01080.2	-	-	CUFF.3	-	-	1:45295-47019	1322	0	0	0	0.111693	OK
        // AT1G01080.1	-	-	CUFF.3	-	-	1:45295-47019	1319	87.6348	25.1215	22.3542	27.8888	OK
        // CUFF.3.3	-	-	CUFF.3	-	-	1:45452-47019	1248	23.6357	6.77544	5.12896	8.42192	OK
        // genes.fpkm_tracking
        // 0            1       2       3       4       5       6               7       8       9       10      11      12
        // CUFF.3	-	-	CUFF.3	-	-	1:45295-47019	-	-	31.897	28.9475	34.8465	OK

        try {
            
            // store the non-CUFF isoforms in a map keyed by CUFF gene name
            Map<String,String> isoforms = new TreeMap<String,String>();

            // run through isoforms file, collecting CUFF.* and AT* as key-value pairs in a map
            BufferedReader isoReader = new BufferedReader(new FileReader(isoformsFile));
            String line = isoReader.readLine(); // header
            while ((line=isoReader.readLine())!=null) {
                String[] parts = line.split("\t");
                String isoform = parts[0];
                String gene = parts[3];
                if (gene.contains("CUFF")) {
                    parts = isoform.split("\\.");
                    if (!parts[0].equals("CUFF")) isoforms.put(gene,parts[0]);
                }
            }

            // now run through the genes file and replace CUFF genes with AT genes from isoforms map where they exist
            BufferedReader geneReader = new BufferedReader(new FileReader(genesFile));
            line = geneReader.readLine(); // header in
            System.out.println(line);     // header out
            while ((line=geneReader.readLine())!=null) {
                String[] parts = line.split("\t");
                String gene = parts[0];
                if (isoforms.containsKey(gene)) {
                    gene = isoforms.get(gene);
                    System.out.println(gene+"\t"+"-"+"\t"+"-"+"\t"+gene+"\t"+"-"+"\t"+"-"+"\t"+parts[6]+"\t"+parts[7]+"\t"+parts[8]+"\t"+parts[9]+"\t"+parts[10]+"\t"+parts[11]+"\t"+parts[12]);
                } else if (!gene.contains("CUFF")) {
                    System.out.println(line);
                }
            }

        } catch (Exception ex) {
            System.err.println(ex.toString());
        }

    }


}
