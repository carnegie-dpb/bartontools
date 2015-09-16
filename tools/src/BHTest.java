import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Test Util.bhAdjust against a Cuffdiff run which has calculated q_values as well
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class BHTest {

  public static void main(String[] args) {

    if (args.length!=3) {
      System.err.println("Usage: BHTest schema baseCondition deCondition");
      return;
    }

    String schema = args[0];
    String baseCondition = args[1];
    String deCondition = args[2];

    DB db = null;

    try {

      // create schema-specific DB connection
      db = new DB();
      db.setSearchPath(schema);

      // get all the CuffdiffResults
      CuffdiffResult[] results = CuffdiffResult.getAll(db, baseCondition, deCondition);
      System.out.println("Retrieved "+results.length+" Cuffdiff results.");

      // form the p-value array
      double[] p = new double[results.length];
      double[] q = new double[results.length];
      for (int i=0; i<results.length; i++) {
	  p[i] = results[i].p;
	  q[i] = results[i].q;
      }

      // BH-adjust
      double[] qq = Util.bhAdjust(p);

      // and dump out results
      for (int i=0; i<results.length; i++) {
      	System.out.println(results[i].shortname+"\t"+p[i]+"\t"+q[i]+"\t"+qq[i]);
      }

    } catch (Exception ex) {

      System.err.println(ex.getMessage());

    }

  }

}

