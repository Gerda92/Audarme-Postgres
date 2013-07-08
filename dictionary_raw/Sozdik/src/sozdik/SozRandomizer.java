package sozdik;
import java.io.*;
import java.util.*;
import java.util.Calendar;
import java.text.SimpleDateFormat;
public class SozRandomizer {
	
	public int requests = 0;
	
	public int words = 0;
	
	public ArrayList<String> alphabet = new ArrayList<String>();
	
	private BufferedWriter bw;
	
	public SozRandomizer() throws Exception {
	    BufferedReader rd = new BufferedReader(new FileReader("kzAlpha.txt"));
	    
	    String line = rd.readLine();
	    alphabet = splitString(new String (line.getBytes(),"UTF-8"));
	    
		bw = 
			new BufferedWriter(new OutputStreamWriter(new FileOutputStream("words.txt"),"UTF-8"));
	}
	
	private void random (String word) throws Exception {
		int sug = 0;
	    for (String let:this.alphabet) {
	    	ArrayList<String> arr = SozGetter.getSuggestions(word+let);
	    	sug = arr.size();
	    	
    		System.out.println("Seq: "+word+let+"\tSugg: "+sug+
    			"\tReq: "+this.requests+"\tWords: "+this.words+
    			"\t"+time());
    		
	    	this.requests++;

	    	if (sug==10) {
	    		random(word+let);
	    	} else {
	    		if (sug!=0) {
    				for (String w:arr) {
    					if (!w.equals("}")) {
	    					System.out.println(w);
	    					bw.write(w+"\n");
	    					words++;
    					}
    				}
    		    	bw.flush();
	    		}
	    	}
	    	
	    }
	    
	}
	
	private ArrayList<String> splitString(String s) throws Exception {
		ArrayList<String> res = new ArrayList<String>();
		for (int i = 0;i<s.length();i++) {
			res.add(""+s.charAt(i));
		}
		res.remove(0);
		return res;
	}
	
	private String time () {
		Calendar cal = Calendar.getInstance();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd 'at' hh:mm:ss");
	    return sdf.format(cal.getTime());
	}
	
	public static void main (String[] args) throws Exception {
		new SozRandomizer().random("");
	}
}
