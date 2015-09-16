import java.io.File;
import java.util.TreeSet;

import org.biojava.nbio.sequencing.io.fastq.SangerFastqReader;
import org.biojava.nbio.sequencing.io.fastq.Fastq;

/**
 * Extract unique sequences from a FASTQ file and output them in FASTA format.
 */

public class Fastq2Fasta {

    public static void main(String[] args) throws Exception{
		
		if (args.length<1) {
			System.out.println("Usage: java Fastq2Fasta <FASTQ file>");
			System.exit(0);
		}
		
		File fastqFile = new File(args[0]);
		TreeSet<String> sequences = new TreeSet<String>();
		
		SangerFastqReader reader = new SangerFastqReader(); // modern Illumina machines produce Phred 33 files
		for (Fastq fastq : reader.read(fastqFile)) {
			String seq = fastq.getSequence();
			if (!sequences.contains(seq)) {
				sequences.add(seq);
				System.out.println(">"+fastq.getDescription());
				System.out.println(seq);
			}
		}
		
	}

}
