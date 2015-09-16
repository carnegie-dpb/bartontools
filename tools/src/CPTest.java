import edu.carnegiescience.dpb.bartonlab.*;

import java.util.TreeSet;

/**
 * Test the CorrelationPair class.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CPTest {

  public static void main(String[] args) {

    Gene g1 = new SimpleGene("AT1G10000");
    Gene g2 = new SimpleGene("AT2G10000");

    CorrelationPair cp1 = new CorrelationPair(g1, g2, 0.4, 0.6);
    CorrelationPair cp2 = new CorrelationPair(g2, g1, 0.0, 0.0);

    System.out.println("cp1.equals(cp2)="+cp1.equals(cp2));
    System.out.println("cp1.compareTo(cp2)="+cp1.compareTo(cp2));

    TreeSet<CorrelationPair> set = new TreeSet<CorrelationPair>();
    set.add(cp1);

    System.out.println("set.contains(cp1)="+set.contains(cp1));
    System.out.println("set.contains(cp2)="+set.contains(cp2));

  }

}
