package software;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.StringTokenizer;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jsoup.Jsoup;  
import org.jsoup.nodes.Document;  
import org.jsoup.nodes.Element;  
import org.jsoup.select.Elements;
public class Software 
{
    //To extract links of newspaper articles from different newspaper RSS feeds.
    public static void extractLinks(String url,String common) throws Exception {
        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
            Statement stmt=(Statement)con.createStatement();
        
            int j=0;
            try {
                Document doc = Jsoup.connect(url).timeout(0).get();   
                Elements links = doc.select("link");
                Elements links2= doc.select("pubdate");
                for (Element link : links) {
                    if(link.toString().contains(".com/"+common) ) {
                        String s=link.toString();
                        StringTokenizer st=new StringTokenizer(links2.get(j).toString()," ,");
                        st.nextToken();
                        st.nextElement();
                        String date=st.nextToken();
                        String month=st.nextToken();
                        String year=st.nextToken();
                        j++;
                        String insert;
                        if(link.text().contains("thehansindia"))
                            insert="insert into deepika.urlsnation values('"+link.text()+"',"+year+",'"+date+"',"+month+")";
                        else
                            insert="insert into deepika.urlsnation values('"+link.text()+"',"+year+",'"+month+"',"+date+")";
                        try {
                            stmt.executeUpdate(insert);
                        } catch(Exception e) {
                            System.err.println(e.getMessage());
                        }
                    }
                }
                System.out.println(j);
            } catch(Exception e) {
                System.err.println(e.getMessage());
            }
        } catch(ClassNotFoundException | SQLException e) {
            System.err.println(e.getMessage());
        }
    }
    
    public static void main(String[] args) throws IOException {
        try {
            extractLinks("http://www.thehindu.com/news/national/?service=rss","news");
            
            extractLinks("http://www.deccanherald.com/rss/national.rss","content");
            
            extractLinks("http://timesofindia.feedsportal.com/c/33039/f/533916/index.rss","c");
            
            extractLinks("http://economictimes.indiatimes.com/rssfeeds/1052732854.cms","news");
            
            extractLinks("http://www.thehansindia.com/rss/index/26.xml","posts");
            
        } catch (Exception ex) {
            Logger.getLogger(Software.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
}