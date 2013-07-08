package sozdik;
import java.net.*;
import java.io.*;
import java.util.*;
public class SozGetter {
	private static ArrayList<String> jsonParser(String raw) {
		ArrayList<String> res = new ArrayList<String>();
		StringTokenizer st = new StringTokenizer(raw, "[]");
		while (st.hasMoreTokens()) {
			res.add(st.nextToken());
		}
		raw = res.get(1);
		res.clear();
		st = new StringTokenizer(raw, "\",\"");
		while (st.hasMoreTokens()) {
			res.add(st.nextToken());
		}
		String f = res.get(0);
		f.replaceFirst(".*,$","");
		//f = f.substring(1,f.length()-2);
		res.set(0, f);
		return res;
	}
	public static ArrayList<String> getSuggestions (String word) throws Exception {
		ArrayList<String> res = new ArrayList<String>();
	    URL url = new URL("http://sozdik.kz/suggest/kk/ru/"+
	    		URLEncoder.encode(word, "UTF-8")+"/?tm="+System.currentTimeMillis());
	    URLConnection conn = url.openConnection();

	    conn.addRequestProperty("Host", "sozdik.kz");
	    conn.addRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1");
	    conn.addRequestProperty("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
	    conn.addRequestProperty("Accept-Language", "ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3");
	    conn.addRequestProperty("Accept-Charset", "windows-1251,utf-8;q=0.7,*;q=0.7");
	    conn.addRequestProperty("Content-Type", "text/html; charset=utf-8");
	    conn.addRequestProperty("X-Requested-With", "XMLHttpRequest");
	    //conn.addRequestProperty("", "XMLHttpRequest");
	    conn.addRequestProperty("Referer", "http://sozdik.kz/");

	    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	    String in = "", line;
		    
	    while ((line = rd.readLine()) != null) {
	    	in = in + new String (line.getBytes(),"UTF-8");
	    }
	    if (in.length()>2) res = jsonParser(in);
	    rd.close();
		
		return res;

	}
}
