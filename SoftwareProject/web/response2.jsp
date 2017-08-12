<%-- 
    Document   : response2
    Created on : 21 Nov, 2015, 11:52:21 AM
    Author     : deepika
--%>

<%@page import="java.io.LineNumberReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="de.l3s.boilerpipe.extractors.ArticleExtractor"%>
<%@page import="java.net.URL"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {background-image:url("bg.jpg");background-repeat: no-repeat; background-size: cover}
            button{font-weight: bold;background-color:transparent;color:black;height: 40px;width: 150px;}
            button:hover{font-weight: 900;background-color:transparent;color:black;height: 60px;width: 180px;}
        </style>
        <%!
            public void we(String k,HttpServletRequest request) {
                //function to get parameters from index page and store in the newly defined variables
                url = request.getParameter("urlname");
                ss = request.getParameter("ss");
            }
        
            public static String url="",opt,text="",title,hse,urlname,ss="jkl";
       
            public class getArticle {
                public String article() throws Exception {
                    if(ss.equals("online")) {
                        try {
                            URL u=new URL(url);
                            text = ArticleExtractor.INSTANCE.getText(u);
                            Document doc = Jsoup.connect(url).get();
                            title = doc.title();
                        } catch (Exception e ) {
                            System.err.println("error1"+e.getLocalizedMessage());
                        }                       
                        return text;
                    } else if(ss.equals("offline")) {
                        try {
                            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                            Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
                            String select="select yr,month,date,title from deepika.urlsnation where url=?";
                            try {
                                PreparedStatement preparedStatement = con.prepareStatement(select);
                                preparedStatement.setString(1,url);
                                ResultSet st = preparedStatement.executeQuery();
                                String year="",month="",date="",urlm=url.replace("/","-")+".txt",np_name;
                                
                                if(st.next()) {
                                    year=st.getString("yr");
                                    month=st.getString("month");
                                    date=st.getString("date");
                                    title=st.getString("title");
                                }
                                
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
                                //SET FILE PATH HERE
                                File f = new File("/home/deepika/Desktop/deepika/software/"+year+month+date+"/"+np_name+"/"+urlm); 
                                FileReader fr = new FileReader(f);
                                BufferedReader br = new BufferedReader(fr);
                                LineNumberReader lnr = new LineNumberReader(fr);
                                int linenumber = 0;    
                                while (lnr.readLine() != null) {
                                	linenumber++;
                                }
                                lnr.close();
                                fr.close();
                                fr = new FileReader(f);
                                br = new BufferedReader(fr);
                                text  = "";
                        	for(int i=0;i<linenumber;i++) {
                                    text=text+"\n"+br.readLine();
                                }
                            } catch(Exception e) { return e.getLocalizedMessage();}
                        } catch(Exception e) { return e.getLocalizedMessage();}
                        return text;
                    } else
                    return url+ss;
                }
            }
        %>
    </head>
    <body>
        <table>
            <tr>
                <td>
                    <%
                        we("qw",request);
                        getArticle ga = new getArticle();
                        String art = ga.article();
                    %>
                    <h3><%=title%></h3>
                    <textarea readonly name="textboxn"   id="textboxid" style="font-size:12pt;height:420px;width:900px;"><%out.println(art);%></textarea>
                    <br><br>
                </td>
                <td>
                    <form  method="post" action="index.jsp">
                        <button TYPE=submit name=submit Value="Submit">Home Page</button> 
                    </form>
                </td>
                <td>
                    <form method="post" action="javascript:window.history.back();" >
                        <button TYPE=submit name=submit Value="Submit"> Previous Page</button>  
                    </form>
                </td>
            </tr>
        </table>
    </body>
</html>