/**
 * * Copyright (c) 2005 Flanders Interuniversitary Institute for Biotechnology (VIB)
 * *
 * * Authors : Steven Maere, Karel Heymans
 * *
 * * This program is free software; you can redistribute it and/or modify
 * * it under the terms of the GNU General Public License as published by
 * * the Free Software Foundation; either version 2 of the License, or
 * * (at your option) any later version.
 * *
 * * This program is distributed in the hope that it will be useful,
 * * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * * The software and documentation provided hereunder is on an "as is" basis,
 * * and the Flanders Interuniversitary Institute for Biotechnology
 * * has no obligations to provide maintenance, support,
 * * updates, enhancements or modifications.  In no event shall the
 * * Flanders Interuniversitary Institute for Biotechnology
 * * be liable to any party for direct, indirect, special,
 * * incidental or consequential damages, including lost profits, arising
 * * out of the use of this software and its documentation, even if
 * * the Flanders Interuniversitary Institute for Biotechnology
 * * has been advised of the possibility of such damage. See the
 * * GNU General Public License for more details.
 * *
 * * You should have received a copy of the GNU General Public License
 * * along with this program; if not, write to the Free Software
 * * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * *
 * * Authors: Steven Maere, Karel Heymans
 * * Date: Mar.25.2005
 * * Description: Class implementing the Benjamini and Hochberg FDR correction algorithm.        
 **/


import java.math.BigDecimal;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Arrays;


/**
 * ************************************************************************
 * BenjaminiHochbergFDR.java:  Steven Maere & Karel Heymans (c) March 2005
 * ------------------------
 * <p/>
 * Class implementing the Benjamini and Hochberg FDR correction algorithm.
 * <p/>
 * ************************************************************************
 */


public class BenjaminiHochbergFDR {

  /*--------------------------------------------------------------
    FIELDS.
    --------------------------------------------------------------*/

  private HashEntry[] hash ;
  /**
   * the GO labels that have been tested (constructor input).
   */
  private static String [] goLabels;
  /**
   * the raw p-values that were given as input for the constructor, order corresponds to String [] goLabels.
   */
  private static String [] pvalues;
  /**
   * the goLabels ordered according to the ordered pvalues.
   */
  private static String [] orderedGOLabels;
  /**
   * the raw p-values ordered in ascending order.
   */
  private static String [] orderedPvalues;
  /**
   * the adjusted p-values ordered in ascending order.
   */
  private static String [] adjustedPvalues;

  /**
   * hashmap with the results (adjusted p-values) as values and the GO labels as keys.
   */
  private static HashMap<String,String> correctionMap;

  /**
   * the significance level.
   */
  private static BigDecimal alpha;
  /**
   * the number of tests.
   */
  private static int m;
  /**
   * scale for the division in de method 'runFDR'.
   */
  private static final int RESULT_SCALE = 100;

  private int maxValue;


  /*--------------------------------------------------------------
    CONSTRUCTOR.
    --------------------------------------------------------------*/

  /**
   * Constructor.
   *
   * @param golabelstopvalues Hashmap of Strings with the goLabels and their pvalues.
   * @param alpha             BigDecimal with the desired significance level.
   */

  public BenjaminiHochbergFDR(HashMap golabelstopvalues, BigDecimal alpha) {
    // Get all the go labels and their corresponding pvalues from the map
    Iterator iteratorGoLabelsSet = golabelstopvalues.keySet().iterator();
    HashEntry [] hash = new HashEntry [golabelstopvalues.size()];
    String [] pvalues = new String [golabelstopvalues.size()];
    String [] goLabels = new String [golabelstopvalues.size()];
    for (int i = 0; iteratorGoLabelsSet.hasNext(); i++) {
      goLabels[i] = iteratorGoLabelsSet.next().toString() ;
      pvalues[i] = golabelstopvalues.get(goLabels[i]).toString();
      hash[i] = new HashEntry(goLabels[i], pvalues[i]) ;
    }
    this.hash = hash ;
    this.pvalues = pvalues;
    this.goLabels = goLabels;
    this.alpha = alpha;
    this.m = pvalues.length;
    this.adjustedPvalues = new String[m];
    this.correctionMap = null;

    this.maxValue = pvalues.length;
  }

  class HashEntry{
    public String key;
    public String value;
    public HashEntry(String k, String v){
      this.key = k ;
      this.value = v ;
    }
  } 
    
  class HashComparator implements java.util.Comparator {
    public int compare(Object o1, Object o2){
      return (new BigDecimal(((HashEntry) o1).value)).compareTo(new BigDecimal(((HashEntry) o2).value)) ;
    }
  }

  /*--------------------------------------------------------------
    METHODS.
    --------------------------------------------------------------*/

  /**
   * method that calculates the Benjamini and Hochberg correction of
   * the false discovery rate
   * NOTE : convert array indexes [0..m-1] to ranks [1..m].
   * order raw p-values low .. high
   * test p<(i/m)*alpha from high to low (for i=m..1)
   * i* (istar) first i such that the inequality is correct.
   * reject hypothesis for i=1..i* : labels 1..i* are overrepresented
   * <p/>
   * adjusted p-value for i-th ranked p-value p_i^adj = min(k=i..m)[min(1,m/k p_k)]
   */
  public void calculate() {
    // ordering the pvalues.
    java.util.Arrays.sort(hash, new HashComparator()) ; 
    this.orderedPvalues = parse(hash);
    // calculating adjusted p-values.
    BigDecimal min = new BigDecimal("" + 1);
    BigDecimal mkprk;
    for (int i = m; i > 0; i--) {
      mkprk = (new BigDecimal("" + m).multiply(new BigDecimal(orderedPvalues[i - 1]))).divide(new BigDecimal("" + i), RESULT_SCALE, BigDecimal.ROUND_HALF_UP);
      if (mkprk.compareTo(min) < 0) {
	min = mkprk;
      }
      adjustedPvalues[i - 1] = min.toString();
    }
    correctionMap = new HashMap<String,String>();
    for (int i = 0; i < adjustedPvalues.length && i < orderedGOLabels.length; i++) {
      correctionMap.put(orderedGOLabels[i], adjustedPvalues[i]);
    }
  }
    
  public String[] parse(HashEntry [] data) {
    String[] keys = new String[data.length];
    String[] values = new String[data.length];
    for(int i = 0; i < data.length; i++){
      keys[i] = data[i].key;
      values[i] = data[i].value;
    }
    orderedGOLabels = keys;
    return values;
  }

  /*--------------------------------------------------------------
    GETTERS.
    --------------------------------------------------------------*/

  /**
   * getter for the map of corrected p-values.
   *
   * @return HashMap correctionMap.
   */
  public HashMap<String,String> getCorrectionMap() {
    return correctionMap;
  }

  /**
   * getter for the ordered p-values.
   *
   * @return String[] with the ordered p-values.
   */
  public String[] getOrderedPvalues() {
    return orderedPvalues;
  }

  /**
   * getter for the adjusted p-values.
   *
   * @return String[] with the adjusted p-values.
   */
  public String[] getAdjustedPvalues() {
    return adjustedPvalues;
  }

  /**
   * getter for the ordered GOLabels.
   *
   * @return String[] with the ordered GOLabels.
   */
  public String[] getOrderedGOLabels() {
    return orderedGOLabels;
  }

}
