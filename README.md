# RelatedNewsPaperArticles

Developed a web application which gives the most related newspaper articles for a selected article from the set of varied articles of five different newspapers.


Setup/Installation in NetBeans IDE :
1. software and softwareProject are NetBeans Projects. Open the projects using Netbeans.
2. Add a new Database under services. The database used in project is named 'deepika', username 'deepika' and password 'deepika'
3. Make the corresponding changes in code in case you use another database setup.
4. Create a table urlsnation with the folllowing columns - url - VARCHAR, yr - INTEGER, month - CHAR, date - INTEGER, title - VARCHAR, hashset - VARCHAR
5. Run the java files in the software project in the following order- Software.java, Title.java, ExtractData.java, HashSet.java
6. Run the index.jsp in the SoftwareProject using any server.

Important files :
1. /software/src/software/Software.java - Collects the newspaper atricles URLS along with published date using Jsoup.
2. /software/src/software/Title.java - Collects the newspapere articles title using BoilerPipe.
3. /software/src/software/ExtractData - Collects the content of each article and writes to file. The content files are present in software directory named 2017Aug10, 2017Aug09
4. /sofware/src/software/HashSet.java - From the extracted articles finds important words(excluding stop-words present in stop-words-English.txt file) present in each article and stores in the database in the form of hashset.
5. /SoftwareProject/web/index.jsp - Web interface index page for finding similar articles. In this page user is asked to select a article.
6. /SoftwareProject/web/response.jsp - The similar article for selected article are shown.
7. /SoftwareProject/web/re.jsp - To display the content of selected article. If the mode is offline, the content is obtained from the extracted text files elsif mode is online, the cotent is extracted from corresponding webpage and is displayed.

Implementation Details :
1. The news articles from 5 different newspapers are extracted from their RSS feeds along with their published date.
2. The content of extracted articles are preprocessed to get important words in the content removing stop-words such as pronouns, conjuctions,etc..,
3. important words are stored in the form of HashSet for each article.
4. Similarity of two articles with HashSets S1, S2 is obtained by :
similarity_score = alpha * (S1 intersection S2)/(S1 union S2) + (1 - alpha) * (S1_title intersection S2_title)/(S1_title union S2_title)
5. alpha is parameter set according to the importance given to title vs content.
6. the similarity_score is above certain threhsold, the articles are regarded as similar.
7. The code for data pre-processing is written in Java, the web application is built using JSP.

Important tools used :
1. Boilerpipe
2. Jsoup
3. PorterStemmer
4. Derby Database
