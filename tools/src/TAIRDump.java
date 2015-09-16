import edu.carnegiescience.dpb.bartonlab.*;

/**
 * Dumps out the main IDs, short names and long names for all TAIR genes. Version is input on the command line.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class TAIRDump {

	public static void main(String[] args) {

		if (args.length<1) {
			System.out.println("Usage: TAIRDump version");
			return;
		}
    
		String version = args[0];

		DB db1 = null;
		DB db2 = null;

		try {

			db1 = new DB();
			db2 = new DB();

			String tablename = TAIRGene.makeTablename(version);
			db1.executeQuery("SELECT DISTINCT substring(modelname for 9) AS id FROM "+tablename+" ORDER BY id");
			while (db1.rs.next()) {
				String id = db1.rs.getString("id");
				TAIRGene gene = new TAIRGene(db2, version, id);
				String symbol = gene.symbol;
				if (symbol==null) symbol = gene.id;
				String longName = gene.longName;
				if (longName==null) longName = "";
				System.out.println(gene.id+"\t"+symbol+"\t"+longName);
			}

		} catch (Exception ex) {
      
			System.out.println(ex.toString());
      
		} finally {
      
			if (db1!=null) {
				try {
					db1.close();
				} catch (Exception ex) {
					System.out.println(ex.toString());
				}
			}
			if (db2!=null) {
				try {
					db2.close();
				} catch (Exception ex) {
					System.out.println(ex.toString());
				}
			}

		}
    
	}
  
}
