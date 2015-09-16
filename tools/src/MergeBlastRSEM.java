/**
 * Merge the results from BLASTing Trinity.fasta against a bunch of sequences (like TEs) with the abundance results that
 * Trinity creates with align_and_estimate_abundance.pl using RSEM.
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.TreeSet;

public class MergeBlastRSEM {
  
  public static void main(String[] args) {

    if (args.length!=2) {
      System.out.println("Usage: java MergeBlastRSEM <Blast -outfmt 6 file> <RSEM.isoforms.results>");
      System.exit(1);
    }

    String blastFilename = args[0];
    String rsemFilename = args[1];

    // Load the blastn output file adding each record to a TreeSet which sorts based on alignment length, so
    // we can save the alignment with the longest length further down.
    TreeSet<Blast6Record> blastLengthSet = new TreeSet<Blast6Record>(Blast6Record.LengthComparator);
    try {
      String line = null;
      int lineCount = 0;
      BufferedReader in = new BufferedReader(new FileReader(blastFilename));
      while ((line=in.readLine())!=null) {
	lineCount++;
	blastLengthSet.add(new Blast6Record(line));
      }
      in.close();
    } catch (Exception ex) {
      System.err.println(ex.toString());
    }

    // Now move the blastn records into a TreeSet which sorts based on query, target name, first in is
    // saved, so should have highest alignment length
    TreeSet<Blast6Record> blastNameSet = new TreeSet<Blast6Record>(Blast6Record.NameComparator);
    Iterator<Blast6Record> lengthIterator = blastLengthSet.descendingIterator();
    while (lengthIterator.hasNext()) {
	blastNameSet.add(lengthIterator.next());
    }

    // Load the RSEM output file adding each record to a TreeMap so we can find them.
    TreeMap<String,RSEMResult> rsemMap = new TreeMap<String,RSEMResult>();
    try {
      String line = null;
      int lineCount = 0;
      BufferedReader in = new BufferedReader(new FileReader(rsemFilename));
      String header = in.readLine(); // RSEM file has a header
      while ((line=in.readLine())!=null) {
	lineCount++;
	RSEMResult rsem = new RSEMResult(line);
	rsemMap.put(rsem.transcriptId, rsem);
      }
      in.close();
    } catch (Exception ex) {
      System.err.println(ex.toString());
    }

    // Plow through the blastNameSet and output the matching RSEM record by matching transcript id
    System.out.println("transcript\ttarget\tpct_ident\talign_length\tnum_mismatch\tnum_gaps\tqstart\tqend\ttstart\ttend\te-value\tbitscore\tlength\teff_length\texp_count\tTPM\tFPKM\tiso_pct");
    Iterator<Blast6Record> nameIterator = blastNameSet.iterator();
    while (nameIterator.hasNext()) {
      Blast6Record blast = nameIterator.next();
      RSEMResult rsem = rsemMap.get(blast.queryLabel);
      if (rsem!=null) {
	System.out.println(blast.toString()+"\t"+rsem.getTabbedLine());
      }
    }


  }

}
