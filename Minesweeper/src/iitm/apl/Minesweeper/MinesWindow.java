package iitm.apl.Minesweeper;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;

public class MinesWindow {
	Board minesBoard;
	boolean[][] revealed;

	JFrame mainFrame;
	JPanel minePanel;
	JButton[][] mineButtons;
	JLabel statusLabel;

	/**
	 * Construct a Minesweeper window of the dimensions of the board.
	 * 
	 * @param b
	 *            - the board
	 */
	MinesWindow(Board b) {
		minesBoard = b;
	}

	/**
	 * Create a board, and then construct an appropriate Minesweeper window
	 * 
	 * @param M
	 * @param N
	 * @param p
	 */
	MinesWindow(int M, int N, double p) {
		minesBoard = new Board(M, N, p);
	}

	/**
	 * Create the GUI
	 */
	public void createAndShowGUI() {
		// Creates the main window. JFrame is a generic top level container.
		mainFrame = new JFrame("Minesweeper");
		mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		// We should set a minimum size to make the GUI look a little nicer
		// while making it.
		mainFrame.setMinimumSize(new Dimension(500, 400));

		Container mainPane = mainFrame.getContentPane();

		// Create a menu bar
		JMenuBar mBar = new JMenuBar();
		JMenu menu = new JMenu("File");
		// Create new game
		JMenuItem newItem = menu.add("New");
		newItem.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				newGame();
			}
		});
		// Quit
		JMenuItem quitItem = menu.add("Quit");
		quitItem.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				mainFrame.dispose();
			}
		});
		mBar.add(menu);

		mainPane.add(mBar, BorderLayout.PAGE_START);

		// Create status bar
		statusLabel = new JLabel("Start a new game");
		mainPane.add(statusLabel, BorderLayout.PAGE_END);

		// Create a MxN grid layout
		minePanel = new JPanel(new GridLayout(minesBoard.M, minesBoard.N));

		mainPane.add(minePanel, BorderLayout.CENTER);
		// Pack is required actually decide how components should be laid out.
		// It should be called before the GUI is displayed.
		mainFrame.pack();
		// Of course, the frame needs to be made visible.
		mainFrame.setVisible(true);
	}

	private void newGame() {
		// Reset the reveal matrix
		revealed = new boolean[minesBoard.M][minesBoard.N];
		for (int i = 0; i < minesBoard.M; i++)
			for (int j = 0; j < minesBoard.N; j++)
				revealed[i][j] = false;

		// Remove everything in the panel, and reset it
		minePanel.removeAll();
		mineButtons = new JButton[minesBoard.M][minesBoard.N];
		for (int i = 0; i < minesBoard.M; i++) {
			for (int j = 0; j < minesBoard.N; j++) {
				final String coords = String.format("%c%d", 'a' + i, j);
				final int mi = i;
				final int mj = j;
				mineButtons[i][j] = new JButton("");
				mineButtons[i][j].addMouseListener( new MouseListener() {
					@Override
					public void mouseClicked(MouseEvent e) {
						if ( e.getButton() == MouseEvent.BUTTON1 )
						{
							System.out.println( coords );
							revealSquare(mi, mj);
						}
						else if( e.getButton() == MouseEvent.BUTTON3 )
						{
							if( mineButtons[mi][mj].getBackground() != Color.green )
								mineButtons[mi][mj].setBackground( Color.green );
							else
								mineButtons[mi][mj].setBackground( null );
						}
						
					}

					@Override
					public void mouseEntered(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mouseExited(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mousePressed(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mouseReleased(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}
				});
				minePanel.add(mineButtons[i][j]);
			}
		}
		mainFrame.pack();

		updateStatus(getRemainingCount());
	}

	private int getRemainingCount() {
		int count = 0;
		for (int i = 0; i < minesBoard.M; i++)
			for (int j = 0; j < minesBoard.N; j++)
				count += (revealed[i][j]) ? 1 : 0;
		return minesBoard.M * minesBoard.N - minesBoard.mineCount - count;
	}

	/**
	 * Counts the number of un-revealed squares
	 */
	private void updateStatus(int count) {
		if (count == 0) {
			statusLabel.setText(String.format("Congratulations, you won!"));
		} else if (count == -1) {
			statusLabel.setText(String.format("Game over, you lost."));
		} else {
			statusLabel.setText(String.format(
					"%d squares left to check with %d mines", count,
					minesBoard.mineCount));
		}
	}

	private void revealSquare(int i, int j) {
		// First check if the square has already been revealed.
		if (revealed[i][j])
			return;
		else {
			revealed[i][j] = true;
			// Check if the square was a mine
			int mines = minesBoard.getAdjacentBombs(i, j);
			if (mines == -1) {
				// Reveal all mines, and disable the rest
				for (int ii = 0; ii < minesBoard.M; ii++) {
					for (int jj = 0; jj < minesBoard.N; jj++) {
						if (minesBoard.getAdjacentBombs(ii, jj) == -1)
							mineButtons[ii][jj].setText("X");
						mineButtons[ii][jj].setEnabled(false);
					}
				}
				updateStatus(-1);

			} else {
				mineButtons[i][j].setText(String.valueOf(mines));
				mineButtons[i][j].setEnabled(false);
				if (mines == 0) {
					for (int ii = i - 1; ii <= i + 1; ii++)
						for (int jj = j - 1; jj <= j + 1; jj++)
							if (ii > -1 && ii < minesBoard.M && jj > -1 && jj < minesBoard.N )
								revealSquare(ii, jj);
				}
				updateStatus(getRemainingCount());
			}

		}
	}

}
