import edu.carnegiescience.dpb.bartonlab.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.TreeSet;

import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;
import org.apache.commons.math3.stat.correlation.SpearmansCorrelation;

/**
 * Compute correlations for genes input from an interaction table. Interacting and noninteracting genes are distinguished by a flag.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationInteractions {

  public static void main(String[] args) {

    if (args.length!=3) {
      System.err.println("Usage: CorrelationInteractions schema condition fileName");
      return;
    }

    String schema = args[0];
    String condition = args[1];
    String fileName = args[2];

    // may save a bit by instantiating these once
    PearsonsCorrelation pCorr = new PearsonsCorrelation();
    SpearmansCorrelation sCorr = new SpearmansCorrelation();

    DB db = null;

    try {

      // we'll use one connection throughout
      db = new DB();
      db.setSearchPath(schema);

      // load the interacting pairs into a TreeSet
      TreeSet<GenePair> pairSet = new TreeSet<GenePair>();
      
      // load each gene into a TreeSet
      TreeSet<Gene> geneSet = new TreeSet<Gene>();

      // open the file, load the interacting pairs into the TreeSet
      BufferedReader in = new BufferedReader(new FileReader(fileName));
      String header = in.readLine(); // first row is header
      String line = null;
      while ((line=in.readLine())!=null) {
	String[] parts = line.split(","); // comma-separated values
	SimpleGene gene1 = new SimpleGene(parts[0]);
	SimpleGene gene2 = new SimpleGene(parts[1]);
	pairSet.add(new GenePair(gene1, gene2));
	geneSet.add(gene1);
	geneSet.add(gene2);
      }

      // now spin through ALL the genes, outputting a flag if they're interacting (and have correlation already computed above)
      Gene[] genes = geneSet.toArray(new Gene[0]);
      for (int i=0; i<genes.length; i++) {
	Gene gene1 = genes[i];
	Expression expr1 = new Expression(db, gene1);
	if (expr1.values!=null) {
	  for (int j=i+1; j<genes.length; j++) {
	    Gene gene2 = genes[j];
	    Expression expr2 = new Expression(db, gene2);
	    if (expr2.values!=null) {
	      double[] values1;
	      double[] values2;
	      if (condition.equals("ALL")) {
		values1 = expr1.values;
		values2 = expr2.values;
	      } else {
		values1 = expr1.getValues(condition);
		values2 = expr2.getValues(condition);
	      }
	      double p = pCorr.correlation(values1, values2);
	      double s = sCorr.correlation(values1, values2);
	      // output with flag for whether pair is interacting
	      System.out.println(gene1.id+"\t"+gene2.id+"\t"+p+"\t"+s+"\t"+pairSet.contains(new GenePair(gene1,gene2)));
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
