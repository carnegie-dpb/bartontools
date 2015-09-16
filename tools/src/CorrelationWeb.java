import edu.carnegiescience.dpb.bartonlab.*;

import java.util.TreeSet;

/**
 * Generate the correlation network for genes that correlate with the given gene above the given threshold, and so on until
 * the second gene is included, or the network is exhausted.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationWeb {

  public static void main(String[] args) {

    if (args.length!=5) {
      System.out.println("Usage: CorrelationWeb schema condition startGene endGene threshold");
      return;
    }

    String schema = args[0];
    String condition = args[1];
    SimpleGene startGene = new SimpleGene(args[2]);
    SimpleGene endGene = new SimpleGene(args[3]);
    double threshold = Double.parseDouble(args[4]);

    try {

      // we'll use one connection throughout
      DB db = new DB();
      db.setSearchPath(schema);

	  // samples for condition selection
	  Sample[] samples = new Sample[0];
	  if (condition.equals("ALL")) {
		  samples = Sample.getAll(db);
	  } else {
		  samples = Sample.get(db, condition);
	  }

      // expression for all genes
      Expression[] expr = Expression.getAll(db);

      // store the correlated genes in a TreeSet
      TreeSet<Gene> geneSet = new TreeSet<Gene>();
      geneSet.add(startGene);

      // store the computed Correlation Pairs in a TreeSet
      TreeSet<CorrelationPair> pairSet = new TreeSet<CorrelationPair>();

      System.out.println("gene1\tgene2\tcorrSpearman");

      boolean found = false; // true when target gene has been found
      boolean exhausted = false; // true when no new correlations above threshold are found
      while (!found && !exhausted) {
	exhausted = true;
	Gene[] genes = geneSet.toArray(new Gene[0]);
	for (int i=0; i<genes.length; i++) {
	  Gene gene1 = genes[i];
	  for (int j=0; j<expr.length; j++) {
	    Gene gene2 = expr[j].gene;
	    if (!gene1.equals(gene2)) {
	      CorrelationPair cp = new CorrelationPair(gene1, gene2, 0.0, 0.0);
	      if (!pairSet.contains(cp)) {
		Expression expr1 = new Expression(db, gene1);
		double corrS = 0.0;
		corrS = CorrelationResult.spearmansCorrelation(expr1.values, expr[j].values, samples);
		if (Math.abs(corrS)>threshold) {
		  pairSet.add(new CorrelationPair(gene1, gene2, 0.0, corrS));
		  geneSet.add(gene2);
		  System.out.println(gene1.id+"\t"+gene2.id+"\t"+corrS);
		  exhausted = false;
		  if (gene2.equals(endGene)) found = true;
		}
	      }
	    }
	  }
	}
      }

      db.close();

    } catch (Exception ex) {

      System.out.println(ex.toString());

    }

  }

    
}
