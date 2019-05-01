package iitm.apl.Minesweeper;
/**
 * Minesweeper board class
 * Adapted from http://introcs.cs.princeton.edu/java/14array/
 * @author Arun Tejasvi Chaganty <arunchaganty@gmail.com>
 */

public class Board {
	public final int M;
	public final int N;
	public final int mineCount;
	private final boolean[][] bombs;
	
	/**
	 * Creates an MxN minesweeper game where each cell is a bomb with
	 * probability p. Prints out the MxN game and the neighboring bomb counts.
	 * @param M - Row length
	 * @param N - Col length
	 * @param p - mine probability
	 */
	public Board(int M, int N, double p) {
		this.M = M;
		this.N = N;
		// game grid is [1..M][1..N], border is used to handle boundary cases
		int mineCount = 0;
		bombs = new boolean[M][N];
		for (int i = 0; i < M; i++)
		{
			for (int j = 0; j < N; j++)
			{
				boolean isMine = (Math.random() < p);
				bombs[i][j] = isMine;
				mineCount += (isMine) ? 1 : 0;
			}
		}
		this.mineCount = mineCount;
	
	}
	
	/**
	 *  Print mine positions
	 */
	public String toString()
	{		
		String pos = "";
		for (int i = 0; i < M; i++) {
			for (int j = 0; j < N; j++)
				if (bombs[i][j])
					pos += "* ";
				else
					pos += ". ";
			pos += "\n";			
		}
		return pos;
	}
	
	/**
	 * Get the number of bombs adjacent to @i, @j
	 * @param i - row index
	 * @param j - col index
	 * @return - the number of bombs adjacent to @i, @j
	 */
	public int getAdjacentBombs( int i, int j )
	{
		int bombCount = 0;
		if( bombs[i][j] ) return -1;
		
		// (ii, jj) indexes neighboring cells
		for (int ii = i - 1; ii <= i + 1; ii++)
			for (int jj = j - 1; jj <= j + 1; jj++)
				if (ii > -1 && ii < M && jj > -1 && jj < N && bombs[ii][jj])
					bombCount++;
		
		return bombCount;
	}
}
