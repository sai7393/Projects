package iitm.apl.player.ui;

import iitm.apl.player.Song;
import iitm.apl.player.ThreadedPlayer;
import iitm.apl.player.ThreadedPlayer.State;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.AbstractButton;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 * PlayerPanel Contains player controls, and raises appropriate events
 * 
 * @author Arun Tejasvi Chaganty <arunchaganty@gmail.com>
 * 
 */
public class PlayerPanel extends JPanel {
	private static final long serialVersionUID = -5264313656161958408L;
	//private Song lastplayed;
	private JLabel songLabel;
	public static Song currentSong;
	private LibraryTableModel libmodel;
	public Song previousSong;
	public Song nextSong;
	public static ThreadedPlayer player;

	private JButton playPauseButton;

	public PlayerPanel(ThreadedPlayer player_, final LibraryTableModel libmodel) throws IOException {
		// Call the parent constructor
		super();
		this.player = player_;
		this.libmodel = libmodel;

		// Set layout manager
		setLayout(new FlowLayout(FlowLayout.CENTER));

		songLabel = new JLabel("");
		songLabel.setMinimumSize(new Dimension(60, 30));

		// Add buttons
		// playing = new JButton();
		final BufferedImage OImage = ImageIO.read(new File("./o.jpg"));
		final BufferedImage XImage = ImageIO.read(new File("./x.jpg"));
		final BufferedImage NImage = ImageIO.read(new File("./n.jpg"));
		playPauseButton = new JButton("Play/Pause");
		playPauseButton.setForeground(new Color(0,00,150));
		playPauseButton.setBackground(new Color(50,200,70));
		
		
		playPauseButton.setIcon(new ImageIcon(NImage));
		

		JButton prevButton = new JButton("Prev");
		prevButton.setBackground(new Color(50,100,170));
		prevButton.setForeground(new Color(0,00,150));
		prevButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				int n = libmodel.getselectedindex();
				Song song;
				if( n == 0 )
				{ 
					n=libmodel.getRowCount()-1;
					song = libmodel.get(n);
				
				}
					else
					{
						n--;
				song = libmodel.get(n);
					}
				//System.out.println(libmodel.getRowCount());
				libmodel.setnum();
				player.setSong(song);
				setSong(song);
				libmodel.fireTableDataChanged();
				libmodel.setselectedindex(n);
			}
		});
		add(prevButton);

		playPauseButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (player.getState() == State.PLAY) {
					player.setState(State.PAUSE);
					playPauseButton.setText("play");
					playPauseButton.setIcon(new ImageIcon(OImage));
				} else if (player.getState() == State.PAUSE) {
					player.setState(State.PLAY);
					playPauseButton.setIcon(new ImageIcon(XImage));
					playPauseButton.setText("pause");
				}
			}
		});
		add(playPauseButton);

		JButton stopButton = new JButton("Stop");
		stopButton.setBackground(new Color(250,50,70));
		stopButton.setForeground(new Color(0,00,150));
		stopButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				player.setState(State.STOP);
				playPauseButton.setIcon(new ImageIcon(NImage));
				playPauseButton.setText("play/pause");
			}
		});
		add(stopButton);

		JButton nextButton = new JButton("Next");
		nextButton.setBackground(new Color(50,100,170));
		nextButton.setForeground(new Color(0,00,150));
		nextButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				int n = libmodel.getselectedindex();
				Song song;
				//System.out.println(n);
				//System.out.println(libmodel.getRowCount());
				if(n==(libmodel.getRowCount()-1))
				{ 
					n=0;
					song = libmodel.get(n);
				
				}
					else
					{
						n++;
				song = libmodel.get(n);
					}
				//System.out.println(libmodel.getRowCount());
				 player.setSong(song);
				setSong(song);
				libmodel.setnum();
				libmodel.fireTableDataChanged();
				libmodel.setselectedindex(n);
				
			}
		});
		add(nextButton);
	}

	public PlayerPanel(ThreadedPlayer player_) throws IOException {
		// Call the parent constructor
		super();
		this.player = player_;
		this.libmodel = libmodel;

		// Set layout manager
		setLayout(new FlowLayout(FlowLayout.CENTER));

		songLabel = new JLabel("");
		songLabel.setMinimumSize(new Dimension(60, 30));

		// Add buttons
		// playing = new JButton();
		final BufferedImage OImage = ImageIO.read(new File("./o.jpg"));
		final BufferedImage XImage = ImageIO.read(new File("./x.jpg"));
		final BufferedImage NImage = ImageIO.read(new File("./n.jpg"));
		playPauseButton = new JButton("Play/Pause");
		playPauseButton.setForeground(new Color(0,00,150));
		playPauseButton.setBackground(new Color(50,200,70));
		
		
		playPauseButton.setIcon(new ImageIcon(NImage));
		// playing.setText("hey");
		// add(playing);

		JButton prevButton = new JButton("Prev");
		prevButton.setBackground(new Color(50,100,170));
		prevButton.setForeground(new Color(0,00,150));
		prevButton.setEnabled(false);
		prevButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
			}
		});
		add(prevButton);

		playPauseButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (player.getState() == State.PLAY) {
					player.setState(State.PAUSE);
					playPauseButton.setText("play");
					playPauseButton.setIcon(new ImageIcon(OImage));
				} else if (player.getState() == State.PAUSE) {
					player.setState(State.PLAY);
					playPauseButton.setIcon(new ImageIcon(XImage));
					playPauseButton.setText("pause");
				}
			}
		});
		add(playPauseButton);

		JButton stopButton = new JButton("Stop");
		stopButton.setBackground(new Color(250,50,70));
		stopButton.setForeground(new Color(0,00,150));
		stopButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				player.setState(State.STOP);
				playPauseButton.setIcon(new ImageIcon(NImage));
				playPauseButton.setText("play/pause");
			}
		});
		add(stopButton);

		JButton nextButton = new JButton("Next");
		nextButton.setBackground(new Color(50,100,170));
		nextButton.setForeground(new Color(0,00,150));
		nextButton.setEnabled(false);
		nextButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				int n = libmodel.getselectedindex();
				Song song = libmodel.get(n+1);
				
				 player.setSong(song);
				 player.setState(State.PLAY);
			}
		});
		add(nextButton);
	}

	
	public void setSong(Song song) {
		
		currentSong = song;
		String lbl = currentSong.toString();
		songLabel.setText(lbl);
	}

	public void func() throws IOException {
		BufferedImage XImage = ImageIO.read(new File("./x.jpg"));
		playPauseButton.setIcon(new ImageIcon(XImage));
		playPauseButton.setText("pause");

	}

}
