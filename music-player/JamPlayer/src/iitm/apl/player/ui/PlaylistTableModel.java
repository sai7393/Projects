package iitm.apl.player.ui;

import iitm.apl.player.Song;
import iitm.apl.player.ui.LibraryTableModel.PlayedTimesComparator;
import iitm.apl.player.ui.LibraryTableModel.UserRatingComparator;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Vector;

import javax.swing.table.AbstractTableModel;

public class PlaylistTableModel extends AbstractTableModel {

	private static final long serialVersionUID = 3206438329683180875L;
	
	Vector<Song> songListing;

	PlaylistTableModel() {
		songListing = new Vector<Song>();
	}

	public void add(Song song) {
		songListing.add(song);
		fireTableDataChanged();
	}

	public void remove(Song song) {
		songListing.remove(song);
		fireTableDataChanged();
	}
	
	public void set(Vector<Song> songs) {
		songListing = songs;
		fireTableDataChanged();
	}

	// Gets the song at the currently visible index
	public Song get(int idx) {
		return songListing.get(idx);
	}

	@Override
	public int getColumnCount() {
		// Title, Album, Artist, Duration.
		return 5;
	}

	@Override
	public int getRowCount() {
		return songListing.size();
	}

	@Override
	public Object getValueAt(int row, int col) {
		Song song = songListing.get(row);

		switch (col) {
		case 0: // Title
			return song.getTitle();
		case 1: // Album
			return song.getAlbum();
		case 2: // Artist
			return song.getArtist();
		case 3: // Duration
			int duration = song.getDuration();
			int mins = duration / 60;
			int secs = duration % 60;
			return String.format("%d:%2d", mins, secs);
			
		case 4:
			return song.getrating();
		default:
			return null;
		}
	}

	@Override
	public String getColumnName(int column) {
		switch (column) {
		case 0: // Title
			return "Title";
		case 1: // Album
			return "Album";
		case 2: // Artist
			return "Artist";
		case 3: // Duration
			return "Duration";
		case 4:
			return "Rating";
		default:
			return super.getColumnName(column);
		}
	}
	public void sortByPlayedTimes ( Vector<Song> originalSongListing ) {
		Song[] songs = new Song[originalSongListing.size()];
		for (int i = 0; i < originalSongListing.size(); i++)
			songs[i] = originalSongListing.elementAt(i);

		Arrays.sort( songs, new PlayedTimesComparator() );

		for (int i = 0; i < originalSongListing.size(); i++)
			songListing.setElementAt(songs[i], i);

		fireTableDataChanged();
	}
	
	private class PlayedTimesComparator implements Comparator<Song> {
		@Override
		public int compare(Song arg0, Song arg1) {
			// TODO Auto-generated method stub
			return arg1.getNumOfTimesPlayed() - arg0.getNumOfTimesPlayed();
		}
	}

	public void sortBasedOnRating ( Vector<Song> originalSongListing ) {
		Song[] songs = new Song[originalSongListing.size()];
		for ( int i = 0; i < originalSongListing.size(); i++ )
			songs[i] = originalSongListing.elementAt(i);

		Arrays.sort( songs, new UserRatingComparator() );

		for ( int i = 0; i < originalSongListing.size(); i++ )
			songListing.setElementAt( songs[i], i );

		fireTableDataChanged();
	}

	private class UserRatingComparator implements Comparator<Song> {
		@Override
		public int compare(Song arg0, Song arg1) {
			// TODO Auto-generated method stub
			return arg1.getrating() - arg0.getrating();
		}
	}

}
