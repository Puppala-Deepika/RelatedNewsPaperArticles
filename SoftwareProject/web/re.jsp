<%-- 
    Document   : response
    Created on : 14 Nov, 2015, 11:01:45 AM
    Author     : deepika
--%>

<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@page import="de.l3s.boilerpipe.extractors.ArticleExtractor"%>
<%@page import="java.net.URL"%>
<%@page import="de.l3s.boilerpipe.BoilerpipeDocumentSource.*"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style >
            select {list-style: none;padding: 0px;margin: 0px; width: 830px; }
            option {list-style: none;padding: 0px;margin: 0px; width: 830px; }
            body {background-image:url("bg.jpg");background-repeat: no-repeat; background-size: cover}
            button{background-image:url("submit3.jpeg"); height: 30px;width: 70px;}
        </style>
       
        <%!
            public void we(String k,HttpServletRequest request) {
                //function to get parameters from index page and store in the newly defined variables
                url = request.getParameter("urlname");
                ss= request.getParameter("of");
            }
            public HashSet gethashset(String hs) {
                try {
                    //SET FILE PATH HERE
                    FileReader fr1 = new FileReader("/home/deepika/Desktop/deepika/projects/CS3303/Related_Articles/SoftwareProject/resources/stoptitle.txt");
                    BufferedReader br1 = new BufferedReader(fr1);
                    stopwords = new ArrayList();
                    String line1;
                    while ((line1 = br1.readLine()) != null) {
                        stopwords.add(line1);
                    }
                }catch(Exception e){}
                HashSet h = new HashSet();
                StringTokenizer st1 = new StringTokenizer(hs,":,[ ]-/'");
                while(st1.hasMoreTokens()) {
                         String word = st1.nextToken();
                         word=word.toLowerCase();
                         if(!stopwords.contains(word))
                         h.add(word);
                }
                return h;
            }
        
            public static String url="",opt,text="",hsmain,hse,maint,ss;
            List str;
            List stopwords;
       
            public class getUrls {
                public String mode() {
                    if(ss.equals("online")) {
                        try {
                           URL u=new URL(url);
                           text = ArticleExtractor.INSTANCE.getText(u);
                        } catch (Exception e ) {
                            System.err.println("error1"+e.getLocalizedMessage());
                        }
                        return text;
                    } else if(ss.equals("offline")) {
                        try {
                            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                            Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
                            String select="select yr,month,date from deepika.urlsnation where url=?";
                            try{
                                PreparedStatement preparedStatement = con.prepareStatement(select);
                                preparedStatement.setString(1,url);
                                ResultSet st = preparedStatement.executeQuery();
                                String year="",month="",date="",urlm=url.replace("/","-")+".txt",np_name;
                                
                                if(st.next()) {
                                    year=st.getString("yr");
                                    month=st.getString("month");
                                    date=st.getString("date");
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
                        	for(int i=0;i<linenumber;i++) {
                                    text=text+"\n"+br.readLine();
                                }
                            } catch(Exception e) { return e.getLocalizedMessage();}
                        } catch(Exception e){}
                        return text;
                    } else
                        return ss;
                }
                
                public void article() throws Exception {
                    try {
                        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                        Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
                        String select="select hashset,title from deepika.urlsnation where url=?";
                        try {
                            PreparedStatement preparedStatement = con.prepareStatement(select);
                            preparedStatement.setString(1,url);
                            ResultSet st = preparedStatement.executeQuery();
                            if(st.next()) {
                                hsmain=st.getString("hashset");
                                maint=st.getString("title");
                            }
                        } catch(Exception e) { }
                    } catch(Exception e){} 
                }
                
                public List RealatedArticle() {
                    String [] articles=null;
                    List urls = new ArrayList();
                    List comparison = new ArrayList();
                    Set mtlist=new HashSet();
                    Set tlist=new HashSet();
                    mtlist=gethashset(maint);
                    try {
                        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                        Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
                        String select="select url,hashset,title from deepika.urlsnation where url != ?";
                        try {
                            ResultSet st=null;
                            PreparedStatement preparedStatement = con.prepareStatement(select);
                            preparedStatement.setString(1,url);
                            try {
                                st = preparedStatement.executeQuery();
                            } catch(Exception e) {
                                urls.add("preparedstatement error");
                                return urls;
                            }
                            String hs;
                            while(st.next()){
                                String hstitle="";   
                                hs = st.getString("hashset");
                                hstitle=st.getString("title");
                                HashSet H= gethashset(hs);
                                HashSet hsm = gethashset(hsmain);
                                Set intersection = new HashSet(H);
                                intersection.retainAll(hsm);
                                Set union = new HashSet(H);
                                union.addAll(hsm);                             
                                tlist=gethashset(hstitle);
                                Set tintersection=new HashSet(mtlist);   
                                tintersection.retainAll(tlist);
                                double comp = (intersection.size()*1000)/union.size();
                                int m=Math.max(tlist.size(),mtlist.size() );
                                double tcomp=tintersection.size()*1000/m;
                                comp=comp+tcomp;
                                if(comp > 210) {
                                    comparison.add(comp);
                                    Collections.sort(comparison);
                                    Collections.reverse(comparison);
                                    int p;
                                    p=comparison.indexOf(comp);
                                    urls.add(p,st.getString("url"));
                                }
                            }
                        } catch(Exception e) { }
                    } catch(Exception e){}
                    return urls;
                }
            }
        %>
    </head>
    <body>
        <%
            we("1",request);
            getUrls gurls=new getUrls();
            gurls.article();
            opt=gurls.mode();
            if(url != "") {
                HashSet a = gethashset(hsmain);
                List S = gurls.RealatedArticle();
        %>
        <fieldset style="border: black thick solid ; border-width: 5px;width :700px; position: absolute;top: 1%;left: 13% ;alignment-adjust: middle; margin:0px auto;">
            <H3><%out.println(maint);%></H3>
            <textarea readonly name="textboxn" style=" font-family: cursive; font-size:12pt;height:350px; width:900px" id="textboxn" ><%out.println(opt);%></textarea>
            <br>
            <h3>Related articles are : <sub>(select and submit to view article)</sub> </h3> 
            <form method="post" action="response2.jsp" >
                <select name="urlname" id="urlname" size='7' required>
                    <%
                        for(int i=0;i<S.size();i++) {
                            String p=S.get(i).toString();
                            String s = "related " + i ;
                            out.println(s);
                    %>
                            <option value="<%=p%>" > <%=p%></option>
                    <%
                        }
                    }
                    %>
                </select>
                <input type="text" name="ss" value="<%=ss%>" hidden>
                <button TYPE=submit name=submit Value="Submit"></button>
            </form>
        </fieldset>
    </body>
</html>