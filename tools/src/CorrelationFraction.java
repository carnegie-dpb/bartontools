import edu.carnegiescience.dpb.bartonlab.*;

import java.text.DecimalFormat;
import java.util.Scanner;
import java.util.TreeSet;

/**
 * Run through all of the genes for an input gene, counting the number of genes that correlate above set fractions 0.1, 0.2, etc.
 * Keeps track of positive and negative correlations as well.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationFraction {

	// Create a single shared Scanner for keyboard input
	static Scanner scanner = new Scanner(System.in);

	public static void main(String[] args) {

		DecimalFormat df = new DecimalFormat(" 0.0;-0.0");

		if (args.length!=2) {
			System.out.println("Usage: CorrelationFraction schema condition");
			return;
		}

		String schema = args[0];
		String condition = args[1];

		DB db = null;

		try {

			db = new DB();
			db.setSearchPath(schema);

			// samples for condition selection
			Sample[] samples = new Sample[0];
			if (condition.equals("ALL")) {
				samples = Sample.getAll(db);
			} else {
				samples = Sample.get(db, condition);
			}

			// expression for all genes
			System.out.print("Loading expression for all genes...");
			Expression[] expr2 = Expression.getAll(db);
			System.out.println("done.");

			db.close();

			// infinite I/O loop, CTRL-C to cancel out
			while (true) {

				// get gene ID from text input
				System.out.println("--------------------------------------------------------------");
				System.out.print("Enter gene ID: ");
				String id = scanner.nextLine().toUpperCase();
				System.out.println("--------------------------------------------------------------");
		  
				// get gene's expression
				Gene gene1 = new Gene(id);
				db = new DB();
				db.setSearchPath(schema);
				Expression expr1 = new Expression(db, gene1);
				db.close();
		  
				// store corrs in a TreeSet for later binning
				TreeSet<Double> set = new TreeSet<Double>();
		  
				// scan through the genes
				for (int i=0; i<expr2.length; i++) {
					set.add(CorrelationResult.spearmansCorrelation(expr1.values, expr2[i].values, samples));
				}
	
				// now output counts within bins with an asterisk histogram
				for (double d=-1.0; d<0.95; d+=0.1) {
					int count = set.subSet(d,d+0.1).size();
					System.out.print(df.format(d)+" to "+df.format((d+0.1))+": "+count+"\t");
					if (count<10) System.out.print("\t"); // need extra tab for small counts
					if (count>0 && count<100) System.out.print("*"); // minimum one asterisk if positive count
					for (int i=0; i<count/100; i++) System.out.print("*");
					System.out.println("");
				}

			}

		} catch (Exception ex) {

			System.out.println(ex.toString());

		}

	}

    
}
