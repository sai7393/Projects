import java.util.*;



public class main {
		public static void main(String[] args) {

		javax.swing.SwingUtilities.invokeLater( new Runnable() {
						@Override
			public void run() {
				
				window win = new window();
				win.creategui();
			}
		});
	}
}
