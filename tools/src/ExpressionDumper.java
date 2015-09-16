import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Writes out expression to a tab-delimited file, optionally taking log2(values+1)
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class ExpressionDumper {

  public static void main(String[] args) {

    if (args.length!=4) {
      System.err.println("Usage: ExpressionDumper schema condition logData plus1");
      return;
    }

    String schema = args[0];
    String condition = args[1];
    boolean logData = args[2].equals("true");
    boolean plus1 = args[3].equals("true");

    DB db = null;

    try {

      // get the expression data and samples for this condition
      db = new DB();
      db.setSearchPath(schema);
      Sample[] samples = Sample.get(db,condition);
      Expression[] expr = Expression.getAll(db);

      // write sample labels to header with gene label over gene IDs
      System.out.print("gene");
      for (int i=0; i<samples.length; i++) System.out.print("\t"+samples[i].label);
      System.out.println("");

      // loop through each gene, writing out tab-delimited values for the condition samples
      for (int i=0; i<expr.length; i++) {
	System.out.print(expr[i].gene.id);
	for (int j=0; j<samples.length; j++) {
	  int k = samples[j].num - 1; // value index
	  double val = 0.0;
	  if (logData && plus1) {
	    val = Util.log2(expr[i].values[k]+1);
	  } else if (logData) {
	    val = Util.log2(expr[i].values[k]);
	  } else {
	    val = expr[i].values[k];
	  }
	  System.out.print("\t"+val);
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

}



