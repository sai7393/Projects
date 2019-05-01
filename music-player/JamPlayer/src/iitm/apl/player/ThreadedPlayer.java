package iitm.apl.player;

import iitm.apl.player.ui.JamPlayer;
import iitm.apl.player.ui.LibraryTableModel;
import iitm.apl.player.ui.PlayerPanel;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.io.File;
import java.io.IOException;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JComboBox;
import javax.swing.event.EventListenerList;

/**
 * Threaded player implements a music player that plays songs in its own thread.
 * 
 * Once the player has been started on a thread, set a song to be played using
 * the "setSong" function. You can also pause/resume using the setState
 * function. To stop playing the track, and perform clean-up actions, set the
 * state to Stop.
 */
public class ThreadedPlayer implements Runnable {

	public enum State {
		PLAY, // Playing a song; the thread is active
		PAUSE, // Paused; waiting till the state is changed from pause
		STOP // Stopped, with nothing in the buffer
	};

	private State state = null;
	private boolean running;
	private Integer rating;
	public LibraryTableModel tableModel;
	public ThreadedPlayer player;
	private final Lock songLock = new ReentrantLock();
	private final Condition hasSong = songLock.newCondition();
	private final Lock stateLock = new ReentrantLock();
	private final Condition notPaused = stateLock.newCondition();

	// Listeners for when the player stops playing a song.
	private EventListenerList listeners;

	private Queue<Song> queuedSongs;

	boolean debug = false;
	JComboBox jComboBoxSize = null;

	public ThreadedPlayer() {
		this.state = State.STOP;
		listeners = new EventListenerList();
		queuedSongs = new PriorityQueue<Song>();
	}

	@SuppressWarnings("unused")
	private void dispose() {
		running = false;
		state = State.STOP;
	}

	public State getState() {
		return this.state;
	}

	/**
	 * Set the state of the player. Takes control of the state lock
	 */
	public void setState(State st) {
		stateLock.lock();
		try {
			if (st == State.PAUSE && state != State.PAUSE) {
				state = st;
			}
			notPaused.signal();
			state = st;
		} finally {
			stateLock.unlock();
		}
	}

	/**
	 * Play a song; extract the appropriate audio input stream, and then send it
	 * to rawPlay to actually write the bytes to the audio device.
	 * 
	 * @param song
	 */
	private void playSong(Song song) {
		if (song == null)
			return;

		String filePath = song.getFile().getAbsolutePath();
		System.err.println("Playing : " + filePath);
		try {
			File file = new File(filePath);
			System.err.println("playing : " + file.getName());

			AudioInputStream in = AudioSystem.getAudioInputStream(file);
			AudioInputStream din = null;
			AudioFormat baseFormat = in.getFormat();
			AudioFormat decodedFormat = new AudioFormat(
					AudioFormat.Encoding.PCM_SIGNED,
					baseFormat.getSampleRate(), 16, baseFormat.getChannels(),
					baseFormat.getChannels() * 2, baseFormat.getSampleRate(),
					false);
			din = AudioSystem.getAudioInputStream(decodedFormat, in);

			// Play now.
			setState(State.PLAY);
			rawPlay(decodedFormat, din , song);
			setState(State.STOP);
			in.close();

		} catch (Exception e) {
			System.out.println(e.toString());
			System.exit(1);
		}
	}

	/**
	 * Get a line to the audio mixer. Writing to the SourceDataLine writes audio
	 * to the mixer, which in turn plays it!
	 */
	private SourceDataLine getLine(AudioFormat audioFormat)
			throws LineUnavailableException {
		SourceDataLine res = null;
		DataLine.Info info = new DataLine.Info(SourceDataLine.class,
				audioFormat);
		res = (SourceDataLine) AudioSystem.getLine(info);
		res.open(audioFormat);
		return res;
	}

	/**
	 * Actually write the audio bytes to the sound device (through
	 * SourceDataLine).
	 */
	private void rawPlay(AudioFormat targetFormat, AudioInputStream din , Song song)
			throws IOException, LineUnavailableException, InterruptedException {

		SourceDataLine line = getLine(targetFormat);
		if (line != null) {
			// Start
			line.start();
			int nBytesRead = 0;

			byte[] data = new byte[4096];
			boolean trackComplete = false;

			// Keep playing till you reach the end of the file or the player has
			// been stopped.
			while (!(trackComplete = ((nBytesRead = din.read(data, 0, data.length)) == -1)
					) && state != State.STOP) {
				
				// Check if you have been paused; if so, wait until that state
				// changes.

				stateLock.lock();
				try {
					while (state == State.PAUSE) {

						if (line.isRunning())
							line.stop();
						notPaused.await();
					}
				} finally {
					stateLock.unlock();
				}

				// If you haven't started writing to the device before, do so
				// now.
				if (!line.isRunning()) {
					line.start();
				}
				// Actually write bytes to the audio device
				line.write(data, 0, nBytesRead);

			}

			if (trackComplete) {
				fireAction(new ActionEvent(this, ActionEvent.ACTION_PERFORMED,
							"track-complete"));
				// drain the pipeline to play the leftover frames, and free up
				// memory, etc.
				line.drain();
				line.stop();
				line.close();
				din.close();
				
				if (JamPlayer.currentIdx < JamPlayer.libraryModel.songListing
						.size() - 1) {
					PlayerPanel.player
							.setSong(JamPlayer.libraryModel.songListing
									.get(JamPlayer.currentIdx + 1));
					JamPlayer.pPanel.setSong(JamPlayer.libraryModel.songListing
							.get(JamPlayer.currentIdx + 1));
					PlayerPanel.currentSong.setNumOfTimesPlayed();
					JamPlayer.libraryModel.fireTableDataChanged();
				
				}
			}
		}
	}

	public void addSong(Song song) {
		songLock.lock();
		{
			queuedSongs.add(song);
			hasSong.signal();
		}
		songLock.unlock();
	}

	// Set the song
	public void setSong(Song song) {
		setState(State.STOP);
		addSong(song);
	}

	@Override
	public void run() {
		// Keep running in a loop; When a song is set, play it.
		running = true;
		while (running) {
			while (queuedSongs.isEmpty()) {
				songLock.lock();
				try {
					hasSong.await();
				} catch (InterruptedException e) {
					return;
				} finally {
					songLock.unlock();
				}
			}
			Song song = queuedSongs.remove();
			
			if (LibraryTableModel.recentlyPlayed.contains(song)) {
				LibraryTableModel.recentlyPlayed.remove(song);
			}
			LibraryTableModel.recentlyPlayed.addFirst(song);
			System.out.println("Hey entered");
			System.out.println(LibraryTableModel.recentlyPlayed);
			System.out.println("entered");
			if (LibraryTableModel.recentlyPlayed.size() > 20)
				LibraryTableModel.recentlyPlayed.removeLast();
			
			// Play the song!
			playSong(song);
		}
	}

	// Action handling stuff

	public void addActionListener(ActionListener listener) {
		listeners.add(ActionListener.class, listener);
	}

	public void removeActionListener(ActionListener listener) {
		listeners.remove(ActionListener.class, listener);
	}

	protected void fireAction(ActionEvent e) {
		for (ActionListener listener : listeners
				.getListeners(ActionListener.class))
			listener.actionPerformed(e);
	}
	
	private JComboBox getJComboBoxSize() {
		if (jComboBoxSize == null) {
			jComboBoxSize = new JComboBox();
			jComboBoxSize.setModel(new DefaultComboBoxModel(
					new Integer[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }));
			jComboBoxSize.setDoubleBuffered(false);
			jComboBoxSize.setBorder(null);
			jComboBoxSize.addItemListener(new ItemListener() {

				@Override
				public void itemStateChanged(ItemEvent arg0) {
					rating = (Integer) jComboBoxSize.getItemAt(jComboBoxSize
							.getSelectedIndex());

				}
			});
		}
		return jComboBoxSize;
	}
}
