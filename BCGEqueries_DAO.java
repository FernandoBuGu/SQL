/**
 * Java database connectivity example with Data Access Object (DAO)
 * feBueno April - 2020
 * 
 * Requirements: 
 * BreastCancerGeneExpression was previously created in localhost with mysql
 * in MySQL: CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
 * GRANT ALL PRIVILEGES ON BreastCancerGeneExpression.* TO 'newuser'@'localhost';
 */
package mJDBCp;

import static net.mindview.util.Print.*;
import java.sql.*;

public class BCGEqueries_DAO {
	
	public static void main(String[] args) {
		publications_DAO pubDAO = new publications_DAO();
		
		//get authors given publicationID
		pubDAO.connect();
		publications pub1 = pubDAO.get_publications(40);
		print(pub1.authors);
		
		//add new publication
		publications pub_ref = new publications();
		pub_ref.paper_index=77;
		pub_ref.authors="Lopez et al., 2020";
		pub_ref.methodID=103;
		pubDAO.connect();
		pubDAO.add_publications(pub_ref);	
		
	}
}



class publications_DAO{
	Connection con=null;

	public void connect() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BreastCancerGeneExpression","newuser","password");
		} catch (Exception e){
			print(e);
		}
	}
	
	public publications get_publications(int paper_index) {
		try {
			String mquery = "SELECT authors FROM publications WHERE paper_index="+paper_index;
			publications pb = new publications();
			pb.paper_index = paper_index;
			
			//fetch info for the other fields using JDBC 
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery(mquery);
			rs.next();
			String pub_authors = rs.getString("authors");
			pb.authors = pub_authors;
			return pb;

			
		} catch (Exception e){
			print(e);
		}	
		return null;
	}
	
	public void add_publications(publications publications_in) {
		try {
			String query = "INSERT INTO publications VALUES (?,?,?)";
			PreparedStatement st2 = con.prepareStatement(query);
			st2.setInt(1,publications_in.paper_index);
			st2.setString(2,publications_in.authors);
			st2.setInt(3,publications_in.methodID);
			st2.executeUpdate();
			print(publications_in.authors+" was added");
		} catch (Exception e){
			print(e);
		}
	}
}


class publications{
	  int paper_index;
	  String authors;
	  int methodID;
}