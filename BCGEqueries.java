/**
 * Java database connectivity example
 * feBueno April - 2020
 */

package mJDBCp;
import static net.mindview.util.Print.print;
import java.sql.*;

public class BCGEqueries {
	public static void main(String[] args) throws Exception {
		String url = "jdbc:mysql://localhost:3306/BreastCancerGeneExpression";
		/**
		 * Assuming that the BreastCancerGeneExpression was previously created in localhost with mysql
		 * in MySQL: CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
		 * GRANT ALL PRIVILEGES ON BreastCancerGeneExpression.* TO 'newuser'@'localhost';
		 */
		String uname = "newuser";
		String pw = "password";
		
		//fetch data
		String mquery = "SELECT * FROM PCR_laboratory";
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url,uname,pw);
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(mquery);
		
		String labData;
		while(rs.next()) {//.next: pointer to first row
			labData = rs.getString("PCR_lab") + " : " + rs.getInt("genesNumber");
			System.out.print(labData);
			System.out.print(" ");
		}
		
		//insert data
		System.out.println();
		String mquery2 = "INSERT INTO publications VALUES(61, 'Bueno et al., 2020', 103)";
		int n_affectedRows = st.executeUpdate(mquery2);
		System.out.print(n_affectedRows + " rows affected");

		//insert data 2nd example: prepareStatement
		System.out.println();
		String mquery3 = "INSERT INTO publications VALUES(?,?,?)";
		PreparedStatement st2 = con.prepareStatement(mquery3);
		st2.setInt(1,81);
		st2.setString(2,"Gonzalez et al., 2020");
		st2.setInt(3,101);
		int n_affectedRows2 = st2.executeUpdate();
		System.out.print(n_affectedRows2 + " rows affected in the 2nd example");
		
		
		st.close();
		con.close();
	}
}
