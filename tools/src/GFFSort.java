import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStreamReader;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeSet;

/**
 * Sorts a GFF file by GFFRecord's native comparator (Name, sequence, start, end) or other comparators as given by options.
 */
public class GFFSort {

    public static final int DEFAULT_MAX_NEIGHBOR_GAP=5000;

    public static void main(String[] args) {

		if (args.length==0) {
			System.out.println("java GFFSort --help --trim-trinity --sort-by-id --group-neighbors=N --keep-highest-score --min-score=N --no-overlaps input.gff|-");
			System.exit(0);
		}

		// parse command line
		HashMap<String,String> options = new HashMap<String,String>();
		boolean stdInput = false;
		String gffFile = null;
		for (int i=0; i<args.length; i++) {
			if (args[i].equals("-")) {
				stdInput = true;
			} else if (args[i].startsWith("--")) {
				String[] pieces = args[i].split("=");
				String option = pieces[0].substring(2);
				String value = "";
				if (pieces.length>1) value = pieces[1];
				options.put(option,value);
			} else {
				gffFile = args[i];
			}
		}

		// the options
		boolean help = options.containsKey("help"); // show help and exit
		boolean trimTrinity = options.containsKey("trim-trinity");
		boolean sortByID = options.containsKey("sort-by-id");
		int maxNeighborGap = DEFAULT_MAX_NEIGHBOR_GAP;
		boolean groupNeighbors = options.containsKey("group-neighbors"); // American spelling, muthas
		if (groupNeighbors && options.get("group-neighbors").length()>0) maxNeighborGap = Integer.parseInt(options.get("group-neighbors"));
		int minScoreValue = 0;
		boolean minScore = options.containsKey("min-score");
		if (minScore && options.get("min-score").length()>0) minScoreValue = Integer.parseInt(options.get("min-score"));
		boolean noOverlaps = options.containsKey("no-overlaps");
		boolean keepHighestScore = options.containsKey("keep-highest-score");

		// spit out help and exit
		if (help) {
			System.out.println("java GFFSort --help --trim-trinity --sort-by-id --group-neighbors=N --keep-highest-score --min-score=N --no-overlaps input.gff|-");
			System.out.println("Sorts a GFF file by GFFRecord's native comparator (Name, sequence, start, end) or other comparators as given by options.");
			System.out.println("Options:");
			System.out.println("\t--trim-trinity\t\ttrim off the part after g# in the Trinity-assigned name attribute");
			System.out.println("\t--sort-by-id\t\tsort by ID attribute only (for fast loading with bp_seqfeature_load.pl)");
			System.out.println("\t--group-neighbors=N\tgroup neighbors within N bases of each other ["+DEFAULT_MAX_NEIGHBOR_GAP+"]");
			System.out.println("\t--keep-highest-score\tif two or more hits have same name, keep the one with the highest score");
			System.out.println("\t--min-score=N\t\tdrop hits with score less than N [0]");
			System.out.println("\t--no-overlaps\t\tremove overlapping features regardless of name or ID; last in survives");
			System.exit(0);
		}

		// place the GFF records in a TreeSet for sorting
		TreeSet<GFFRecord> sortedSet;
		if (noOverlaps) {
			sortedSet = new TreeSet<GFFRecord>(GFFRecord.StartEndComparator);
		} else if (sortByID) {
			sortedSet = new TreeSet<GFFRecord>(GFFRecord.IDComparator);
		} else if (keepHighestScore) {
			sortedSet = new TreeSet<GFFRecord>(GFFRecord.ScoreComparator);
		} else {
			sortedSet = new TreeSet<GFFRecord>();
		}
		String line = null;
		try {
			BufferedReader in = null;
			if (stdInput) {
				in = new BufferedReader(new InputStreamReader(System.in));
			} else if (gffFile!=null) {
				in = new BufferedReader(new FileReader(gffFile));
			}
			while ((line=in.readLine())!=null) {
				GFFRecord gff = new GFFRecord(line);
				if (gff.seqid!=null) {
					if (trimTrinity) {
						String[] pieces = gff.attributeName.split("_i");
						gff.updateAttributeName(pieces[0]);
					}
					if (minScore) {
						double score = Double.parseDouble(gff.score);
						if (score>=minScoreValue) sortedSet.add(gff);
					} else {
						sortedSet.add(gff);
					}
				} else {
					System.out.println(line);
				}
			}
			in.close();
		} catch (Exception ex) {
			System.err.println(ex.toString());
			System.err.println("Offending line:");
			System.err.println(line);
		}

		// put the sortedSet into a thinnedSet for those options that eliminate duplicates
		TreeSet<GFFRecord> thinnedSet;
		if (keepHighestScore) {
			thinnedSet = new TreeSet<GFFRecord>(GFFRecord.NameComparator);
			thinnedSet.addAll(sortedSet);
		} else {
			thinnedSet = sortedSet;
		}

		// write out the sorted records, optionally setting the attributeID equal for nearby hits
		int scaffold = 0;
		GFFRecord lastContig = null;
		for (GFFRecord contig : thinnedSet) {
			if (groupNeighbors) {
				if (scaffold==0) {
					// initialize
					scaffold++;
					lastContig = contig;
				} else if (contig.trinityName!=null) {
					// grouping by Trinity name
					if (!contig.trinityName.equals(lastContig.trinityName) || GFFRecord.gap(contig,lastContig)>maxNeighborGap) scaffold++;
				} else if (contig.ensemblName!=null) {
					// grouping by Ensembl name
					if (!contig.ensemblName.equals(lastContig.ensemblName) || GFFRecord.gap(contig,lastContig)>maxNeighborGap) scaffold++;
				} else {
					// grouping by full name
					if (!contig.attributeName.equals(lastContig.attributeName) || GFFRecord.gap(contig,lastContig)>maxNeighborGap) scaffold++;
				}
				contig.updateAttributeID(scaffold);
			}
			System.out.println(contig.toString());
			lastContig = contig;
		}

    }

}
