package sozdik;

import java.awt.*;
import javax.swing.event.*;
import javax.swing.*;

public class SozdikApp extends JFrame {
	
	private static final long serialVersionUID = 1L;
	private JTextField input = new JTextField("", 15);
	private JTextArea label = new JTextArea("Suggestions...", 10, 15);	
	public SozdikApp() {
		super("Sozdik.kz suggestions");
	    this.setBounds(100,100,200,230);
	    this.setResizable(false);
	    this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	    Container container = this.getContentPane();
	    container.setLayout(new FlowLayout());
	    input.setAlignmentY(TOP_ALIGNMENT);
	    container.add(input);
	    container.add(label);
	    input.getDocument().addDocumentListener(new DocumentListener() {
	    	public void insertUpdate(DocumentEvent e) {
	    		try {
	    			String res = "";
	    			for (String s:SozGetter.getSuggestions(input.getText())) {
	    				res = res + s + "\n";
	    			}
	    			label.setText(res);
	    		} catch (Exception ex) {
	    			label.setText(ex.getMessage());
	    		}
	    	}

			public void changedUpdate(DocumentEvent e) {
				insertUpdate(e);
			}

			public void removeUpdate(DocumentEvent e) {
				insertUpdate(e);
			}
	    });
	}
	


	public static void main(String[] args) {
		SozdikApp app = new SozdikApp();
		app.setVisible(true);
	}
}
