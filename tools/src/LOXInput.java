import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Outputs the expression from the requested schema into a LOX-compatible text file.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class LOXInput {

  public static void main(String[] args) {

    if (args.length!=1) {
      System.err.println("Usage: LOXInput schema");
      return;
    }

    String schema = args[0];
    DB db = null;

    try {

      // get the experiment description
      db = new DB();
      Experiment experiment = new Experiment(db, schema);

      // get the expression data
      db.setSearchPath(schema);
      Sample[] samples = Sample.getAll(db);
      Expression[] expr = Expression.getAll(db);

      // first header row - sample labels
      System.out.print("\t");
      for (int i=0; i<samples.length; i++) System.out.print("\t"+samples[i].label);
      System.out.println("");

      // second header row - methods, or time in this case
      System.out.print("\t");
      for (int i=0; i<samples.length; i++) System.out.print("\t"+samples[i].time);
      System.out.println("");

      // third header row - treatments
      System.out.print("ID\tShort Name");
      for (int i=0; i<samples.length; i++) System.out.print("\t"+samples[i].condition);
      System.out.println("");

      // loop through each gene (row)
      for (int j=0; j<expr.length; j++) {
	System.out.print(expr[j].gene.id+"\t");
	for (int i=0; i<samples.length; i++) System.out.print("\t"+expr[j].values[i]);
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



