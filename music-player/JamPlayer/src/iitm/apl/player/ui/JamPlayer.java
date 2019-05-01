package iitm.apl.player.ui;

import iitm.apl.player.Song;
import iitm.apl.player.ThreadedPlayer;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Vector;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.GroupLayout.Alignment;

/**
 * The JamPlayer Main Class Sets up the UI, and stores a reference to a threaded
 * player that actually plays a song.
 * 
 * TODO: a) Implement the search functionality b) Implement a play-list
 * generation feature
 */
public class JamPlayer {

	// UI Items
	private JFrame mainFrame;
	public static PlayerPanel pPanel;
	private JComboBox jRatingComboBoxSize;
	static JLabel searchStatus;
//	public static JLabel currentPlay;
	private JLabel ratingLabel;
	private JTable libraryTable;
	public static LibraryTableModel libraryModel;
	public static JLabel presentPlay;

	private Thread playerThread = null;
	private ThreadedPlayer player = null;

	private Vector<Song> lstNew;
	public static Vector<Song> songs;
	JComboBox jComboBoxSize = null;
	private Object stri;
	private JComboBox comboBox;
	public static int currentIdx;
	public static Song song;

	public JamPlayer() {
		// Create the player
		player = new ThreadedPlayer();
		playerThread = new Thread(player);
		playerThread.start();
		lstNew = new Vector<Song>();
	}

	/**
	 * Create a file dialog to choose MP3 files to add
	 */
	private Vector<Song> addFileDialog() {
		JFileChooser chooser = new JFileChooser();
		chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
		int returnVal = chooser.showOpenDialog(null);
		if (returnVal != JFileChooser.APPROVE_OPTION)
			return null;

		File selectedFile = chooser.getSelectedFile();
		// Read files as songs
		songs = new Vector<Song>();

		if (selectedFile.isFile()
				&& selectedFile.getName().toLowerCase().endsWith(".mp3")) {
			Song temp = new Song(selectedFile);
			int i = 0;
			for(; i < libraryModel.backupSongListing.size();i++){
				if(libraryModel.backupSongListing.get(i).getTitle().equals(temp.getTitle()))
					break;
			}
			if(i==libraryModel.backupSongListing.size())
			    songs.add(temp);
			return songs;
		} else if (selectedFile.isDirectory()) {
			for (File file : selectedFile.listFiles(new FilenameFilter() {
				@Override
				public boolean accept(File dir, String name) {
					return name.toLowerCase().endsWith(".mp3");
				}
			}))
			{
				Song temp = new Song(file);
				int i = 0;
				for(; i < libraryModel.backupSongListing.size();i++){
					if(libraryModel.backupSongListing.get(i).getTitle().equals(temp.getTitle()))
						break;
				}
				if(i==libraryModel.backupSongListing.size())
				    songs.add(temp);
			}
		}
		for (int i = 0; i < songs.size(); i++)
			lstNew.add(songs.get(i));
		return songs;
	}

	/**
	 * Create the GUI and show it. For thread safety, this method should be
	 * invoked from the event-dispatching thread.
	 * 
	 * @throws IOException
	 */
	private void createAndShowGUI() throws IOException {
		// Create and set up the window.
		mainFrame = new JFrame("JamPlayer");

		mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		mainFrame.setMinimumSize(new Dimension(500, 600));

		// Create and set up the content pane.
		final Container pane = mainFrame.getContentPane();
		pane.add(createMenuBar(), BorderLayout.NORTH);
		pane.add(Box.createHorizontalStrut(30), BorderLayout.EAST);
		pane.add(Box.createHorizontalStrut(30), BorderLayout.WEST);
		pane.add(Box.createVerticalStrut(30), BorderLayout.SOUTH);
		libraryModel = new LibraryTableModel();
		libraryTable = new JTable(libraryModel);
		JPanel mainPanel = new JPanel();
		mainPanel.setBackground(new Color(75, 95, 90));
		GroupLayout layout = new GroupLayout(mainPanel);
		mainPanel.setLayout(layout);
		pPanel = new PlayerPanel(player, libraryModel);
		JLabel searchLabel = new JLabel("Search: ");

		searchLabel.setForeground(new Color(250, 50, 100));
		final JLabel statuslabel = new JLabel();
		final JLabel statuslabel1 = new JLabel();
		statuslabel1.setText("based on ");
		statuslabel1.setForeground(new Color(250, 50, 100));
		statuslabel.setForeground(new Color(250, 50, 100));
		final JLabel statuslabel2 = new JLabel();
		JLabel sortRating = new JLabel();
		sortRating.setText("Sort based on ratings");
		JLabel sortNumOfTimes = new JLabel();
		sortNumOfTimes.setText("Sort based on number of times");
		statuslabel2
				.setText("You can search based on title,album,artist.make your choice");
		pane.add(statuslabel2, BorderLayout.PAGE_END);
		final JTextField searchText = new JTextField(200);
		searchText.setBackground(Color.CYAN);
		searchText.setCaretColor(Color.ORANGE);
		comboBox = getJComboBoxSize();
		comboBox.setMaximumSize(new Dimension(100, 18));
		comboBox.setBackground(Color.yellow);
		comboBox.setForeground(Color.blue);

		searchText.setMaximumSize(new Dimension(150, 20));

		searchText.addKeyListener(new KeyListener() {
			private ArrayList<Song> lst;

			@Override
			public void keyTyped(KeyEvent arg0) {
				// TODO: Handle the case when the text field has been modified.
				// Optional: Can you update the search "incrementally" i.e. as
				// and when the user changes the search text?
			}

			@Override
			public void keyReleased(KeyEvent arg0) {
				String s = searchText.getText();
				int l = s.length();
				if (libraryModel.isempty() == false) {
					if (l > 0) {
						if (stri != null) {
							System.out.println(stri);
							if (stri.equals("Title")) {
								lst = libraryModel.filter(s);
							} else if (stri.equals("Album")) {

								lst = libraryModel.filteralbum(s);
							} else if (stri.equals("Artist")) {

								lst = libraryModel.filterartist(s);
							}
						} else
							lst = libraryModel.filter(s);
						System.out.println(lst);
						libraryModel.remove(songs);
						for (int i = 0; i < lst.size(); i++) {
							songs.add(lst.get(i));
						}
						for (int i = 0; i < lst.size() - 1; i++) {
							if (songs.get(i + 1).equals(songs.get(i))) {
								songs.remove(i + 1);
							}
						}
						if (songs.size() > 0) {
							libraryModel.add1(songs);
							statuslabel.setText("These are the search results");
							statuslabel2.setText("");
							pane.add(statuslabel, BorderLayout.PAGE_END);
						} else {
							statuslabel.setBackground(new Color(200, 150, 100));
							statuslabel.setText("No songs match your search");
							statuslabel2.setText("");
							pane.add(statuslabel, BorderLayout.PAGE_END);
						}
					} else if (l == 0) {
						libraryModel.remove(songs);
						statuslabel2
								.setText("you can search based on title,album,artist.make your choice");
						statuslabel.setText("");
						libraryModel.add1(lstNew);
					}
				}
			}

			@Override
			public void keyPressed(KeyEvent arg0) {
			}
		});

		searchStatus = new JLabel(
				"Search and Sort according to choices available!",
				JLabel.CENTER);
		libraryTable.setGridColor(new Color(200, 50, 100));
		libraryTable.setSelectionBackground(Color.GREEN);
		libraryTable.setBackground(Color.LIGHT_GRAY);
		libraryTable.setSelectionForeground(Color.BLACK);

		libraryTable.addMouseListener(new MouseListener() {

			@Override
			public void mouseReleased(MouseEvent arg0) {
			}

			@Override
			public void mousePressed(MouseEvent arg0) {
			}

			@Override
			public void mouseExited(MouseEvent arg0) {
			}

			@Override
			public void mouseEntered(MouseEvent arg0) {
			}

			@Override
			public void mouseClicked(MouseEvent arg0) {
				if (arg0.getClickCount() > 1) {
					currentIdx = libraryTable.getSelectedRow();
					song = libraryModel.get(currentIdx);
					libraryModel
							.setselectedindex(libraryTable.getSelectedRow());
					if (song != null) {
						song.setNumOfTimesPlayed();
						libraryModel.fireTableDataChanged();
						player.setSong(song);
						pPanel.setSong(song);
						if ( song.getNumOfTimesPlayed() >= 2 ) {
							song.rating += 1;
						}
						try {
							pPanel.func();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
		});

		JButton sort = new JButton("Most Played Order");
		sort.setBackground(Color.green);
		JButton ratingSort = new JButton("Rating Order");
		ratingSort.setBackground(Color.PINK);
		sort.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				libraryModel.sortByPlayedTimes(LibraryTableModel.songListing);
			}
		});

		ratingSort.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				libraryModel.sortBasedOnRating(LibraryTableModel.songListing);
			}
		});

		final JButton allSongs = new JButton("All Songs");
		allSongs.setBackground(Color.RED);
		final JButton recentlyPlayedSongs = new JButton("Recently Played");
		recentlyPlayedSongs.setBackground(Color.YELLOW);
		allSongs.setEnabled(false);
		allSongs.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				allSongs.setEnabled(false);
				recentlyPlayedSongs.setEnabled(true);
				currentIdx = 0;
				libraryModel.showAll();
				// JamPlayer.searchStatus
				// .setText(String
				// .format("Search and Sort according to choices available!"));
			}
		});
		recentlyPlayedSongs.addActionListener(new ActionListener() {
			// TODO Auto-generated method stub

			@Override
			public void actionPerformed(ActionEvent arg0) {
				allSongs.setEnabled(true);
				recentlyPlayedSongs.setEnabled(false);
				currentIdx = 0;
				libraryModel.showRecentPlayed();
			}
		});

		jRatingComboBoxSize = getRatingJComboBoxSize();
		jRatingComboBoxSize.setMaximumSize(new Dimension(40, 20));
		ratingLabel = new JLabel();
		ratingLabel.setText(" Rate the current song : ");
		ratingLabel.setForeground(new Color(250, 50, 100));

		libraryTable
				.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
		JScrollPane libraryPane = new JScrollPane(libraryTable);

		layout.setHorizontalGroup(layout.createParallelGroup(Alignment.CENTER)
				.addComponent(pPanel).addGroup(
						layout.createSequentialGroup().addContainerGap()
								.addComponent(searchLabel).addComponent(
										statuslabel).addComponent(searchText)
								.addComponent(statuslabel1).addComponent(
										comboBox).addComponent(ratingLabel)
								.addComponent(jRatingComboBoxSize)).addGroup(
						layout.createSequentialGroup().addContainerGap()
								.addComponent(ratingSort).addContainerGap()
								.addComponent(sort).addContainerGap()).addGroup(
										layout.createSequentialGroup()
												.addComponent(allSongs)
												.addComponent(
														recentlyPlayedSongs))
				.addComponent(libraryPane));

		layout.setVerticalGroup(layout.createSequentialGroup().addComponent(
				pPanel).addContainerGap().addGroup(
				layout.createParallelGroup(Alignment.CENTER).addComponent(
						searchLabel).addComponent(statuslabel).addComponent(
						statuslabel1).addComponent(searchText).addComponent(
						comboBox).addComponent(ratingLabel).addComponent(
						jRatingComboBoxSize)).addGroup(
				layout.createParallelGroup().addGap(10)
						.addComponent(ratingSort).addGap(10).addComponent(sort)
						.addGap(10)).addGroup(
				layout.createParallelGroup().addComponent(allSongs)
						.addComponent(recentlyPlayedSongs)).addComponent(
				libraryPane));

		pane.add(mainPanel, BorderLayout.CENTER);

		// Display the window.
		mainFrame.pack();
		mainFrame.setVisible(true);
	}

	private JMenuBar createMenuBar() {
		JMenuBar mbar = new JMenuBar();
		JMenu file = new JMenu("File");
		JMenuItem addSongs = new JMenuItem("Add new files to library");
		addSongs.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				Vector<Song> songs = addFileDialog();
				if (songs != null) {
					System.out.println(songs);
					libraryModel.add(songs);
				}
			}
		});
		file.add(addSongs);

		JMenuItem createPlaylist = new JMenuItem("Create playlist");
		createPlaylist.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					createPlayListHandler();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		file.add(createPlaylist);

		JMenuItem quitItem = new JMenuItem("Quit");
		quitItem.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				mainFrame.dispose();
			}
		});
		file.add(quitItem);

		mbar.add(file);

		return mbar;
	}

	protected void createPlayListHandler() throws IOException {
		// TODO: Create a dialog window allowing the user to choose length of
		// play list, and a play list you create that best fits the time
		// specified
		PlayListMakerDialog dialog = new PlayListMakerDialog(this);
		dialog.setVisible(true);
	}

	public Vector<Song> getSongList() {
		Vector<Song> songs = new Vector<Song>();
		for (int i = 0; i < libraryModel.getRowCount(); i++)
			songs.add(libraryModel.get(i));
		return songs;
	}

	public static void main(String[] args) {
		// Schedule a job for the event-dispatching thread:
		// creating and showing this application's GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			@Override
			public void run() {
				JamPlayer player = new JamPlayer();
				try {
					player.createAndShowGUI();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
	}

	private JComboBox getJComboBoxSize() {
		if (jComboBoxSize == null) {
			jComboBoxSize = new JComboBox();
			// jComboBoxSize.
			jComboBoxSize.setModel(new DefaultComboBoxModel(new String[] {
					"Title", "Album", "Artist" }));
			jComboBoxSize.setDoubleBuffered(false);
			jComboBoxSize.setBorder(null);
			jComboBoxSize.addItemListener(new ItemListener() {

				@Override
				public void itemStateChanged(ItemEvent arg0) {
					stri = (String) jComboBoxSize.getItemAt(jComboBoxSize
							.getSelectedIndex());
					jComboBoxSize.setBackground(Color.yellow);

				}
			});
		}
		return jComboBoxSize;
	}

	private JComboBox getRatingJComboBoxSize() {
		if (jRatingComboBoxSize == null) {
			jRatingComboBoxSize = new JComboBox();
			jRatingComboBoxSize.setModel(new DefaultComboBoxModel(
					new Integer[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }));
			jRatingComboBoxSize.setDoubleBuffered(false);
			jRatingComboBoxSize.setBorder(null);
			jRatingComboBoxSize.addItemListener(new ItemListener() {
				@Override
				public void itemStateChanged(ItemEvent arg0) {
					if (PlayerPanel.currentSong != null) {
						PlayerPanel.currentSong.rating = jRatingComboBoxSize
								.getSelectedIndex();
						libraryModel.fireTableDataChanged();
						JamPlayer.searchStatus
								.setText(String
										.format("Search and Sort according to choices available!"));
					}
				}
			});
		}
		return jRatingComboBoxSize;
	}
}
