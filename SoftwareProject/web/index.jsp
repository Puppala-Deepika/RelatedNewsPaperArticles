<%-- 
    Document   : index
    Created on : 13 Nov, 2015, 10:42:04 AM
    Author     : deepika
--%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            select {list-style: none;padding: 0px;margin: 0px; width: 500px; }
            option {list-style: none;padding: 0px;margin: 0px; width: 500px; }
            fieldset{ border: black thick solid ; border-width: 5px;width :880px; position: absolute;top: 40%;left: 15% ;alignment-adjust: middle; margin:0px auto;}
            body {background-image:url("bg.jpg");background-repeat: no-repeat; background-size: cover}
            button{background-image:url("submit3.jpeg"); height: 30px;width: 70px;}  
         </style>
    </head>
    <body>
        <%@page language="java" import="java.sql.*" %>
        <%@page import="de.l3s.boilerpipe.BoilerpipeProcessingException"%>
        <%@page import="de.l3s.boilerpipe.extractors.ArticleExtractor"%>
        <%@page import="java.io.IOException"%>
        <%@page import="java.net.URL"%>
        <%@page import="java.util.List"%>
        <%@page import="java.util.ArrayList"%>
        <%@page import="java.sql.ResultSet"%>
        <%@page import="java.beans.Statement"%>
        <%@page import="java.sql.DriverManager"%>
        <%@page import="java.sql.Connection"%>
        <%@page contentType="text/html" pageEncoding="UTF-8"%>
          
        <%!   
            public static String url="",opt;
            public class getUrls {
                public ResultSet urls() throws Exception {
                    try {
                        Connection con=DriverManager.getConnection("jdbc:derby://localhost:1527/deepika","deepika","deepika");
                        String select="select url from deepika.urlsnation";
                        try {
                            PreparedStatement preparedStatement = con.prepareStatement(select);
                            ResultSet st = preparedStatement.executeQuery();
                            return st;
                        } catch(Exception e){ }
                    } catch(Exception e) { }
                    return null;
                }
            }
        %>
        
        <%
            getUrls gurls = new getUrls();
        %>
        <form method="post" action="re.jsp" >
            <fieldset >
                <span>   
                    <font size = 4 > <b> SELECT URL:</b></font>
                    <select id="urlname" name="urlname"> 
                
                        <%
                            ResultSet st = gurls.urls(); 
                            while(st.next()) {
                                opt = st.getString("URL");
                        %>
                        <option value="<%=opt%>" ><%=opt %></option>
                        <% } %>
                    </select>
                    <input type="radio" name="of" value="offline" required>offline
                    <input type="radio" name="of" value="online">online
                    <button TYPE=submit name=submit  Value="Submit"  ></button>
                </span>
            </fieldset>
        </form>
    </body>
</html>
