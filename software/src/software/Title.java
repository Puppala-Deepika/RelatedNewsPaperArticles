package software;

import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class Title {

    public static void main(String[] args) throws FileNotFoundException, IOException, ClassNotFoundException, SQLException 
    {
        try {
            try {
                Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
                Statement stmt=(Statement)con.createStatement();
                String select="select url from deepika.urlsnation";
                String title="";
                try {
                    ResultSet st=stmt.executeQuery(select);
                    List <String> list = new ArrayList<>();
                    while(st.next()) {
                        list.add(st.getString(1));
                    }
                    for(String url1:list) {
                        title = "";
                        try {
                            Document doc = Jsoup.connect(url1).get();
			    title = doc.title();
                            title=title.replaceAll("'", "''");
                        } catch (IOException e ) {
                            System.err.println(e.getLocalizedMessage());
                        }
                        String update="update deepika.urlsnation set title='"+title+"' where url='"+url1+"'";
                        stmt.executeUpdate(update);
                    }
                } catch(Exception e) {
                    System.err.println(title);
                    System.out.println(e.getMessage());
                }
            } catch(ClassNotFoundException | SQLException e) {
                System.err.println(e.getLocalizedMessage());
            }
        }catch(Exception e) {
            System.err.println(e.getLocalizedMessage());
        }
    }
}