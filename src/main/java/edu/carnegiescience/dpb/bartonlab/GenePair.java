package edu.carnegiescience.dpb.bartonlab;

/**
 * Simply contains a pair of genes, typically because their proteins interact.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class GenePair implements Comparable {

  /** one gene */
  public Gene gene1;

  /** the other gene */
  public Gene gene2;

  /** Simple constructor; place lower alpha gene first */
  public GenePair(Gene g1, Gene g2) {
    this.gene1 = g1;
    this.gene2 = g2;
  }

  /** Return true if the given object contains the same two genes (in either slot) */
  public boolean equals(Object o) {
    GenePair that = (GenePair) o;
    return (
	    (this.gene1.equals(that.gene1) && this.gene2.equals(that.gene2)) || 
	    (this.gene1.equals(that.gene2) && this.gene2.equals(that.gene1))
	    );
  }

  /** Return comparison based on gene1 then gene2 */
  public int compareTo(Object o) {
    GenePair that = (GenePair) o;
    if (this.gene1.equals(that.gene1)) {
      return this.gene2.compareTo(that.gene2);
    } else {
      return this.gene1.compareTo(that.gene1);
    }
  }

}
