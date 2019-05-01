package iitm.apl.player;

import java.lang.String;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Vector;


public class Trie {
	private static final int ALPH = 26;
    private static final int BUFSIZ = 1024;
    private Trie[]  myLinks;
    private boolean myIsWord;
    private int indexCount = 1;
	private int index;
    String globalString = null;
	private Vector<Song> songs;
	private int count;
	
	public Trie() {
		myLinks = new Trie[ ALPH ];
		myIsWord = false;
		songs = new Vector<Song>();
		count=0;
	}

    /**
     * Add a string to the trie
     *
     * @param s The string added to Trie
     */
	    
    public void addString ( Song song ) {
		//Trie t = this;
		int k;
		String s = song.getTitle();
		String[] words = new String[10];
		words = s.split( " " );
		System.out.println ( words );
		int length = words.length;
		for ( int i = length - 1; i >= 0; i-- ) {
			Trie t = this;
			if ( i == length - 1 ) {
				s = words[i];
			}
			else {
				s = words[i].concat( s );
			}
			int limit = s.length();
			for( k = 0; k < limit; k++ ) {
				if ( (s.charAt(k) >= 65 && s.charAt(k) <= 90) || ((s.charAt(k) >= 97)
						&& s.charAt(k) <= 122 )) {
				    int index = (int)s.charAt( k );
	
				    if ( index >= 65 && index <= 90 ) {
				    	index += 32;
				    }
				    index -= 97;
				    if ( t.myLinks[ index ] == null ) {
				    	t.myLinks[ index ] = new Trie();
				    }
				    t = t.myLinks[ index ];
				}
				else {
					continue;
				}
			}
		
		t.myIsWord = true;
		t.songs.add(song);
		
		}
		this.count++;
    }
    public void addString1 ( Song song ) {
		int k;
		String s = song.getAlbum();
		String[] words = new String[10];
		words = s.split( " " );
		int length = words.length;
		for ( int i = length - 1; i >= 0; i-- ) {
			Trie t = this;
			if ( i == length - 1 ) {
				s = words[i];
			}
			else {
				s = words[i].concat( s );
			}
			int limit = s.length();
			for( k = 0; k < limit; k++ ) {
				if ( (s.charAt(k) >= 65 && s.charAt(k) <= 90) || ((s.charAt(k) >= 97)
						&& s.charAt(k) <= 122 )) {
				    int index = (int)s.charAt( k );
	
				    if ( index >= 65 && index <= 90 ) {
				    	index += 32;
				    }
				    index -= 97;
				    if ( t.myLinks[ index ] == null ) {
				    	t.myLinks[ index ] = new Trie();
				    }
				    t = t.myLinks[ index ];
				}
				else {
					continue;
				}
			}
		
		t.myIsWord = true;
		t.songs.add(song);
		
		}
		this.count++;
    }
    public void addString2 ( Song song ) {
		int k;
		String s = song.getArtist();
		String[] words = new String[10];
		words = s.split( " " );
		int length = words.length;
		for ( int i = length - 1; i >= 0; i-- ) {
			Trie t = this;
			if ( i == length - 1 ) {
				s = words[i];
			}
			else {
				s = words[i].concat( s );
			}
			int limit = s.length();
			for( k = 0; k < limit; k++ ) {
				if ( (s.charAt(k) >= 65 && s.charAt(k) <= 90) || ((s.charAt(k) >= 97)
						&& s.charAt(k) <= 122 )) {
				    int index = (int)s.charAt( k );
	
				    if ( index >= 65 && index <= 90 ) {
				    	index += 32;
				    }
				    index -= 97;
				    if ( t.myLinks[ index ] == null ) {
				    	t.myLinks[ index ] = new Trie();
				    }
				    t = t.myLinks[ index ];
				}
				else {
					continue;
				}
			}
		
		t.myIsWord = true;
		t.songs.add(song);
		
		}
		this.count++;
    }
    
    /**
     * determine if a word is in the trie (here or below)
     *
     * @param s The string searched for
     * @return true iff s is in trie (rooted here)
     */
    /**
     * @return true iff path from some root to this node is a word
     * 
     */
    
    public boolean isWord() {
    	return myIsWord;
    }

    /**
     * @param ch Character used to index node (find child)
     * @return Trie formed from this by indexing using ch
     */
    
    Trie childAt ( char ch ) {
    	return myLinks[ ch - 'a' ];
    }

    public void setIndex ( Trie t ) {
    	for ( int i = 0; i < 26; i++ ) {
    		if ( t.myLinks[i] != null ) {
	    		if ( t.myLinks[i].myIsWord == true ) {
	    			t.myLinks[i].index = indexCount;
	    			indexCount++;
	    		}
	    		setIndex( t.myLinks[i] );
    		}
    	}
    }
    
    public boolean isWord ( String s ) {
    	Trie t = this;
    	int k;
    	int limit = s.length();
    	for ( k = 0; k < limit; k++ ) {
    		if ( s.charAt( k ) != ' ' && (s.charAt(k) >= 65 && s.charAt(k) <= 90) || (s.charAt(k) >= 97)
					&& s.charAt(k) <= 122 ) {
			    int index = (int)s.charAt( k );

			    if ( index >= 65 && index <= 90 ) {
			    	index += 32;
			    }
			    index -= 97;
			    if ( t.myLinks[ index ] == null) {
			    	return false;
			    }
    		}
    		t = t.myLinks[ index ];
    	}
    	return t.myIsWord;
    }
    
    public ArrayList<Song> listTheStrings ( String s ) {
    	ArrayList<Song> lst = new ArrayList<Song>();
    	Trie t = this;
    	String str = null;
    	int length = s.length();
    	for ( int k = 0; k < length; k++ ) {
    		if ( s.charAt(k) >= 'a' && s.charAt(k) <= 'z' ) {
			    int index = s.charAt( k ) - 'a';
			    if ( t.myLinks[index] != null ) {
			    	t = t.myLinks[index];
			    	if ( str == null ) {
			    		str = Character.toString( s.charAt(k));
			    	}
			    	else {
			    		str = str.concat( Character.toString( s.charAt(k) ));
			    	}
			    }
    		}
    		else if ( s.charAt(k) >= 'A' && s.charAt(k) <= 'Z' ) {
    			int index = s.charAt( k ) - 'A';
			    if ( t.myLinks[index] != null ) {
			    	t = t.myLinks[index];
			    	if ( str == null ) {
			    		str = Character.toString( s.charAt(k));
			    	}
			    	else {
			    		str = str.concat( Character.toString( s.charAt(k) ));
			    	}
			    }
    		}
    		else 
    		{
    			if ( str == null ) {
		    		str = Character.toString( s.charAt(k));
		    	}
		    	else {
		    		str = str.concat( Character.toString( s.charAt(k) ));
		    	}
    			
    		}
    	}
    	globalString = s;
    	
    	
    	if ( str != null && str.equals(s) ) 
    	{
    		if ( t.myIsWord == true ) {
        		lst.addAll(  t.songs );
        	}
    		lst = printStrings ( t, lst );
    	}
    	sortByName ( lst );
    	for ( int i = 0; i < lst.size() - 1; i++ ) {
    		if ( lst.get( i + 1 ).equals( lst.get(i) ) ) {
    			lst.remove( i + 1 );
    		}
    	}
    	System.out.println ( lst );
    	return lst;
    }
    
    public ArrayList<Song> printStrings ( Trie t, ArrayList<Song> lst ) {
    	for ( int i = 0; i < 26; i++ ) {
    		if ( t.myLinks[i] != null ) {
    			globalString = globalString.concat( Character.toString( (char) ('a' + i) ) );
    			if ( t.myLinks[i].myIsWord == true ) {
    				lst.addAll (  t.myLinks[i].songs );
    			}
    		
    			lst = printStrings ( t.myLinks[i], lst );
    			int l = globalString.length();
        		globalString = globalString.substring ( 0, l - 1 );
    		}
    	}
    	return lst;
    }
    
    public static void sortByName ( List<Song> lst ) {
		Collections.sort( lst, new Comparator<Song>() {
			
			public int compare ( Song song1, Song song2 ) {
				return ( song1.getTitle() ).compareTo( song2.getTitle() );
			}
		});
	 } 
    public int getcount()
    {
    	return count;
    }
    public void setcount(int n)
    {
    	count=n;
    }
}
