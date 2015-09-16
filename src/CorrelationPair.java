package edu.carnegiescience.dpb.bartonlab;

/**
 * Contains a pair of genes with their Pearson and Spearman rank correlation coefficients.
 * Comparison is done using Spearman's rank correlation.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationPair implements Comparable {

  /** one gene */
  public Gene gene1;

  /** the other gene */
  public Gene gene2;

  /** Pearson's correlation coefficient */
  public double corrPearson;

  /** Spearman's rank correlation coefficient */
  public double corrSpearman;

  /** Simple constructor; place lower alpha gene first */
  public CorrelationPair(Gene g1, Gene g2, double corrP, double corrS) {
    this.gene1 = g1;
    this.gene2 = g2;
    this.corrPearson = corrP;
    this.corrSpearman = corrS;
  }

  /** Return true if the given object contains the same two genes (in either slot) */
  public boolean equals(Object o) {
    CorrelationPair that = (CorrelationPair) o;
    return (
	    (this.gene1.equals(that.gene1) && this.gene2.equals(that.gene2)) || 
	    (this.gene1.equals(that.gene2) && this.gene2.equals(that.gene1))
	    );
  }

  /** Return comparison based on gene1 then gene2 */
  public int compareTo(Object o) {
    CorrelationPair that = (CorrelationPair) o;
    if (this.gene1.equals(that.gene1)) {
      return this.gene2.compareTo(that.gene2);
    } else {
      return this.gene1.compareTo(that.gene1);
    }
  }

}
