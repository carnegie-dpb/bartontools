package edu.carnegiescience.dpb.bartonlab;

/**
 * Abstract class which describes an analysis result, which currently just holds a gene, but may define some standard methods at some point.
 *
 * Subclasses have fields storing analysis-specific result data and methods for searching through the data and deriving further results.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2799 $ $Date: 2015-08-07 15:41:11 -0500 (Fri, 07 Aug 2015) $
 */
public abstract class AnalysisResult {

  /** the gene for which this result applies */
  public Gene gene = null;

  /** need empty constructor for classes that extend this abstract class, don't know why */
  public AnalysisResult() {
  }

  /**
   * Construct a shell holding the core fields
   */
  public AnalysisResult(Gene gene) {
    this.gene = gene;
  }

}
