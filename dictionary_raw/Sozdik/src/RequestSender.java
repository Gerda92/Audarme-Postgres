import java.net.*;
import java.io.*;
public class RequestSender {

	public static void main(String[] args) throws Exception {
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream("words2.txt"),"UTF-8"));
		PrintWriter defs = new PrintWriter(
				new BufferedWriter(new OutputStreamWriter(new FileOutputStream("defs.html"),"UTF-8")));
		String word = "абай";
		while ((word = br.readLine()) != null) {
			//System.out.println(word);
			try {
			    URL url = new URL("http://sozdik.kz/ru/dictionary/translate/kk/ru/"+URLEncoder.encode(word, "UTF-8")+"/"); //?tm="+System.currentTimeMillis());
			    URLConnection conn = url.openConnection();
	
			    conn.addRequestProperty("Host", "sozdik.kz");
			    conn.addRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1");
			    conn.addRequestProperty("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
			    conn.addRequestProperty("Accept-Language", "ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3");
			    conn.addRequestProperty("Accept-Charset", "windows-1251,utf-8;q=0.7,*;q=0.7");
			    conn.addRequestProperty("Content-Type", "text/html; charset=utf-8");
			    conn.addRequestProperty("Referer", "http://sozdik.kz/");
	
			    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			    String line;
			    
			    boolean defstart = false;
			    while ((line = rd.readLine()) != null) {
			    	if (line.contains("\"dictionary_article_parent_block\"")) break;
			    	if (!defstart && line.contains("\"dictionary_article_translation\"")) {
			    		defstart = true;
			    		defs.append("\n<div><h2>" + word + "</h2>");
			    		line = line.replace("<div id=\"dictionary_article_translation\">","");
			    	}
			    	if (defstart) {
			    		String str = new String (line.getBytes(),"UTF-8");
			    		System.out.println(str);
			        	defs.append(str);
			        	defs.flush();
			        	break;
			        }
			    }
			} catch (Exception e) {
				System.out.println(e.getMessage());
				System.out.println("Error!!!");
			}
	
		}
		defs.close();
		br.close();
	}
}
