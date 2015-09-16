package edu.carnegiescience.dpb.bartonlab;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

import javax.mail.Session;
import javax.mail.Message.RecipientType;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.SimpleEmail;
import org.apache.commons.validator.routines.EmailValidator;

import org.passay.CharacterRule;
import org.passay.LengthRule;
import org.passay.WhitespaceRule;
import org.passay.AlphabeticalCharacterRule;
import org.passay.DigitCharacterRule;
import org.passay.PasswordData;
import org.passay.PasswordGenerator;
import org.passay.PasswordValidator;
import org.passay.Rule;
import org.passay.RuleResult;

/**
 * Encapsulates a site user.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2357 $ $Date: 2013-12-10 09:58:32 -0600 (Tue, 10 Dec 2013) $
 */
public class User implements Comparable {

	/** users table fields - all private to enhance security */
	private int id;
	private String email;
	private String password;
	private String confirmationkey;

	/**
	 * Construct a default user instance with 0 or null field values
	 */
	public User() {
	}
	
	/**
	 * Construct with db connection and id
	 */
	User(DB db, int id) throws SQLException {
		select(db, id);
	}

	/**
	 * Construct with servlet context and id
	 */
	public User(ServletContext context, int id) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, id);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Construct with email and password
	 */
	public User(ServletContext context, String email, String password) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, email, password);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Construct given a populated ResultSet.
	 */
	User(ResultSet rs) throws SQLException {
		populate(rs);
	}

	/**
	 * Do a SELECT query and set instance variables given a DB connection and user id
	 */
	protected void select(DB db, int id) throws SQLException {
		db.executeQuery("SELECT * FROM users WHERE id="+id);
		if (db.rs.next()) populate(db.rs);
	}

	/**
	 * Do a SELECT query and set instance variables given a DB connection and user email/password
	 */
	protected void select(DB db, String email, String password) throws SQLException {
		db.executeQuery("SELECT * FROM users WHERE email='"+email+"' AND password='"+password+"'");
		if (db.rs.next()) populate(db.rs);
	}

	/**
	 * Populate this instance from a populated ResultSet
	 */
	protected void populate(ResultSet rs) throws SQLException {
		id = rs.getInt("id");
		email = rs.getString("email");
		password = rs.getString("password");
		confirmationkey = rs.getString("confirmationkey");
	}

	/**
	 * Users are equal if they have the same id
	 */
	public boolean equals(Object o) {
		User that = (User) o;
		return this.id==that.id;
	}

	/**
	 * Order alphabetically by email address
	 */
	public int compareTo(Object o) {
		User that = (User) o;
		return this.email.compareTo(that.email);
	}

	/**
	 * return true if this is the default (public) user
	 */
	public boolean isDefault() {
		return id==0;
	}

	/**
	 * return true if this user is confirmed, i.e. confirmation key is null
	 */
	public boolean isConfirmed() {
		return confirmationkey==null;
	}

	/**
	 * Getters
	 */
	public int getId() {
		return id;
	}
	public String getEmail() {
		return email;
	}

	
	/**
	 * Get an array of ALL users, ordered by User comparator
	 */
	public static User[] getAll(DB db) throws SQLException {
		TreeSet<User> set = new TreeSet<User>();
		db.executeQuery("SELECT * FROM users");
		while (db.rs.next()) set.add(new User(db.rs));
		return set.toArray(new User[0]);
	}
	/**
	 * Get an array of ALL users, ordered by User comparator
	 */
	public static User[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getAll(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user may view the given experiment
	 */
	public boolean mayView(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT * FROM users_experiments WHERE user_id="+id+" AND schema='"+experiment.schema+"'");
			return db.rs.next();
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user may administer the given experiment
	 */
	public boolean mayAdminister(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT * FROM users_experiments WHERE user_id="+id+" AND schema='"+experiment.schema+"'");
			return db.rs.next() && db.rs.getBoolean("admin");
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Allow user to view the given experiment
	 */
	public void grantView(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeUpdate("INSERT INTO users_experiments (user_id,schema) VALUES ("+id+",'"+experiment.schema+"')");
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Dialllow user from viewing the given experiment
	 */
	public void revokeView(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeUpdate("DELETE FROM users_experiments WHERE user_id="+id+" AND schema='"+experiment.schema+"'");
		} finally {
			if (db!=null) db.close();
		}
	}


	/**
	 * Return an array of all gene tags for this user, alphabetically sorted
	 */
	public String[] getTags(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			ArrayList<String> list = new ArrayList<String>();
			db.executeQuery("SELECT DISTINCT tag FROM genetags WHERE user_id="+id+" ORDER BY tag");
			while (db.rs.next()) list.add(db.rs.getString("tag"));
			return list.toArray(new String[0]);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of tags for the given gene for this user, alphabetically sorted
	 */
	public String[] getTags(ServletContext context, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			ArrayList<String> list = new ArrayList<String>();
			db.executeQuery("SELECT DISTINCT tag FROM genetags WHERE user_id="+id+" AND id='"+gene.id+"' ORDER BY tag");
			while (db.rs.next()) list.add(db.rs.getString("tag"));
			return list.toArray(new String[0]);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Combine the genes from two or more existing tags. combineAction is UNION or INTERSECT. Returns the new tag.
	 */
	// public String combineTags(ServletContext context, String combineAction, String[] chosenTags) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	// 	DB db = null;
	// 	try {
	// 		db = new DB(context);
	// 		// get the list of genes
	// 		String query = "SELECT id FROM genetags WHERE tag='"+chosenTags[0]+"'";
	// 		for (int i=1; i<chosenTags.length; i++) query += " "+combineAction+" SELECT id FROM genetags WHERE tag='"+chosenTags[i]+"'";
	// 		query += " ORDER BY id";
	// 		db.executeQuery(query);
	// 		TreeSet<String> list = new TreeSet<String>();
	// 		while (db.rs.next()) list.add(db.rs.getString("id"));
	// 		String[] ids = list.toArray(new String[0]);
	// 		// form the new combined tag name
	// 		String newTag = chosenTags[0];
	// 		char s = combineAction.charAt(0);
	// 		for (int i=1; i<chosenTags.length; i++) newTag += "-"+s+"-"+chosenTags[i];
	// 		// insert the ids for the new tag
	// 		for (int i=0; i<ids.length; i++) db.executeUpdate("INSERT INTO genetags (id,tag) VALUES ('"+ids[i]+"','"+newTag+"')");
	// 		// return the new tag
	// 		return newTag;
	// 	} finally {
	// 		if (db!=null) db.close();
	// 	}
	// }

	/**
	 * Set this user's tags for the given gene (deleting all beforehand)
	 */
	public void setTags(ServletContext context, Gene gene, String[] tags) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeUpdate("DELETE FROM genetags WHERE user_id="+id+" AND id='"+gene.id+"'");
			for (int i=0; i<tags.length; i++) {
				db.executeUpdate("INSERT INTO genetags (user_id,id,tag) VALUES ("+id+",'"+gene.id+"','"+tags[i]+"')");
			}
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Add a tag to the given gene for this user, using exception to deal with unique constraint
	 */
	public void addTag(ServletContext context, Gene gene, String tag) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeUpdate("INSERT INTO genetags (user_id,id,tag) VALUES ("+id+",'"+gene.id+"','"+tag+"')");
		} catch (SQLException ex) {
			if (ex.getMessage().contains("duplicate key value")) {
				// do nothing
			} else {
				throw new SQLException(ex);
			}
		} finally {
			if (db!=null) db.close();
		}
	}
	
	/**
	 * Remove a tag from the given gene for this user
	 */
	public void removeTag(ServletContext context, Gene gene, String tag) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeUpdate("DELETE FROM genetags WHERE user_id="+id+" AND id='"+gene.id+"' AND tag='"+tag+"'");
		} finally {
			if (db!=null) db.close();
		}
	}
	
	/**
	 * Delete a tag completely for this user
	 */
	public void deleteTag(ServletContext context, String tag) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeUpdate("DELETE FROM genetags WHERE user_id="+id+" AND tag='"+tag+"'");
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if the supplied email exists in the users table
	 */
	static boolean emailExists(DB db, String email) throws SQLException {
		db.executeQuery("SELECT * FROM users WHERE email='"+email.toLowerCase()+"'");
		return db.rs.next();
	}

	/**
	 * Return true if the given string is deemed to be a strong password
	 */
	public static boolean isStrongPassword(String password) {
		List<Rule> rules = Arrays.asList(
										 // password must be between 6 and 128 chars long
										 new LengthRule(6, 128),
										 // don't allow whitespace
										 new WhitespaceRule(),
										 // require at least 1 digit in passwords
										 new DigitCharacterRule(1),
										 // require at least 1 character
										 new AlphabeticalCharacterRule(1)
										 );
		PasswordValidator validator = new PasswordValidator(rules);
		RuleResult result = validator.validate(new PasswordData(password));
		return result.isValid();
	}

	/**
	 * Determine whether the provided email is deemed to be valid.
	 */
	public static boolean isValidEmail(String email) {
		EmailValidator ev = EmailValidator.getInstance();
		return ev.isValid(email);
	}

	/**
	 * Insert a new user into the users table along with a confirmation key, which will be nulled when the user confirms with a URL containing that key.
	 */
	public static void sendConfirmation(HttpServletRequest request,	String addy, String password) throws Exception {
		ServletContext context = request.getSession().getServletContext();
		DB db = null;
		try {
			db = new DB(context);
			// make sure user doesn't already exist
			if (emailExists(db, addy)) {
				throw new Exception("The email you have provided is already registered. You may reset your password on the login screen.");
			}
			// make sure password is strong enough
			if (!isStrongPassword(password)) {
				throw new Exception("The password you provided is not strong enough. Passwords must: (1) contain at least 6 characters; (2) contain at least one digit; (3) contain at least one letter.");
			}
			// make sure email is valid
			if (!isValidEmail(addy)) {
				throw new Exception("The email you provided is invalid.");
			}
			// use the password generator to create a 24-character confirmation key
			List<CharacterRule> rules = Arrays.asList(
													  (CharacterRule) new AlphabeticalCharacterRule(12),  // at least eight alpha characters
													  (CharacterRule) new DigitCharacterRule(12)         // at least eight digit characters
													  );
			PasswordGenerator generator = new PasswordGenerator();
			String confirmationKey = generator.generatePassword(32, rules);
			// insert a new unconfirmed user record using lower-case email
			db.executeUpdate("INSERT INTO users (email,password,confirmationkey) VALUES ('"+addy.toLowerCase()+"','"+password+"','"+confirmationKey+"')");

			// use Apache Commons Email to send confirmation email with keyed URL
			Email email = new SimpleEmail();
			email.setDebug(true);
			email.setSSLOnConnect(true);
			email.setHostName(context.getInitParameter("mail.smtp.host"));
			email.setSmtpPort(Integer.parseInt(context.getInitParameter("mail.smtp.port")));
			email.setSslSmtpPort(context.getInitParameter("mail.smtp.port"));
			email.setAuthentication(context.getInitParameter("mail.smtp.user"), context.getInitParameter("mail.smtp.password"));
			email.setFrom(context.getInitParameter("mail.smtp.user"));
			email.setSubject("Activate your account registration on Barton Lab Web Tools");
			email.setMsg("Please activate your account registration on Barton Lab Web Tools by clicking the URL below.\n\n"+
						 "http://"+request.getLocalName()+"/register.jsp?confirmationKey="+confirmationKey);
			email.addTo(addy);
			email.send();

		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Confirm the account of a new user.
	 */
	public static void confirmAccount(ServletContext context, String confirmationKey) throws Exception {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT * FROM users WHERE confirmationkey='"+confirmationKey+"'");
			if (db.rs.next()) {
				int id = db.rs.getInt("id");
				db.executeUpdate("UPDATE users SET confirmationkey=null WHERE id="+id);
			} else {
				throw new Exception("The supplied confirmation key does not exist in the database. No account has been activated.");
			}
		} finally {
			if (db!=null) db.close();
		}
	}

}
