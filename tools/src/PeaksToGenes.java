import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Iterator;
import java.util.TreeSet;

/**
 * Assigns MACS-generated peaks to the genes over which they overlap.
 * Input: a MACS2 NAME_peaks.narrowPeak (BED6+4) file
 *        a GFF3 file containing gene names and locations
 * Output: a tab-delimited list of genes and peaks
 */

public class PeaksToGenes {

	public static void main(String[] args) {

		if (args.length!=2) {
			System.err.println("Usage: PeaksToGenes NAME_peaks.narrowPeak genes.gff3");
			return;
		}

		try {
			
            String line = null;
			BufferedReader in = null;

			// load peaks
			TreeSet<MACSNarrowPeakRecord> peakSet = new TreeSet<MACSNarrowPeakRecord>();
            in = new BufferedReader(new FileReader(args[0]));
            while ((line=in.readLine())!=null) peakSet.add(new MACSNarrowPeakRecord(line));

			// load genes
			TreeSet<GFFRecord> geneSet = new TreeSet<GFFRecord>();
			in = new BufferedReader(new FileReader(args[1]));
            while ((line=in.readLine())!=null) geneSet.add(new GFFRecord(line));

			// scan over genes, scanning peaks for overlap each time (inefficient, but fast anyway)
			for (GFFRecord gene : geneSet) {
				for (MACSNarrowPeakRecord peak : peakSet) {
					if (peak.insideOf(gene)) System.out.println(gene.attributeID+"\t"+gene.attributeName+"\t"+peak.name);
				}
			}
			
		} catch (Exception ex) {

			System.err.println(ex.toString());

		}

	}

}
