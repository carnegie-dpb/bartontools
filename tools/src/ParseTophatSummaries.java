import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;

import java.util.Arrays;
import java.util.Set;
import java.util.TreeSet;

public class ParseTophatSummaries {

    public static void main(String[] args) {

        if (args.length!=1) {
            System.out.println("Usage: ParseTophatSummaries <directory>");
            System.exit(1);
        }

        String dirName = args[0];
        File dir = new File(dirName);
        if (!dir.isDirectory()) {
            System.err.println("Error: "+dir.getName()+" is not a directory.");
            System.exit(1);
        }

        Set<File> files = new TreeSet<File>(Arrays.asList(dir.listFiles()));
        if (files.size()==0) {
            System.err.println("Error: "+dir.getName()+" has no files.");
            System.exit(1);
        }

        // header
        System.out.println("Sample\tL input\tL mapped\tL multiple\tR input\tR mapped\tR multiple\tAln. pairs\tAln. multiple\tAln. discordant");
        for (File file : files) {
            if (file.getName().contains("align_summary.txt")) {
                String[] fileParts = file.getName().split("\\.");
                System.out.print(fileParts[0]);
                try {
                    BufferedReader reader = new BufferedReader(new FileReader(file));
                    String line = null;
                    while ((line=reader.readLine())!=null) {
                        // Left reads:
                        //           Input     :  20890002
                        //            Mapped   :  14203839 (68.0% of input)
                        //             of these:   1568809 (11.0%) have multiple alignments (124 have >20)
                        // Right reads:
                        //           Input     :  20890002
                        //            Mapped   :  14091881 (67.5% of input)
                        //             of these:   1467643 (10.4%) have multiple alignments (125 have >20)
                        // 67.7% overall read mapping rate.
                        
                        // Aligned pairs:  10186355
                        //      of these:   1061464 (10.4%) have multiple alignments
                        //                    80047 ( 0.8%) are discordant alignments
                        // 48.4% concordant pair alignment rate.
                        String[] parts = line.split(":");
                        if (parts.length==2) {
                            String[] pieces = parts[1].trim().split(" ");
                            System.out.print("\t"+pieces[0].trim());
                        }
                    }
                    System.out.println("");
                } catch (Exception ex) {
                    System.err.println(ex.toString());
                }
            }
        }
        
    }


}
