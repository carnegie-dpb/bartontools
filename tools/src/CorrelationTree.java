import edu.carnegiescience.dpb.bartonlab.*;

import java.text.DecimalFormat;
import java.util.Iterator;
import java.util.Scanner;
import java.util.TreeSet;

/**
 * Builds a correlation tree taking a single gene as input and generating a tree by finding genes at higher and higher correlation.
 * Schema and condition are command line inputs. Gene ID is entered interactively so that more than one gene can be studied without
 * having to reload the expression array each time.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationTree {

	// Create a single shared Scanner for keyboard input
	static Scanner scanner = new Scanner(System.in);

	public static void main(String[] args) {

		if (args.length!=2) {
			System.out.println("Usage: CorrelationTree schema condition");
			return;
		}

		String schema = args[0];
		String condition = args[1];

		DecimalFormat df = new DecimalFormat("#0.000");

		DB db = null;

		try {

			// we'll use one connection throughout
			db = new DB();
			db.setSearchPath(schema);

			// samples for condition selection
			Sample[] samples = new Sample[0];
			if (condition.equals("ALL")) {
				samples = Sample.getAll(db);
			} else {
				samples = Sample.get(db, condition);
			}

			// all genes
			System.out.print("Loading expression array...");
			Expression[] eAll = Expression.getAll(db);
			System.out.println("done.");

			// infinite I/O loop, CTRL-C to cancel out
			while (true) {

				// get gene ID from text input
				System.out.println("--------------------------------------------------------------");
				System.out.print("Enter gene ID: ");
				String id = scanner.nextLine();
				SimpleGene gene = new SimpleGene(id);

				// geneSet stores genes
				TreeSet<Gene> geneSet = new TreeSet<Gene>();
				geneSet.add(gene);

				// tally rounds and keep track of size of geneSet; we're done when size doesn't change
				boolean done = false;
				int round = 0;

				// scan through the genes until none produce new genes
				while (!done) {
					round++;
					CorrelationPair pair = findMaxCorrPair(new Expression(db,gene), eAll, samples);
					if (!geneSet.contains(pair.gene2)) {
						geneSet.add(pair.gene2);
						TAIRGene tg1 = new TAIRGene(db, "TAIR10", pair.gene1);
						TAIRGene tg2 = new TAIRGene(db, "TAIR10", pair.gene2);
						String sn1 = tg1.symbol;
						String sn2 = tg2.symbol;
						if (sn1==null) sn1 = tg1.id;
						if (sn2==null) sn2 = tg2.id;
						System.out.println(round+" "+pair.gene1.id+"("+df.format(pair.corrSpearman)+")"+pair.gene2.id+"  "+sn1+"("+df.format(pair.corrSpearman)+")"+sn2);
						gene = (SimpleGene) pair.gene2;
					} else {
						done = true;
					}
				}
	
				System.out.println("Final geneSet.size="+geneSet.size());

				Gene[] genes = geneSet.toArray(new Gene[0]);
				for (int i=0; i<genes.length; i++) {
					System.out.print(genes[i].id+" ");
				}
				System.out.println("");

			}

		} catch (Exception ex) {

			System.out.println(ex.toString());

		} finally {

			try {
				db.close();
			} catch (Exception ex) {
				System.out.println(ex.toString());
			}

		}

	}

	/**
	 * Scan for the highest correlator of gene given in e (other than g itself).
	 * Dorky method, but probably not that much slower than something really clever.
	 */
	static CorrelationPair findMaxCorrPair(Expression e, Expression[] eAll, Sample[] samples) {
		CorrelationPair pair = null;
		double aMax = 0.0;
		for (int i=0; i<eAll.length; i++) {
			if (!eAll[i].gene.equals(e.gene)) {
				double aCorr = Math.abs(CorrelationResult.spearmansCorrelation(e.values, eAll[i].values, samples));
				if (aCorr>aMax) {
					aMax = aCorr;
					pair = new CorrelationPair(e.gene, eAll[i].gene, 0.0, aCorr);
				}
			}
		}
		return pair;
	}
	
	/**
	 * Scan for the genes that correlate strictly above the given absolute correlation minimum.
	 */
	static CorrelationPair[] findCorrPairs(Expression e, Expression[] eAll, Sample[] samples, double aMin) {
		TreeSet<CorrelationPair> set = new TreeSet<CorrelationPair>();
		for (int i=0; i<eAll.length; i++) {
			if (!eAll[i].gene.equals(e.gene)) {
				double aCorr = Math.abs(CorrelationResult.spearmansCorrelation(e.values, eAll[i].values, samples));
				if (aCorr>aMin) set.add(new CorrelationPair(e.gene, eAll[i].gene, 0.0, aCorr));
			}
		}
		return set.toArray(new CorrelationPair[0]);
	}
    
}
