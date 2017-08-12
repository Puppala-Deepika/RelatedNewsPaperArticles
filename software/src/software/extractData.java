package software;

import de.l3s.boilerpipe.BoilerpipeProcessingException;
import java.net.URL;
import de.l3s.boilerpipe.extractors.ArticleExtractor;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class extractData {

    private static final String OUTPUTFILE = System.getProperty("user.dir")+"/";

    public static void main(String[] args) throws IOException {
        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
            Statement stmt=(Statement)con.createStatement();
            try {
                String select="select * from deepika.urlsnation";
                try {
                    ResultSet st=stmt.executeQuery(select);
                    while(st.next()) {
                        String url=st.getString(1);
                        String np_name;
                        if(url.contains("thehindu")) {
                            np_name="TheHindu";
                        } else if(url.contains("economictimes")) {
                            np_name="EconomicTimes";
                        } else if(url.contains("timesofindia")) {
                            np_name="TimesofIndia";
                        } else if(url.contains("thehansindia")) {
                            np_name="TheHansIndia";
                        } else {
                            np_name="DeccanHerald";
                        }
                        String h= "/"+url.replace("/", "-")+".txt";
                        int year=st.getInt(2);
                        String month = st.getString(3);
                        int date=st.getInt(4);
                        BufferedWriter output;
                        File dir1 = new File(OUTPUTFILE+year+month+date);
                        dir1.mkdir();
                        File dir2 = new File(dir1+"/"+np_name);
                        dir2.mkdir();
                        try {
                            File dir= new File(dir2+h);
                            dir.createNewFile();
                            String article;
                            try {
                                URL u=new URL(url);
                                article = ArticleExtractor.INSTANCE.getText(u);
                                output = new BufferedWriter(new FileWriter(dir));
                                output.write(article);
                                output.close();
                            }catch (BoilerpipeProcessingException | IOException e ) {
                                System.err.println("err1"+e.getLocalizedMessage());
                            }
                        } catch(Exception e) {
                            System.out.println("err2"+e.getLocalizedMessage());
                        }
                    }
                } catch(Exception e) {
                    System.err.println("err3"+e.getMessage());
                }
            } catch(Exception e) {
                System.err.println("err4"+e.getMessage());
            }
        } catch(Exception e){
            System.err.println("err5"+e.getMessage());
        }   
    }
}