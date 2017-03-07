import edu.carnegiescience.dpb.bartonlab.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;
import org.apache.commons.math3.stat.correlation.SpearmansCorrelation;

/**
 * Run through all of the genes for a set of input conditions, dumping out pairs that have Pearson's correlation greater than the input minimum.
 *
 * @author Sam Hokin
 */
public class CorrelationMiner {

    static double MIN_VALUE = 0.1;
    static double Z_MIN = 1.0;

    public static void main(String[] args) {

        if (args.length<3) {
            System.err.println("Usage: CorrelationMiner schema rMin condition1 condition2 condition3 condition4 condition5 ...");
            return;
        }

        String schema = args[0];
        double rMin = Double.parseDouble(args[1]);
        String[] conditions = new String[args.length-2];
        for (int i=0; i<conditions.length; i++) conditions[i] = args[i+2];

        DB db = null;

        try {

            // we'll use one connection throughout
            db = new DB();
            db.setSearchPath(schema);

            // get all samples
            Sample[] samples = Sample.getAll(db);

            // expression for all genes, manually set samples
            Expression[] expr = Expression.getAll(db);

            PearsonsCorrelation pCorr = new PearsonsCorrelation();
            SpearmansCorrelation sCorr = new SpearmansCorrelation();

            // scan over primary gene
            for (int i=0; i<expr.length; i++) {
                Gene gene1 = expr[i].gene;
                double[] values1 = expr[i].getValues(conditions);
                double min1 = expr[i].getMinValue(conditions);
                double mean1 = expr[i].getMeanValue(conditions);
                double sd1 = expr[i].getStandardDeviation(conditions);
                double z1 = sd1/mean1;
                // see if we've got significant variation over at least one condition
                boolean varies = false;
                for (int k=0; k<conditions.length; k++) {
                    double mean = expr[i].getMeanValue(conditions[k]);
                    double sd = expr[i].getStandardDeviation(conditions[k]);
                    if (sd/mean>Z_MIN) varies = true;
                }
                if (min1>MIN_VALUE && varies) {
                    // scan over secondary gene
                    for (int j=i+1; j<expr.length; j++) {
                        Gene gene2 = expr[j].gene;
                        double[] values2 = expr[j].getValues(conditions);
                        double min2 = expr[j].getMinValue(conditions);
                        double mean2 = expr[j].getMeanValue(conditions);
                        double sd2 = expr[j].getStandardDeviation(conditions); 
                        double z2 = sd2/mean2;
                        if (min2>MIN_VALUE) {
                            // run correlations
                            double pcorr = pCorr.correlation(transform(values1), transform(values2));
                            if (Math.abs(pcorr)>=rMin) {
                                System.out.println(gene1.id+"\t"+Gene.getNameForID(db,gene1.id)+"\t"+gene2.id+"\t"+Gene.getNameForID(db,gene2.id)+"\t"+pcorr);
                            }
                        }
                    }
                }
            }

            // done with db
            db.close();
            
        } catch (Exception ex) {

            System.out.println(ex.toString());

        }

    }

    /**
     * Transform values, e.g. taking log2, so the transform is in one place for use throughout.
     */
    static double[] transform(double[] values) {
        // return Util.log2(values);
        return values;
    }
    
}
