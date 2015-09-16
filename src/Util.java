package edu.carnegiescience.dpb.bartonlab;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Array;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.TreeSet;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.InitialDirContext;
import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.time.DateUtils;

import org.apache.commons.math3.distribution.NormalDistribution;
import org.apache.commons.math3.stat.StatUtils;

import com.oreilly.servlet.MultipartRequest;

/**
 * Collection of static utility variables and methods for text handling, etc.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2825 $ $Date: 2015-08-20 11:02:47 -0500 (Thu, 20 Aug 2015) $
 */
public class Util {

	/**
	 * Return log(double[])
	 */
	public static double[] log(double[] arg) {
		double[] log = new double[arg.length];
		for (int i=0; i<arg.length; i++) log[i] = Math.log(arg[i]);
		return log;
	}

	/**
	 * Return log2(double)
	 */
	public static double log2(double arg) {
		return Math.log(arg)/Math.log(2.0);
	}
	/**
	 * Return log2(double[])
	 */
	public static double[] log2(double[] arg) {
		double[] log2arg = new double[arg.length];
		double log2 = Math.log(2.0);
		for (int i=0; i<arg.length; i++) log2arg[i] = Math.log(arg[i])/log2;
		return log2arg;
	}

	/**
	 * Return log2(double+1)
	 */
	public static double log21p(double arg) {
		return Math.log1p(arg)/Math.log(2.0);
	}
	/**
	 * Return log2(double[]+1)
	 */
	public static double[] log21p(double[] arg) {
		double[] log21parg = new double[arg.length];
		double log2 = Math.log(2.0);
		for (int i=0; i<arg.length; i++) log21parg[i] = Math.log1p(arg[i])/log2;
		return log21parg;
	}

	/**
	 * Return a background color style given a logFC argument
	 */
	public static String bgFC(double fc) {
		if (fc>2.5) {
			return "p25";
		} else if (fc>2.0) {
			return "p20";
		} else if (fc>1.5) {
			return "p15";
		} else if (fc>1.0) {
			return "p10";
		} else if (fc>0.5) {
			return "p05";
		} else if (fc<-2.5) {
			return "m25";
		} else if (fc<-2.0) {
			return "m20";
		} else if (fc<-1.5) {
			return "m15";
		} else if (fc<-1.0) {
			return "m10";
		} else if (fc<-0.5) {
			return "m05";
		} else {
			return "mid";
		}
	}

	/**
	 * Return a background color style given a correlation argument
	 */
	public static String bgCorrelation(double corr) {
		if (corr>0.95) {
			return "p95corr";
		} else if (corr>0.80) {
			return "p80corr";
		} else if (corr>0.60) {
			return "p60corr";
		} else if (corr>0.40) {
			return "p40corr";
		} else if (corr>0.20) {
			return "p20corr";
		} else if (corr<-0.95) {
			return "m95corr";
		} else if (corr<-0.80) {
			return "m80corr";
		} else if (corr<-0.60) {
			return "m60corr";
		} else if (corr<-0.40) {
			return "m40corr";
		} else if (corr<-0.20) {
			return "m20corr";
		} else {
			return "mid";
		}
	}

	/**
	 * Return a background color style given a differential correlation argument (ranges from -2 to 2)
	 */
	public static String bgDifferentialCorrelation(double corr) {
		if (corr>1.90) {
			return "p95corr";
		} else if (corr>1.60) {
			return "p80corr";
		} else if (corr>1.20) {
			return "p60corr";
		} else if (corr>0.80) {
			return "p40corr";
		} else if (corr>0.40) {
			return "p20corr";
		} else if (corr<-1.90) {
			return "m95corr";
		} else if (corr<-1.60) {
			return "m80corr";
		} else if (corr<-1.20) {
			return "m60corr";
		} else if (corr<-0.80) {
			return "m40corr";
		} else if (corr<-0.40) {
			return "m20corr";
		} else {
			return "mid";
		}
	}

	/**
	 * Return blank if the input string is null, otherwise return the input string.
	 * @param s a string
	 * @return an empty string if s is null, otherwise return s
	 */
	public static String blankIfNull(String s) {
		if (s==null) {
			return "";
		} else {
			return s;
		}
	}

	/**
	 * Return blank string if the input object is null, otherwise return the string version
	 * @param o an object
	 * @return an empty string if o is null, otherwise return o.toString()
	 */
	public static String blankIfNull(Object o) {
		if (o==null) {
			return "";
		} else {
			return o.toString();
		}
	}

	/**
	 * Return blank if the posted variable is null, otherwise return the posted string.
	 * @param request a ServletRequest
	 * @param s a string
	 * @return an empty string if s is null, otherwise return s
	 */
	public static String blankIfNull(ServletRequest request, String s) {
		if (request.getParameter(s)==null) {
			return "";
		} else {
			return request.getParameter(s);
		}
	}

	/**
	 * Return 0 if the input string is null; otherwise return the int value.  Throws NumberFormatException if not a number.
	 * @param s is a String
	 * @return 0 if s is null or doesn't parse to an integer, else the int value of s
	 */
	public static int zeroIfNull(String s) throws NumberFormatException {
		if (s==null) {
			return 0;
		} else {
			int i = Integer.parseInt(s);
			return i;
		}
	}

	/**
	 * Return blank if the input int is zero, otherwise return the input int as a string.
	 * @param i an int
	 * @return an empty string if i is zero, otherwise return i as a string
	 */
	public static String blankIfZero(int i) {
		if (i==0) {
			return "";
		} else {
			return ""+i;
		}
	}

	/**
	 * Return blank if the input double is zero, otherwise return the input int as a string.
	 * @param d a double
	 * @return an empty string if d is zero, otherwise return d as a string
	 */
	public static String blankIfZero(double d) {
		if (d==0.00) {
			return "";
		} else {
			return ""+d;
		}
	}

	/**
	 * Convert a byte to a two-char hex string
	 * @param b a byte
	 * @return a two-character hex string
	 */
	public static String byteToHex(byte b) {
		String hex = Integer.toHexString(b & 0xFF).toUpperCase();
		if (hex.length()==1) hex = "0"+hex;
		return hex;
	}

	/**
	 * Convert a hex string to a byte
	 * @param hex a one- or two-character hex string
	 * @return a byte value
	 */
	public static byte hexToByte(String hex) {
		return (byte)Integer.parseInt(hex,16);
	}

	/**
	 * Escape quotes for use in SQL statements, as well as backslashes
	 */
	public static String escapeQuotes(String str) {
		String fixed = str;
		fixed = fixed.replace("'", "''");
		fixed = fixed.replace("\\", "\\\\");
		return fixed;
	}

	/**
	 * Return NULL in the case of empty or null strings, quoted string otherwise
	 */
	public static String charsOrNull(String str) {
		if (str==null || str.trim().length()==0 || str.trim().equals("null")) {
			return "NULL";
		} else {
			return "'"+escapeQuotes(utfToHtml(str.trim()))+"'";
		}
	}

	/**
	 * Return quoted empty string if empty or null string, quoted string otherwise
	 */
	public static String charsOrEmpty(String str) {
		if (str==null || str.trim().length()==0 || str.trim().equals("null")) {
			return "''";
		} else {
			return "'"+escapeQuotes(utfToHtml(str.trim()))+"'";
		}
	}

	/**
	 * Return NULL in the case of empty char
	 */
	public static String charOrNull(char c) {
		if (c=='\0') {
			return "NULL";
		} else {
			return "'"+c+"'";
		}
	}

	/**
	 * Return a quoted fixed-quotes string or DEFAULT if it's empty or "null".
	 */
	public static String charsOrDefault(String str) {
		if (str==null || str.trim().length()==0 || str.trim().equals("null")) {
			return "DEFAULT";
		} else {
			return "'"+escapeQuotes(utfToHtml(str.trim()))+"'";
		}
	}

	/**
	 * Return a quoted fixed-quotes timestamp string or DEFAULT if it's null
	 */
	public static String charsOrDefault(Timestamp t) {
		if (t==null) {
			return "DEFAULT";
		} else {
			return "'"+t.toString()+"'";
		}
	}

	/**
	 * Return a quoted fixed-quotes timestamp string or NULL if it's null
	 */
	public static String charsOrNull(Timestamp t) {
		if (t==null) {
			return "NULL";
		} else {
			return "'"+t.toString()+"'";
		}
	}

	/**
	 * Return a quoted fixed-quotes date string or NULL if it's null
	 */
	public static String charsOrNull(Date d) {
		if (d==null) {
			return "NULL";
		} else {
			return "'"+d.toString()+"'";
		}
	}

	/**
	 * Return NULL in the case of zero, argument otherwise
	 */
	public static String intOrNull(int i) {
		if (i==0) {
			return "NULL";
		} else {
			return ""+i;
		}
	}

	/**
	 * Return DEFAULT in the case of zero, argument otherwise
	 */
	public static String intOrDefault(int i) {
		if (i==0) {
			return "DEFAULT";
		} else {
			return ""+i;
		}
	}

	/**
	 * Return NULL in the case of zero, argument otherwise
	 */
	public static String longOrNull(long i) {
		if (i==0) {
			return "NULL";
		} else {
			return ""+i;
		}
	}

	/**
	 * Return DEFAULT in the case of zero, argument otherwise
	 */
	public static String longOrDefault(long i) {
		if (i==0) {
			return "DEFAULT";
		} else {
			return ""+i;
		}
	}

	/**
	 * Return NULL in the case of zero, argument otherwise
	 */
	public static String doubleOrNull(double d) {
		if (d==0.00) {
			return "NULL";
		} else {
			return ""+d;
		}
	}

	/**
	 * Return DEFAULT in the case of zero, argument otherwise
	 */
	public static String doubleOrDefault(double d) {
		if (d==0.00) {
			return "DEFAULT";
		} else {
			return ""+d;
		}
	}

	/**
	 * Return true if "true" or "t", false otherwise
	 */
	public static String toBoolean(String str) {
		if (str!=null && (str.equals("true") || str.equals("t"))) {
			return "true";
		} else {
			return "false";
		}
	}

	/**
	 * Return true if string is null or empty (can be just spaces)
	 */
	public static boolean nullOrEmpty(String s) {
		return (s==null || s.trim().length()==0);
	}

	/**
	 * Return +1 if positive, -1 if negative
	 */
	public static int sign(double f) throws IllegalArgumentException {
		if (f == 0) return 0; // comparison with int 0 is probably exact
		f *= Double.POSITIVE_INFINITY;
		if (f == Double.POSITIVE_INFINITY) {
			return +1;
		} else if (f == Double.NEGATIVE_INFINITY) {
			return -1;
		} else {
			throw new IllegalArgumentException("Unfathomed double"); // this should never be reached
		}
	}

	/**
	 * Format a double into a money string for the US.
	 * Easily tweaked to support localization when we get into that.
	 */
	public static String formatMoney(double amount) {
		DecimalFormat money = new DecimalFormat("$###,##0.00");
		return money.format(amount);
	}

	/**
	 * Format a double into a currency string for the US, without the $ sign or comma.
	 * Easily tweaked to support localization when we get into that.
	 */
	public static String formatCents(double amount) {
		DecimalFormat money = new DecimalFormat("#####0.00");
		return money.format(amount);
	}

	/**
	 * Substitute HTML entities for high UTF-8 (Windows ASCII 128-159) characters.
	 * This should be used for text input from HTTP POST.
	 */
	public static String utfToHtml(String utf) {
		if (utf==null) {
			return null;
		} else {
			String html = "";
			for (int i=0; i<utf.length(); i++) {
				int cp1 = utf.codePointAt(i);
				int cp2 = 0;
				int cp3 = 0;
				if (cp1==226) {
					cp2 = utf.codePointAt(++i);
					cp3 = utf.codePointAt(++i);
				}
				// Windows 128-159 replacements
				if (cp3==147) {
					html += "&ndash;";
				} else if (cp3==148) {
					html += "&mdash;";
				} else if (cp3==152) {
					html += "&lsquo;";
				} else if (cp3==153) {
					html += "&rsquo;";
				} else if (cp3==156) {
					html += "&ldquo;";
				} else if (cp3==157) {
					html += "&rdquo;";
				} else {
					html += utf.charAt(i);
				}
			}
			return html;
		}
	}

	/**
	 * Substitute HTML entities for Unicode coming from database tranlation.
	 * This should be used for text output from a LATIN1 database like SQL Server, translated to unicode by the JDBC driver.
	 */
	public static String unicodeToHtml(String unicode) {
		if (unicode==null) {
			return null;
		} else {
			String html = unicode;
			html = html.replaceAll("\u2013", "&ndash;");
			html = html.replaceAll("\u2014", "&mdash;");
			html = html.replaceAll("\u2018", "&lsquo;");
			html = html.replaceAll("\u2019", "&rsquo;");
			html = html.replaceAll("\u201c", "&ldquo;");
			html = html.replaceAll("\u201d", "&rdquo;");
			return html;
		}
	}

	/**
	 * Unescape HTML entities into Unicode.  Used for RSS feed or PDF generators.  NOTE: uses Apache Commons Lang package!
	 */
	public static String unescapeHtml(String input) {
		if (input==null) {
			return null;
		} else {
			return StringEscapeUtils.unescapeHtml4(input);
		}
	}

	/**
	 * Strip out HTML tags.  Needed for legit RSS feeds.
	 */
	public static String stripHtmlTags(String input) {
		if (input==null) {
			return null;
		} else {
			return input.replaceAll("\\<.*?\\>", "");
		}
	}

	/**
	 * Escape all ampersand characters with the HTML equivalent.  This will break HTML escapes, but keeps RSS feeds valid.
	 */
	public static String escapeAmp(String input) {
		if (input==null) {
			return null;
		} else {
			String output = input.replaceAll("&", "&amp;");
			output = output.replaceAll("<", "&lt;");
			output = output.replaceAll(">", "&gt;");
			return output;
		}
	}

	/**
	 * Clean up string for RSS compliance, using the above methods.
	 */
	public static String rssClean(String input) {
		if (input==null) {
			return null;
		} else {
			return Util.escapeAmp(Util.unescapeHtml(Util.stripHtmlTags(input)));
		}
	}

	/**
	 * Form a valid href from the string; if it starts with 'http', leave it alone, otherwise prepend 'http://'.
	 */
	public static String href(String url) {
		if (url==null) return null;
		if (url.toLowerCase().substring(0,4).equals("http")) return url;
		return "http://"+url;
	}

	// --------------------------------------------------------------------------------------------

	/**
	 * Return an empty string if the parameter is null, otherwise the trimmed value of the parameter
	 */
	static String getString(String value) {
		if (value==null) return "";
		return value.trim();
	}    
	public static String getString(HttpServletRequest request, String str) { return getString(request.getParameter(str)); }
	public static String getString(MultipartRequest request, String str) { return getString(request.getParameter(str)); }
	public static String getString(HttpSession session, String str) { return getString((String)session.getAttribute(str)); }

	/**
	 * Parse the given string into an integer, else return 0 if null or not an int
	 */
	static int getInt(String str) {
		if (str==null) return 0;
		try {
			return Integer.parseInt(str);
		} catch (NumberFormatException ex) {
			return 0;
		}
	}
	public static int getInt(HttpServletRequest request, String str) { return getInt(request.getParameter(str)); }
	public static int getInt(MultipartRequest request, String str) { return getInt(request.getParameter(str)); }
	public static int getInt(HttpSession session, String str) { return getInt((String)session.getAttribute(str)); }

	/**
	 * Return the given string as a long, 0 if null or not parseable
	 */
	static long getLong(String str) {
		if (str==null) return 0;
		try {
			return Long.parseLong(str);
		} catch (NumberFormatException ex) {
			return 0;
		}
	}
	public static long getLong(HttpServletRequest request, String str) { return getLong(request.getParameter(str)); }
	public static long getLong(MultipartRequest request, String str) { return getLong(request.getParameter(str)); }
	public static long getLong(HttpSession session, String str) { return getLong((String)session.getAttribute(str)); }

	/**
	 * Parse the given string into an double, else return 0.00 if null or not a double
	 */
	static double getDouble(String str) {
		if (str==null) return 0.00;
		try {
			return Double.parseDouble(str);
		} catch (NumberFormatException ex) {
			return 0.00;
		}
	}
	public static double getDouble(HttpServletRequest request, String str) { return getDouble(request.getParameter(str)); }
	public static double getDouble(MultipartRequest request, String str) { return getDouble(request.getParameter(str)); }
	public static double getDouble(HttpSession session, String str) { return getDouble((String)session.getAttribute(str)); }

	/**
	 * Return the given string as a boolean, false if null or not equal to "true."
	 */
	static boolean getBoolean(String str) {
		if (str==null) return false;
		return str.equals("true");
	}
	public static boolean getBoolean(HttpServletRequest request, String str) { return getBoolean(request.getParameter(str)); }
	public static boolean getBoolean(MultipartRequest request, String str) { return getBoolean(request.getParameter(str)); }
	public static boolean getBoolean(HttpSession session, String str) { return getBoolean((String)session.getAttribute(str)); }

	/**
	 * Return the given string parameter as a Date, null if not present or not a JDBC date string
	 */
	static Date getDate(String str) {
		if (str==null) return null;
		try {
			return Date.valueOf(str);
		} catch (Exception ex) {
			return null;
		}
	}
	public static Date getDate(HttpServletRequest request, String str) { return getDate(request.getParameter(str)); }
	public static Date getDate(MultipartRequest request, String str) { return getDate(request.getParameter(str)); }
	public static Date getDate(HttpSession session, String str) { return getDate((String)session.getAttribute(str)); }

	/**
	 * Return the given string parameter as a Timestamp, null if not present; throw exception if not a parseable string.
	 * Uses Apache DateUtils, which returns a java.util.Date, so then have to convert to java.sql.Timestamp.
	 */
	static Timestamp getTimestamp(String str) throws ParseException {
		if (nullOrEmpty(str)) return null;
		String[] parsePatterns = {"yyyy-MM-dd", "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "dd MMM yyyy HH:mm:ss", "dd MMM yyyy", "M/d/yy"};
		java.util.Date d = DateUtils.parseDate(str, parsePatterns);
		SimpleDateFormat jdbc = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String s = jdbc.format(d);
		return Timestamp.valueOf(s);
	}
	public static Timestamp getTimestamp(HttpServletRequest request, String str) throws ParseException { return getTimestamp(request.getParameter(str)); }
	public static Timestamp getTimestamp(MultipartRequest request, String str) throws ParseException { return getTimestamp(request.getParameter(str)); }
	public static Timestamp getTimestamp(HttpSession session, String str) throws ParseException { return getTimestamp((String)session.getAttribute(str)); }

	/**
	 * Return the given string array as an array of ints; each is 0 if null or not an int
	 */
	static int[] getIntValues(String[] str) throws NumberFormatException {
		if (str==null) return new int[0];
		int[] v = new int[str.length];
		for (int i=0; i<v.length; i++) {
			if (str[i]==null) {
				v[i] = 0;
			} else {
				try {
					v[i] = Integer.parseInt(str[i]);
				} catch (NumberFormatException ex) {
					v[i] = 0;
				}
			}
		}
		return v;
	}
	public static int[] getIntValues(HttpServletRequest request, String str) { return getIntValues(request.getParameterValues(str)); }
	public static int[] getIntValues(MultipartRequest request, String str) { return getIntValues(request.getParameterValues(str)); }

	/**
	 * Return an array of trimmed, values or null strings from the input array of strings
	 */
	static String[] getStringValues(String[] str) {
		if (str==null) return new String[0];
		String[] v = new String[str.length];
		for (int i=0; i<v.length; i++) {
			if (str[i]==null || str[i].length()==0) {
				v[i] = null;
			} else {
				v[i] = str[i].trim();
			}
		}
		return v;
	}    
	public static String[] getStringValues(HttpServletRequest request, String str) { return getStringValues(request.getParameterValues(str)); }
	public static String[] getStringValues(MultipartRequest request, String str) { return getStringValues(request.getParameterValues(str)); }

	/**
	 * Return the given string array as an array of doubles; each is 0.00 if null or not a double
	 */
	static double[] getDoubleValues(String[] str) throws NumberFormatException {
		if (str==null) return new double[0];
		double[] v = new double[str.length];
		for (int i=0; i<v.length; i++) {
			if (str[i]==null) {
				v[i] = 0.00;
			} else {
				try {
					v[i] = Double.parseDouble(str[i]);
				} catch (NumberFormatException ex) {
					v[i] = 0.00;
				}
			}
		}
		return v;
	}
	public static double[] getDoubleValues(HttpServletRequest request, String str) { return getDoubleValues(request.getParameterValues(str)); }
	public static double[] getDoubleValues(MultipartRequest request, String str) { return getDoubleValues(request.getParameterValues(str)); }

	/**
	 * Return the given string array as an array of booleans; default is false, only "true" returns true
	 */
	static boolean[] getBooleanValues(String[] str) {
		if (str==null) return new boolean[0];
		boolean[] v = new boolean[str.length];
		for (int i=0; i<v.length; i++) {
			if (str[i]!=null && str[i].equals("true")) {
				v[i] = true;
			} else {
				v[i] = false;
			}
		}
		return v;
	}
	public static boolean[] getBooleanValues(HttpServletRequest request, String str) { return getBooleanValues(request.getParameterValues(str)); }
	public static boolean[] getBooleanValues(MultipartRequest request, String str) { return getBooleanValues(request.getParameterValues(str)); }


	// --------------------------------------------------------------------------------------------

	/**
	 * Return a string with the first character capitalized, the rest lower case
	 */
	public static String initCap(String s) {
		return (s!=null) ? s.substring(0,1).toUpperCase()+s.substring(1).toLowerCase() : null;
	}

	/**
	 * Generate a random string consisting of lower-case alphanumeric characters with the input length
	 */
	public static String randomString(int length) {
		String charset = "0123456789abcdefghijklmnopqrstuvwxyz";
		Random rand = new Random(System.currentTimeMillis());
		StringBuffer sb = new StringBuffer();
		for (int i=0; i<length; i++) {
			int pos = rand.nextInt(charset.length());
			sb.append(charset.charAt(pos));
		}
		return sb.toString();
	}

	/**
	 * Generate a random string consisting of the given characters and the input length
	 */
	public static String randomString(String charset, int length) {
		Random rand = new Random(System.currentTimeMillis());
		StringBuffer sb = new StringBuffer();
		for (int i=0; i<length; i++) {
			int pos = rand.nextInt(charset.length());
			sb.append(charset.charAt(pos));
		}
		return sb.toString();
	}

	/**
	 * Return true if input string is alphanumeric [a-z],[A-Z],[0-9] and not null
	 */
	public static boolean isAlphanumeric(String s) {
		if (s==null) return false;
		char[] chars = s.toCharArray();
		for (int i=0; i<chars.length; i++) {
			if (!Character.isLetterOrDigit(chars[i])) return false;
		}
		return true;
	}

	/**
	 * Return true if input string is alphanumeric [a-z],[A-Z],[0-9] or dash and not null
	 */
	public static boolean isAlphanumericOrDash(String s) {
		if (s==null) return false;
		char[] chars = s.toCharArray();
		for (int i=0; i<chars.length; i++) {
			if (!Character.isLetterOrDigit(chars[i]) && chars[i]!='-') return false;
		}
		return true;
	}

	/**
	 * Return true if input string is all upper case (and not null)
	 */
	public static boolean isUpperCase(String s) {
		if (s==null) return false;
		return s.equals(s.toUpperCase());
	}

	/**
	 * Replace line breaks with br tags
	 */
	public static String replaceLineBreaks(String s) {
		String fixed = s;
		fixed = fixed.replaceAll("\r","");
		fixed = fixed.replaceAll("<br/>\n","\n"); // prevent duplicating existing <br/> tags
		fixed = fixed.replaceAll("\n","<br/>\n");
		fixed = fixed.replaceAll("><br/>\n",">\n"); // leave ending tags alone
		return fixed;
	}

	/** 
	 * Retrieve an array of double values from a database double array using the SQL Array object
	 */
	public static double[] getDoubles(ResultSet rs, String s) throws SQLException {
		Array a = rs.getArray(s);
		Double[] d = (Double[]) a.getArray();
		double[] values = new double[d.length];
		for (int i=0; i<d.length; i++) values[i] = (double) d[i];
		return values;
	}

	/** 
	 * Retrieve an array of String values from a database varchar array using the SQL Array object
	 */
	public static String[] getStrings(ResultSet rs, String s) throws SQLException {
		Array a = rs.getArray(s);
		String[] values = (String[]) a.getArray();
		return values;
	}

	/**
	 * Return the mean value
	 */
	public static double mean(double[] values) {
		double sum = 0.0;
		for (int i=0; i<values.length; i++) sum += values[i];
		return sum/values.length;
	}

	/**
	 * Return the mean value excluding zero values
	 */
	public static double meanExcludingZeros(double[] values) {
		double sum = 0.0;
		int n = 0;
		for (int i=0; i<values.length; i++) {
			if (values[i]>0) sum += values[i];
			n++;
		}
		return sum/n;
	}

	/**
	 * Return the standard deviation excluding zero values
	 */
	public static double sdExcludingZeros(double[] values) {
		double sum = 0.0;
		double mean = meanExcludingZeros(values);
		int n = 0;
		for (int i=0; i<values.length; i++) {
			if (values[i]>0) sum += (values[i]-mean)*(values[i]-mean);
			n++;
		}
		if (n>1) {
			return Math.sqrt(sum/(n-1));
		} else {
			return 0.0;
		}
	}

	/**
	 * Return the mean of the log2 values; automatically excludes zeros since can't take the log
	 */
	public static double meanLog(double[] values) {
		double sum = 0.0;
		int n = 0;
		for (int i=0; i<values.length; i++) {
			if (values[i]>0) sum += log2(values[i]);
			n++;
		}
		return sum/n;
	}

	/**
	 * Return the standard deviation of the log2 values; automatically excludes zeros
	 */
	public static double sdLog(double[] values) {
		double sum = 0.0;
		double mean = meanLog(values);
		int n = 0;
		for (int i=0; i<values.length; i++) {
			if (values[i]>0) sum += (log2(values[i])-mean)*(log2(values[i])-mean);
			n++;
		}
		if (n>1) {
			return Math.sqrt(sum/(n-1));
		} else {
			return 0.0;
		}
	}

	/**
	 * Return the minimum value of an array of doubles
	 */
	public static double min(double[] values) {
		double min = Double.MAX_VALUE;
		for (double value : values) {
			if (value < min) min = value;
		}
		return min;
	}

	/**
	 * Return the maximum value of an array of doubles
	 */
	public static double max(double[] values) {
		double max = Double.MIN_VALUE;
		for (double value : values) {
			if (value > max) max = value;
		}
		return max;
	}

	/**
	 * Return the Benjamini-Hochberg-adjusted (for FDR) q values given an input array of raw p values
	 * Makes a copy of the input p array for sorting
	 */
	public static double[] bhAdjust(double[] p) {
		// sort the p-value array
		Map<Integer,Double> map = new HashMap<Integer,Double>();
		for (int i=0; i<p.length; i++) map.put(i, p[i]);
		map = sortByValue(map);
		// scan through them, assigning adjusted p-value=q with original unsorted index
		double[] q = new double[p.length];
		int m = p.length; // maximum rank
		int k = 0; // current rank
		for (Map.Entry<Integer,Double> outer : map.entrySet()) {
			k++; // starts with 1
			int i = (int) outer.getKey(); // original index
			q[i] = 1.0;
			// iterate from current rank up THIS IS REALLY INEFFICIENT
			int kk = 0;
			for (Map.Entry<Integer,Double> inner : map.entrySet()) {
				kk++;
				if (kk>=k) {
					double pkk = (double) inner.getValue();
					double qkk = Math.min(1.0, pkk*m/k);
					q[i] = Math.min(q[i], qkk);
				}
			}
		}
		return(q);
	}

	/**
	 * Sort a map by value, not key
	 */
	public static <K, V extends Comparable<? super V>> Map<K, V> sortByValue( Map<K, V> map ) {
		List<Map.Entry<K, V>> list = new LinkedList<Map.Entry<K, V>>( map.entrySet() );
		Collections.sort( list, new Comparator<Map.Entry<K, V>>() {
				public int compare( Map.Entry<K, V> o1, Map.Entry<K, V> o2 ) {
					return (o1.getValue()).compareTo( o2.getValue() );
				}
			}
			);
		Map<K, V> result = new LinkedHashMap<K, V>();
		for (Map.Entry<K, V> entry : list) {
			result.put( entry.getKey(), entry.getValue() );
		}
		return result;
	}

	/**
	 * Return the p-value corresponding to the given Pearson's correlation coefficient and sample size
	 */
	public static double pPearson(double corr, double num) {
		double F = 0.5*Math.log((1+corr)/(1-corr)); // Fisher transformation
		double z = F*Math.sqrt(num-3); // standard score
		NormalDistribution dist = new NormalDistribution(); // mean=0, sd=1
		return 2*dist.cumulativeProbability(-Math.abs(z));
	}

	/**
	 * Returns a numerical score representing the alignment of the two input line scores. bothDirections=true scores for a U-D match, false ignores it.
	 */
	public static int score(boolean bothDirections, String line1, String line2) {
		if (line1.length()!=line2.length()) return 0;
		int n = line1.length();
		int matchScore = 0;
		int countN = 0;
		for (int i=0; i<n; i++) {
			char c1 = line1.charAt(i);
			char c2 = line2.charAt(i);
			if (c1=='N' && c2=='N') {
				countN++;
			} else if ((c1=='U' && c2=='U') || (c1=='D' && c2=='D')) {
				matchScore++;
			} else if (bothDirections && (c1=='U' && c2=='D') || (c1=='D' && c2=='U')) {
				matchScore--;
			}
		}
		return Math.abs(matchScore) + countN;
	}

}
