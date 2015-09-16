/**
 * Encodes an RSEM.isoforms.results record
 */

public class RSEMResult implements Comparable {

  public String transcriptId;
  public String geneId;
  public int length;
  public double effectiveLength;
  public double expectedCount;
  public double TPM;
  public double FPKM;
  public double isoPct;

  /**
   * Instantiate given a line from the file
   */
  public RSEMResult(String line) {
    String[] chunks = line.split("\t");
    transcriptId = chunks[0];
    geneId = chunks[1];
    length = Integer.parseInt(chunks[2]);
    effectiveLength = Double.parseDouble(chunks[3]);
    expectedCount = Double.parseDouble(chunks[4]);
    TPM = Double.parseDouble(chunks[5]);
    FPKM = Double.parseDouble(chunks[6]);
    isoPct = Double.parseDouble(chunks[7]);
  }

  /**
   * Comparator is used to enforce unique entries in a Set
   */
  public int compareTo(Object o) {
    RSEMResult that = (RSEMResult)o;
    return this.transcriptId.compareTo(that.transcriptId);
  }

  /**
   * Equal if both query and target are equal
   */
  public boolean equals(Object o) {
    RSEMResult that = (RSEMResult)o;
    return this.transcriptId.equals(that.transcriptId);
  }

  /**
   * Return a tabbed line containing all instance values
   */
  public String getTabbedLine() {
    return transcriptId+'\t'+geneId+'\t'+length+'\t'+effectiveLength+'\t'+expectedCount+'\t'+TPM+'\t'+FPKM+'\t'+isoPct;
  }


}
