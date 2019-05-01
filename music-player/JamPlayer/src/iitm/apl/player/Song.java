package iitm.apl.player;

import java.io.File;
import java.util.Random;

import org.jaudiotagger.audio.AudioFile;
import org.jaudiotagger.audio.AudioFileIO;
import org.jaudiotagger.audio.AudioHeader;
import org.jaudiotagger.tag.FieldKey;
import org.jaudiotagger.tag.Tag;

/**
 * A song is a collection of metadata about a music file. It contains a link to
 * the file on the hard drive, as well as provide some functions to the tag
 * information of the song.
 */
public class Song {
	/** File on disk */
	private File file;
	/** The audio header, containing information about track length, etc. */
	private AudioHeader header;
	/** Tag information of artist, title, etc. */
	private Tag tag;
	public int rating;
	private int numOfTimesPlayed;
	Random rand = new Random();

	/**
	 * Create a metadata-instance
	 * 
	 * @param file
	 *            : The file on disk corresponding to the music file
	 */
	public Song(File file) {
		this.file = file;
		try {
			AudioFile f = AudioFileIO.read(file);
			header = f.getAudioHeader();
			tag = f.getTag();
		} 
		catch (Exception e) {
			header = null;
			tag = null;
		}
		rating = rand.nextInt( 2 );
		numOfTimesPlayed = 0;
	}

	/* Getters */
	public File getFile() {
		return this.file;
	}

	public Tag getTag() {
		return tag;
	}

	public AudioHeader getHeader() {
		return header;
	}

	public String getArtist() {
		return tag.getFirst(FieldKey.ARTIST);
	}

	public String getgenre() {
		return tag.getFirst(FieldKey.GENRE);
	}
	public String getTitle() {
		return tag.getFirst(FieldKey.TITLE);
	}

	public int getrating() {
		return this.rating;
	}

	public void setNumOfTimesPlayed() {
		this.numOfTimesPlayed += 1;
	}
	
	public String getAlbum() {
		return tag.getFirst(FieldKey.ALBUM);
	}

	public int getDuration() {
		return header.getTrackLength();
	}

	public int getNumOfTimesPlayed() {
		return this.numOfTimesPlayed;
	}
	
	@Override
	public String toString() {
		return getArtist() + " - " + getTitle() + " - " + getAlbum();
	}
	
	
	public void setrating(int rate) {
		this.rating = rate;
	}
}
