package iitm.apl.player;

import java.util.ArrayList;
import java.util.Vector;

public class KnapSack {
	// Values correspond to ratings of the songs
	// weights correspond to times of the songs
	public Vector<Song> knap ( ArrayList<Integer> values, ArrayList<Integer> weights, int n, int W,Vector<Song>songlist ) {
		int[][] V = new int[n+1 ][W + 1];
		int[][] Keep = new int[n +1][W + 1];
		Vector<Song> songs = new Vector<Song>();
		for ( int i = 0; i <= W; i++ ) {
			V[0][i] = 0;
			Keep[0][i]=0;
		}
		
		for ( int i = 1; i <=n; i++ ) {
			for ( int j = 0; j <= W; j++ ) {
				if ( weights.get(i-1) <= j ) {
					V[i][j] = max ( V[i - 1][j], values.get(i-1) + V[i - 1][j - weights.get(i-1)] );
					if(V[i][j]==V[i-1][j])
					{
						Keep[i][j]=0;
					}
					else
						{
						Keep[i][j]=1;
						}
				}
				else { 
					V[i][j] = V[i - 1][j]; 
					Keep[i][j]=0;
				}
			}
		}
		int i,k=W;
		for(i=n;i>=1;i--)
		{
			if(Keep[i][k]==1)
			{
				//add ith song to list
				songs.add(songlist.get(i-1));
			
			k = k - weights.get(i-1);
			}
		}
		//return V[n][W];
		//System.out.println(V[n][W]);
		//System.out.println(songs);
		return songs;
		
	}
	
	public int max ( int a, int b ) {
		if ( a > b ) {
			return a;
		}
		else {
			return b;
		}
	}
}