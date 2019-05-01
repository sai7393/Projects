package iitm.apl.Minesweeper;
/**
 * Minesweeper main class. 
 * @author Arun Tejasvi Chaganty <arunchaganty@gmail.com>
 */

public class Mines {

	// Board parameters
	// For now, this is hard coded.
	private static int M = 10;
	private static int N = 5;
	private static double p = 0.2;
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {

		javax.swing.SwingUtilities.invokeLater( new Runnable() {
						@Override
			public void run() {
				Board b = new Board( M, N, p );
				MinesWindow win = new MinesWindow( b );
				win.createAndShowGUI();
			}
		});
	}

}
