import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Convert log2(values) into values
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class UnlogExpression {

  public static void main(String[] args) {

    if (args.length!=1) {
      System.err.println("Usage: UnlogExpression schema");
      return;
    }
    
    String schema = args[0];

    DB db = null;

    try {

      // get the expression data
      db = new DB();
      db.setSearchPath(schema);
      System.out.print("Loading "+schema+" expression...");
      Expression[] expr = Expression.getAll(db);
      System.out.println("done.");


      // loop through each gene, replace with 2^value for each value
      System.out.print("Unlogging expression values");
      for (int i=0; i<expr.length; i++) {
	if (i%100==0) System.out.print(".");
	double[] newValues = new double[expr[i].values.length];
	for (int j=0; j<expr[i].values.length; j++) newValues[j] = Math.pow(2.0, expr[i].values[j]);
	String valueString = "{"+newValues[0];
	for (int j=1; j<newValues.length; j++) valueString += ","+newValues[j];
	valueString += "}";
	db.executeUpdate("UPDATE expression SET values='"+valueString+"' WHERE id='"+expr[i].gene.id+"'");
      }
      System.out.println("done.");

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



