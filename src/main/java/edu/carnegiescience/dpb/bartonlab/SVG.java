package edu.carnegiescience.dpb.bartonlab;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;

import java.util.Date;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.JFreeChart;

import org.apache.batik.dom.GenericDOMImplementation;
import org.apache.batik.svggen.SVGGraphics2D;
import org.apache.batik.svggen.SVGGraphics2DIOException;

import org.w3c.dom.Document;
import org.w3c.dom.DOMImplementation;

/**
 * Static methods for converting JFreeChart to SVG graphics using Batik libraries.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2320 $ $Date: 2013-11-20 19:54:45 -0600 (Wed, 20 Nov 2013) $
 */
public class SVG {

  /**
   * Output chart to SVG file in temp directory
   * Returns file name
   */
  public static String chartToSVG(JFreeChart chart, int width, int height) throws FileNotFoundException, UnsupportedEncodingException, SVGGraphics2DIOException, IOException {

    // get a DOMImplementation and create an XML document
    DOMImplementation domImpl = GenericDOMImplementation.getDOMImplementation();
    Document document = domImpl.createDocument(null, "svg", null);

    // create an instance of the SVG Generator
    SVGGraphics2D svgGenerator = new SVGGraphics2D(document);

    // draw the chart in the SVG generator
    java.awt.Rectangle bounds = new java.awt.Rectangle(0,0,width,height);
    chart.draw(svgGenerator, bounds);

    // write svg file to temp directory
    File svgFile = File.createTempFile("bartonlab-",".svg");
    OutputStream out = new FileOutputStream(svgFile);
    Writer osw = new OutputStreamWriter(out, "UTF-8");
    svgGenerator.stream(osw, true);   // true = use css
    out.flush();
    out.close();

    // close the SVG generator
    svgGenerator.dispose();

    return svgFile.getName();
    
  }

  /**
   * Output chart to SVG file in HTTP download stream
   */
  public static void downloadSVG(JFreeChart chart, int width, int height, HttpServletResponse response) throws FileNotFoundException, UnsupportedEncodingException, SVGGraphics2DIOException, IOException {

    // get a DOMImplementation and create an XML document
    DOMImplementation domImpl = GenericDOMImplementation.getDOMImplementation();
    Document document = domImpl.createDocument(null, "svg", null);

    // create an instance of the SVG Generator
    SVGGraphics2D svgGenerator = new SVGGraphics2D(document);

    // draw the chart in the SVG generator
    java.awt.Rectangle bounds = new java.awt.Rectangle(0,0,width,height);
    chart.draw(svgGenerator, bounds);

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd-HHmmss");
    String filename = "bartonlab-"+dateFormat.format(new Date())+".svg";

    // set response headers
    response.setContentType("image/svg+xml; charset=UTF-8");
    response.addHeader("Content-Disposition","attachment; filename="+filename);

    // send the text data
    PrintWriter writer = response.getWriter();
    svgGenerator.stream(writer, true);   // true = use css
    writer.flush();
    writer.close();

    // close the SVG generator
    svgGenerator.dispose();

  }
  
}
