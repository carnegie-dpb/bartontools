import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Combine the four time points for each time-wise DE condition into a single record with arrays for each value, dumped into a text file.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class DECombiner {

  public static void main(String[] args) {

    DB db1 = null;
    DB db2 = null;

    try {

      db1 = new DB();
      db2 = new DB();

      String[] conditions = { "AS2", "REV", "KAN" };
      int[] times = { 0, 30, 60, 120 };

      // loop through each condition
      for (int i=0; i<conditions.length; i++) {
	// KAN only got three times
	int nTimes = 4;
	if (conditions[i].equals("KAN")) nTimes = 3;
	// form the table names we'll query
	String[] tables = new String[4];
	tables[0] = conditions[i].toLowerCase()+".0";
	tables[1] = conditions[i].toLowerCase()+".30";
	tables[2] = conditions[i].toLowerCase()+".60";
	tables[3] = conditions[i].toLowerCase()+".120";
	// outer loop through genes
	db1.executeQuery("SELECT probe_set_id FROM \""+tables[0]+"\" ORDER BY probe_set_id");
	while (db1.rs.next()) {
	  String probe_set_id = db1.rs.getString("probe_set_id");
	  double[] logfc = new double[4];
	  double[] aveexpr = new double[4];
	  double[] t = new double[4];
	  double[] pvalue = new double[4];
	  double[] adjpval = new double[4];
	  double[] b = new double[4];
	  // inner loop through times
	  for (int j=0; j<nTimes; j++) {
	    db2.executeQuery("SELECT * FROM \""+tables[j]+"\" WHERE probe_set_id='"+probe_set_id+"'"); // should be just one row
	    if (db2.rs.next()) {
	      logfc[j] = db2.rs.getDouble("logfc");
	      aveexpr[j] = db2.rs.getDouble("aveexpr");
	      t[j] = db2.rs.getDouble("t");
	      pvalue[j] = db2.rs.getDouble("pvalue");
	      adjpval[j] = db2.rs.getDouble("adjpval");
	      b[j] = db2.rs.getDouble("b");
	    }
	  }
	  // output a record; last KAN values will be zero
	  System.out.print(probe_set_id+"\t"+"WT"+"\t"+"GR-"+conditions[i]);
	  outputValues(logfc);
	  outputValues(aveexpr);
	  outputValues(t);
	  outputValues(pvalue);
	  outputValues(adjpval);
	  outputValues(b);
	  System.out.print("\n");
	}
      }

    } catch (Exception ex) {

      System.out.println(ex.toString());

    } finally {

      try {
	db1.close();
	db2.close();
      } catch (Exception ex) {
	System.out.println(ex.toString());
      }

    }

  }

  /** output a double array */
  static void outputValues(double[] values) {
    System.out.print("\t{"+values[0]);
    for (int j=1; j<values.length; j++) System.out.print(","+values[j]);
    System.out.print("}");
  }

}



