package iitm.apl.player.ui;

import iitm.apl.player.KnapSack;
import iitm.apl.player.Song;
import iitm.apl.player.ThreadedPlayer;
import iitm.apl.player.ThreadedPlayer.State;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Vector;

import javax.swing.Box;
import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JSlider;
import javax.swing.JTable;
import javax.swing.GroupLayout.Alignment;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

public class PlayListMakerDialog extends JDialog {
	private static final long serialVersionUID = -2891581224281215999L;
	private Vector<Song> songList;
	private PlaylistTableModel playlistModel;
	private PlayerPanel pPanel;
	private Thread playerThread = null;
	private ThreadedPlayer player = null;
	public int time = 0;
	public int W;
	public int n;

	public PlayListMakerDialog(JamPlayer parent) throws IOException {
		super();
		player = new ThreadedPlayer();
		playerThread = new Thread(player);
		playerThread.start();
		songList = parent.getSongList();
		time = 0;
		Container pane = getContentPane();
		pane.add(Box.createVerticalStrut(20), BorderLayout.NORTH);
		pane.add(Box.createVerticalStrut(20), BorderLayout.SOUTH);
		pane.add(Box.createHorizontalStrut(20), BorderLayout.EAST);
		pane.add(Box.createHorizontalStrut(20), BorderLayout.WEST);
		// Create the dialog window
		GroupLayout layout = new GroupLayout(getContentPane());
		getContentPane().setLayout(layout);

		// Create the slider
		JLabel label0 = new JLabel("  Play List Length: ");
		label0.setAlignmentX(200);
		int totalTime = getTotalLength(songList);
		pPanel = new PlayerPanel(player);
		final int n = songList.size();
		JSlider contentSlider = new JSlider(0, totalTime, totalTime);
		final JLabel timeLabel = new JLabel();
		timeLabel.setText(String.format("%d:%02d:%02d", (totalTime / 3600),
				(totalTime / 60) % 60, totalTime % 60));
		contentSlider.addChangeListener(new ChangeListener() {
			@Override
			public void stateChanged(ChangeEvent arg0) {
				JSlider contentSlider = (JSlider) arg0.getSource();
				time = contentSlider.getValue();
				int W = time;

				timeLabel.setText(String.format("%d:%02d:%02d", (time / 3600),
						(time / 60) % 60, time % 60));
			}
		});
		// TODO: Connect to handler that will populate PlaylistTableModel
		// appropriately.
		JButton makeButton = new JButton("Make!");

		makeButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {

				Vector<Song> songs = new Vector<Song>();
				KnapSack k = new KnapSack();

				ArrayList<Integer> values = new ArrayList<Integer>(); // ratings
				ArrayList<Integer> weights = new ArrayList<Integer>(); // duration

				for (int var = 0; var < n; var++) {

					values.add(songList.get(var).getrating());

					weights.add(songList.get(var).getDuration());

				}
				songs = k.knap(values, weights, n, time, songList);
				playlistModel.set(songs);
			}
		});

		playlistModel = new PlaylistTableModel();
		playlistModel.set(songList);
		final JTable playlistTable = new JTable(playlistModel);

		playlistTable.addMouseListener(new MouseListener() {

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
					Song song = playlistModel.get(playlistTable
							.getSelectedRow());
					if (song != null) {
						player.setSong(song);
						pPanel.setSong(song);

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

//		JButton sort = new JButton("Most Played Order");
//		sort.setBackground(Color.green);
//		JButton ratingSort = new JButton("Rating Order");
//		ratingSort.setBackground(Color.PINK);
//		sort.addActionListener(new ActionListener() {
//			@Override
//			public void actionPerformed(ActionEvent e) {
//				playlistModel
//						.sortByPlayedTimes( playlistModel.songListing );
//			}
//		});
//
//		ratingSort.addActionListener( new ActionListener() {
//			@Override
//			public void actionPerformed( ActionEvent e ) {
//				playlistModel.sortBasedOnRating( playlistModel.songListing );
//			}
//		});
		JScrollPane playlistPane = new JScrollPane(playlistTable);

		layout.setVerticalGroup(layout.createSequentialGroup().addGroup(
				layout.createParallelGroup(Alignment.LEADING).addComponent(
						label0).addComponent(pPanel)
						.addComponent(contentSlider).addComponent(timeLabel)
						.addComponent(makeButton)).addContainerGap()
				.addComponent(playlistPane));

		layout.setHorizontalGroup(layout.createParallelGroup().addGroup(
				layout.createSequentialGroup().addComponent(label0)
						.addComponent(pPanel).addComponent(contentSlider)
						.addComponent(timeLabel).addComponent(makeButton))
				.addComponent(playlistPane));
		
//		layout.setHorizontalGroup(layout.createParallelGroup(Alignment.CENTER)
//				.addComponent(pPanel).addGroup(layout.createSequentialGroup().addContainerGap()
//						.addComponent(label0)
//						.addComponent(pPanel).addComponent(contentSlider)
//					.addComponent(timeLabel).addComponent(makeButton)
//				).addGroup(layout.
//				createSequentialGroup().addContainerGap().addComponent(ratingSort).addContainerGap().
//				addComponent(sort).addContainerGap()).addComponent(playlistPane));
//				
//				layout.setVerticalGroup(layout.createSequentialGroup().addComponent(pPanel).addContainerGap()
//				.addGroup(layout.createParallelGroup(Alignment.CENTER).addComponent(label0)
//					.addComponent(pPanel).addComponent(contentSlider)
//					.addComponent(timeLabel).addComponent(makeButton)).addGroup(layout.createParallelGroup().addGap(10).
//				addComponent(ratingSort).addGap(10).addComponent(sort).addGap(0)).addComponent(playlistPane));

		this.pack();
	}

	public static int getTotalLength(Vector<Song> songs) {
		int time = 0;
		for (Song song : songs)
			time += song.getDuration();
		return time;
	}

}
