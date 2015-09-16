package org.bsharp.bio;

import java.sql.SQLException;

import org.apache.commons.math3.stat.regression.SimpleRegression;

/**
 * Calculate linear regression of expression versus time for each group of samples and store the results in the rnaseq database table 
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class CalcSimpleRegression {

  public static void main(String[] args) {

    DB db1 = null;
    DB db2 = null;

    String[] conditions = { "Col", "Rev", "Kan", "AS2", "STM" };

    int count = 0;

    try {

      db1 = new DB();
      db2 = new DB();

      db1.executeQuery("SELECT * FROM normalizedcounts ORDER BY id");
      while (db1.rs.next()) {

	String id = db1.rs.getString("id");

	if ((count++)%100 == 0) System.out.print(id+" ");

	for (int i=0; i<conditions.length; i++) {

	  SimpleRegression r = new SimpleRegression();

	  db2.executeQuery("SELECT * FROM lanes WHERE condition='"+conditions[i]+"'");
	  while (db2.rs.next()) {
	    String label = db2.rs.getString("label");
	    String condition = db2.rs.getString("condition");
	    double t = db2.rs.getDouble("time");
	    double counts = db1.rs.getDouble(label);
	    r.addData(t, counts);
	  }

	  long n = r.getN();
	  double intercept = r.getIntercept();
	  double slope = r.getSlope();
	  double slopeStdErr = r.getSlopeStdErr();
	  double meanSquareError = r.getMeanSquareError();
	  double rSquare = r.getRSquare();

	  if ( r.getN()>2 && 
	       !Double.isNaN(intercept) &&  
	       !Double.isNaN(slope) && 
	       !Double.isNaN(slopeStdErr) &&
	       !Double.isNaN(meanSquareError) &&
	       !Double.isNaN(rSquare)
	       ) {
	    db2.executeUpdate("INSERT INTO simpleregress VALUES (" +
			      "'"+id+"'," +
			      "'"+conditions[i]+"'," +
			      n+"," +
			      intercept+"," +
			      slope+"," +
			      slopeStdErr+"," +
			      meanSquareError+"," +
			      rSquare +
			      ")");
	    String r2string = (""+rSquare).substring(0,6);
	    // System.out.print("\t"+conditions[i]+":"+r2string);
	  }

	}

	// System.out.println("");

      }

      System.out.println("");

    } catch (Exception ex) {

      System.err.println(ex.toString());

    } finally {

      try {
	db1.close();
	db2.close();
      } catch (Exception ex) {
	System.err.println(ex.toString());
      }

    }

  }

}
