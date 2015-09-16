/**
 * Encapsulates a single PSL file record, using arrays to store the blocks.
 */

public class PSLRecord {

    int matches;
    int misMatches;
    int repMatches;
    int nCount;
    int qNumInsert;
    int qBaseInsert;
    int tNumInsert;
    int tBaseInsert;
    char strand;
    String qName;
    int qSize;
    int qStart;
    int qEnd;
    String tName;
    int tSize;
    int tStart;
    int tEnd;
    int blockCount;
    int[] blockSizes;
    int[] qStarts;
    int[] tStarts;

    /** Instantiate from a PSL file line */
    public PSLRecord(String line) {
	String[] chunks = line.split("\t");
	if (chunks.length==21) {
	    try {
		matches = Integer.parseInt(chunks[0]);
		misMatches = Integer.parseInt(chunks[1]);
		repMatches = Integer.parseInt(chunks[2]);
		nCount = Integer.parseInt(chunks[3]);
		qNumInsert = Integer.parseInt(chunks[4]);
		qBaseInsert = Integer.parseInt(chunks[5]);
		tNumInsert = Integer.parseInt(chunks[6]);
		tBaseInsert = Integer.parseInt(chunks[7]);
		strand = chunks[8].charAt(0);
		qName = chunks[9];
		qSize = Integer.parseInt(chunks[10]);
		qStart = Integer.parseInt(chunks[11]);
		qEnd = Integer.parseInt(chunks[12]);
		tName = chunks[13];
		tSize = Integer.parseInt(chunks[14]);
		tStart = Integer.parseInt(chunks[15]);
		tEnd = Integer.parseInt(chunks[16]);
		blockCount = Integer.parseInt(chunks[17]);
		// parse the blocks into the arrays
		String blockSizesStr = chunks[18];
		String qStartsStr = chunks[19];
		String tStartsStr = chunks[20];
		String[] blockSizeChunks = blockSizesStr.split(",");
		String[] qStartChunks = qStartsStr.split(",");
		String[] tStartChunks = tStartsStr.split(",");
		blockSizes = new int[blockCount];
		qStarts = new int[blockCount];
		tStarts = new int[blockCount];
		for (int i=0; i<blockCount; i++) {
		    blockSizes[i] = Integer.parseInt(blockSizeChunks[i]);
		    qStarts[i] = Integer.parseInt(qStartChunks[i]);
		    tStarts[i] = Integer.parseInt(tStartChunks[i]);
		}
	    } catch (Exception ex) {
		// do nothing, probably a heading
	    }
	}
    }

}
