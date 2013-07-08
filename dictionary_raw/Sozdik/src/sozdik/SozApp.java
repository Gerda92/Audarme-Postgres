package sozdik;
import java.io.*;
import java.util.*;
public class SozApp {
	
	private void suggesions (String sugg, BufferedWriter words) throws Exception {
		ArrayList<String> arr;
		int i = 0;
	    do {
	    	arr = SozGetter.getSuggestions(sugg);
	    	if (arr.size() == 0) {
	    		System.out.println("No suggesions");
	    		return;
	    	}
	    	arr.remove(0);
	    	for (String word : arr) {
	    		System.out.println(word);
	    		words.append(word+"\n");
	    	}
	    	
	    	words.flush();
	    	sugg = arr.get(arr.size() - 1);
	    	//System.out.println(i + " "); i++;
	    } while (!sugg.equals("ÿרלא"));
	    
	}
	
	public static void main (String[] args) throws Exception {
		BufferedWriter words = 
			new BufferedWriter(new OutputStreamWriter(new FileOutputStream("words.txt"),"UTF-8"));
		try {
			new SozApp().suggesions("א", words);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		words.flush();
	    words.close();
		
	}
}
