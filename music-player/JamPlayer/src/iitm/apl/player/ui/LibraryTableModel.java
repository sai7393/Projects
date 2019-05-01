package iitm.apl.player.ui;

import iitm.apl.player.Song;
import iitm.apl.player.Trie;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Vector;
import javax.swing.table.AbstractTableModel;

/**
 * Table model for a library
 * 
 */
public class LibraryTableModel extends AbstractTableModel {
	private static final long serialVersionUID = 8230354699902953693L;

	// TODO: Change to your implementation of Trie/BK-Tree
	public static Vector<Song> songListing;
	private int songIteratorIdx;
	private Song currentSong;
	private Iterator<Song> songIterator;
	public static int selectedindex;
	private Trie songList;
	private static Trie intable;
	private Trie songalbum;
	private Trie songartist;
	
	public static Vector<Song> backupSongListing;
	public static LinkedList<Song> recentlyPlayed = new LinkedList<Song>();
	
	LibraryTableModel() {
		songListing = new Vector<Song>();
		backupSongListing = new Vector<Song>();
		songIterator = songListing.iterator();
		songList = new Trie();
		songalbum = new Trie();
		songartist = new Trie();
		intable = new Trie();
		selectedindex = 0;
	}
	public boolean isempty()
	{
		if( songList.getcount() == 0 )
			return true;
		else
			return false;
	}
	
	public void add(Song song) {
		songListing.add( song );
		backupSongListing.add( song );
		songList.addString( song );
		songalbum.addString1( song );
		songartist.addString2( song );
		intable.setcount( songListing.size() );
		resetIdx();
		fireTableDataChanged();
	}

	public void add1( Song song ) {
		songListing.add( song );
		intable.setcount( songListing.size() );
		
		resetIdx();
		fireTableDataChanged();
	}

	public void add( Vector<Song> songs ) {
		//songListing.addAll(songs);
		for (int i = 0; i < songs.size(); i++) {
			songList.addString(songs.get(i));
			songalbum.addString1(songs.get(i));
			songartist.addString2(songs.get(i));
			songListing.add(songs.get(i));
			backupSongListing.add( songs.get(i) );
		}
		intable.setcount( songListing.size() );
		resetIdx();
		fireTableDataChanged();
	}

	public void add1( Vector<Song> songs ) {
		songListing.addAll( songs );
		//backupSongListing.addAll( songs );
		intable.setcount(songListing.size());
		
		resetIdx();
		fireTableDataChanged();
	}

	public void remove( Vector<Song> songs ) {
		songListing.removeAllElements();
		intable.setcount(0);
		songs.removeAllElements();
		resetIdx();
		fireTableDataChanged();
	}

	public ArrayList<Song> filter(String searchString) {
		// TODO: Connect the searchText keyPressed handler to update the filter
		// here.
		ArrayList<Song> lst = new ArrayList<Song>();
		
		lst = songList.listTheStrings(searchString);
		return lst;
	}

	public ArrayList<Song> filteralbum(String searchString) {
		// TODO: Connect the searchText keyPressed handler to update the filter
		// here.
		ArrayList<Song> lst = new ArrayList<Song>();
		lst = songalbum.listTheStrings(searchString);
		return lst;
	}

	public ArrayList<Song> filterartist(String searchString) {
		// TODO: Connect the searchText keyPressed handler to update the filter
		// here.
		ArrayList<Song> lst = new ArrayList<Song>();
		lst = songartist.listTheStrings(searchString);
		return lst;
	}

	public void resetIdx() {
		songIteratorIdx = -1;
		currentSong = null;
		songIterator = songListing.iterator();
	}

	// Gets the song at the currently visible index
	public Song get(int idx) {
		if (songIteratorIdx == idx)
			return currentSong;

		if (songIteratorIdx > idx) {
			resetIdx();
		}
		while (songIteratorIdx < idx && songIterator.hasNext()) {
			currentSong = songIterator.next();
			songIteratorIdx++;
		}
		return currentSong;
	}

	public void setnum()
	{
		currentSong.setNumOfTimesPlayed();
		
	}
	
	@Override
	public int getColumnCount() {
		// Title, Album, Artist, Duration, rating, numOfTimesPlayed
		return 6;
	}

	public int getRowCount() {
		// TODO: Changes if you've filtered the list
		// return songListing.size();

		return (intable.getcount());
	}
	public static int getselectedindex()
	{
		return selectedindex;
	}
	public void setselectedindex(int n)
	{
		selectedindex = n;
	}
	@Override
	public Object getValueAt(int row, int col) {
		// TODO: Get the appropriate row
		Song song = get(row);
		if (song == null)
			return null;

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
		case 5 :
			return song.getNumOfTimesPlayed();
		//case 6:
		//	return song.getgenre();	
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
		case 5 :
			return "Times Played";
		//case 6:
		//	return "Genre";
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
	
	public class PlayedTimesComparator implements Comparator<Song> {
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

	public class UserRatingComparator implements Comparator<Song> {
		@Override
		public int compare(Song arg0, Song arg1) {
			// TODO Auto-generated method stub
			return arg1.getrating() - arg0.getrating();
		}
	}
	
	public void showAll() {
		// TODO Auto-generated method stub
		JamPlayer.libraryModel.remove(JamPlayer.songs);
		JamPlayer.libraryModel.add1(backupSongListing);
		fireTableDataChanged();
		JamPlayer.currentIdx = (JamPlayer.songs.indexOf(JamPlayer.song));
		if (JamPlayer.currentIdx > 0)
			JamPlayer.pPanel.previousSong = JamPlayer.libraryModel.get(JamPlayer.currentIdx - 1);
		JamPlayer.pPanel.nextSong = JamPlayer.libraryModel
				.get(JamPlayer.currentIdx + 1);
	}

	
	public void showRecentPlayed() {
		// TODO Auto-generated method stub
		JamPlayer.libraryModel.remove(JamPlayer.songs);
			JamPlayer.songs.addAll(recentlyPlayed);
		JamPlayer.libraryModel.add1(JamPlayer.songs);
		System.out.println("Required:" + songListing);
		fireTableDataChanged();
		JamPlayer.currentIdx = (JamPlayer.songs
				.indexOf(JamPlayer.song));
		if (JamPlayer.currentIdx > 0)
			JamPlayer.pPanel.previousSong = JamPlayer.libraryModel
					.get(JamPlayer.currentIdx - 1);
		JamPlayer.pPanel.nextSong = JamPlayer.libraryModel
				.get(JamPlayer.currentIdx + 1);
	}
}