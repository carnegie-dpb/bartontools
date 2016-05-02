import edu.carnegiescience.dpb.bartonlab.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;
import org.apache.commons.math3.stat.correlation.SpearmansCorrelation;

/**
 * Run through all of the genes for a set of input conditions, dumping out pairs that have Pearson's correlation FDR-adjusted q-values below the input minimum.
 * Log2(values) is taken so that down-expression is treated equally with up-expression.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationMiner {

  public static void main(String[] args) {

    if (args.length<4) {
      System.err.println("Usage: CorrelationMiner schema qMax gene condition1 condition2 condition3 condition4 condition5");
      return;
    }

    String schema = args[0];
    double qMax = Double.parseDouble(args[1]);
    String geneID = args[2].toUpperCase();
    String[] conditions = new String[args.length-3];
    for (int i=0; i<conditions.length; i++) conditions[i] = args[i+3];

    DB db = null;

    try {

      // we'll use one connection throughout
      db = new DB();
      db.setSearchPath(schema);

      // get all samples since we need to set them manually in Expression array members
      Sample[] samples = Sample.getAll(db);

      // expression for input gene
      Expression expr1 = new Expression(db, new Gene(geneID));

      // expression for all genes, manually set samples
      Expression[] expr2 = Expression.getAll(db);
      for (int i=0; i<expr2.length; i++) {
	expr2[i].samples = samples;
      }

      // done with db
      db.close();

      PearsonsCorrelation pCorr = new PearsonsCorrelation();
      SpearmansCorrelation sCorr = new SpearmansCorrelation();

      // input values for gene 1
      double[] values1 = Util.log2(expr1.getValues(conditions));

      // scan over genes
      HashMap<String,Double> pCorrMap = new HashMap<String,Double>();
      HashMap<String,Double> sCorrMap = new HashMap<String,Double>();
      HashMap<String,String> pMap = new HashMap<String,String>(); // p is string because BH routine is weird
      for (int i=0; i<expr2.length; i++) {
	if (!expr1.equals(expr2[i]) && !expr2[i].gene.id.startsWith("ATXG")) {
	  // input values for gene 2
	  double[] values2 = Util.log2(expr2[i].getValues(conditions));
	  // run correlations
	  double pc = pCorr.correlation(values1, values2);
	  if (!Double.isNaN(pc)) {
	    // add to maps
	    double sc = sCorr.correlation(values1, values2);
	    pCorrMap.put(expr2[i].gene.id, pc);
	    sCorrMap.put(expr2[i].gene.id, sc);
	    pMap.put(expr2[i].gene.id, ""+Util.pPearson(pc, values1.length));
	  }
	}
      }

      // B-H adjust the p values
      BenjaminiHochbergFDR bh = new BenjaminiHochbergFDR(pMap, new BigDecimal(qMax));
      bh.calculate();
      HashMap<String,String> correctionMap = bh.getCorrectionMap();

      // output
      int coNumber = 0;
      int antiNumber = 0;
      double corrPMin = 1;
      double corrPMax = 0;
      System.out.println("gene1\tconditions\tgene2\tcorrS\tcorrP\tp\tq");
      String conditionsString = conditions[0];
      for (int k=1; k<conditions.length; k++) conditionsString += "+"+conditions[k];

      Iterator it = correctionMap.keySet().iterator();
      while (it.hasNext()) {
	String id = (String)it.next();
	double q = Double.parseDouble(correctionMap.get(id));
	if (q<qMax) {
	  double pc = pCorrMap.get(id);
	  double sc = sCorrMap.get(id);
	  double p = Double.parseDouble(pMap.get(id));
      	  System.out.println(geneID+"\t"+conditionsString+"\t"+id+"\t"+sc+"\t"+pc+"\t"+p+"\t"+q);
      	  if (pc<0) antiNumber++; else coNumber++;
      	  if (Math.abs(pc)>corrPMax) corrPMax = Math.abs(pc);
      	  if (Math.abs(pc)<corrPMin) corrPMin = Math.abs(pc);
      	}
      }

      // some overall stats
      System.out.println((coNumber+antiNumber)+" total; "+coNumber+" co-correlated; "+antiNumber+" anti-correlated; min(|corrP|)="+corrPMin+"; max(|corrP|)="+corrPMax);

    } catch (Exception ex) {

      System.out.println(ex.toString());

    }

  }

    
}
