package iitm.cs.nlp.spellcheck;

import java.util.Hashtable;

public class DamerauLevenshteinDistance
{

	public static EditdistAndProb distance(String ww1, String cw1)
	{
		boolean flag = false; // If false, take row and col sums to normalise
		int i, j, penalty;
		int id, dd, sd, td, min_d;

		// Put start symbol at the beginning of the word
		String ww = '>' + ww1;
		String cw = '>' + cw1;

		// Initialise transformation costs
		double ip, dp, sp, tp, max_p;
		String bigram;

		int len_ww = ww.length();
		int len_cw = cw.length();

		EditdistAndProb info = new EditdistAndProb();
		info.word = cw1;

		int[][] dist = new int[len_ww][len_cw];
		double[][] prob = new double[len_ww][len_cw];

		// Initialise transformation probability
		dist[0][0] = 0;
		prob[0][0] = 1;

		char prev_cw = '>', prev_ww = '>';
		char curr_cw, curr_ww;

		Hashtable<Character, Integer> hash = Matrices.hash;

		// Calculate values for insertion
		for (i = 1; i < len_ww; i++)
		{
			curr_ww = ww.charAt(i);
			dist[i][0] = i;

			if (flag)
			{
				prob[i][0] = prob[i - 1][0] * (Matrices.insMatrix[hash.get(prev_ww)][hash.get(curr_ww)] + 1)
						/ (Matrices.unigrams.get(prev_ww) + 28);
			}
			else
			{
				prob[i][0] = prob[i - 1][0] * (Matrices.insMatrix[hash.get(prev_ww)][hash.get(curr_ww)] + 1)
						/ (Matrices.insRowSums[hash.get(prev_ww)] + 28);

			}
			prev_ww = curr_ww;
		}

		for (j = 1; j < len_cw; j++)
		{
			curr_cw = cw.charAt(j);
			char[] letters = { prev_cw, curr_cw };
			bigram = new String(letters);

			dist[0][j] = j;

			if (flag)
			{
				prob[0][j] = prob[0][j - 1] * (Matrices.delMatrix[hash.get(prev_cw)][hash.get(curr_cw)] + 1)
						/ (Matrices.bigrams.get(bigram) + 28);
			}
			else
			{
				prob[0][j] = prob[0][j - 1] * (Matrices.delMatrix[hash.get(prev_cw)][hash.get(curr_cw)] + 1)
						/ (Matrices.delRowSums[hash.get(prev_cw)] + 28);

			}
			prev_cw = curr_cw;
		}

		prev_ww = '>';

		for (i = 1; i < len_ww; i++)
		{
			curr_ww = ww.charAt(i);
			prev_cw = '>';

			for (j = 1; j < len_cw; j++)
			{
				curr_cw = cw.charAt(j);

				if (curr_cw == curr_ww)
				{
					penalty = 0;
				}

				else
				{
					penalty = 1;
				}

				// Insertion
				id = dist[i - 1][j] + 1;

				if (flag)
				{
					ip = prob[i - 1][j] * (Matrices.insMatrix[hash.get(prev_ww)][hash.get(curr_cw)] + 1.0)
							/ (Matrices.unigrams.get(prev_ww) + 28);
				}
				else
				{
					ip = prob[i - 1][j] * (Matrices.insMatrix[hash.get(prev_ww)][hash.get(curr_cw)] + 1.0)
							/ (Matrices.insRowSums[hash.get(prev_ww)] + 28);
				}

				// Deletion
				dd = dist[i][j - 1] + 1;

				char[] letters = { prev_cw, curr_cw };
				bigram = new String(letters);

				if (flag)
				{
					dp = prob[i][j - 1] * (Matrices.delMatrix[hash.get(prev_cw)][hash.get(curr_cw)] + 1.0)
							/ (Matrices.bigrams.get(bigram) + 28);
				}
				else
				{
					dp = prob[i][j - 1] * (Matrices.delMatrix[hash.get(prev_cw)][hash.get(curr_cw)] + 1.0)
							/ (Matrices.delRowSums[hash.get(prev_cw)] + 28);

				}
				// Substitution
				sd = dist[i - 1][j - 1] + penalty;

				if (penalty == 1)
				{
					if (flag)
					{
						sp = prob[i - 1][j - 1] * (Matrices.subMatrix[hash.get(curr_ww)][hash.get(curr_cw)] + 1.0)
								/ (Matrices.unigrams.get(curr_cw) + 28);
					}
					else
					{
						sp = prob[i - 1][j - 1] * (Matrices.subMatrix[hash.get(curr_ww)][hash.get(curr_cw)] + 1.0)
								/ (Matrices.subRowSums[hash.get(curr_ww)] + 28);
					}
				}

				else
				{
					sp = prob[i - 1][j - 1];
				}

				if ((curr_ww == prev_cw) && (prev_ww == curr_cw))
				{

					// Transposition
					td = dist[i - 2][j - 2] + 1;

					if (flag)
					{
						tp = prob[i - 2][j - 2] * (Matrices.transMatrix[hash.get(prev_cw)][hash.get(curr_cw)] + 1.0)
								/ (Matrices.bigrams.get(bigram) + 28);
					}
					else
					{
						tp = prob[i - 2][j - 2] * (Matrices.transMatrix[hash.get(prev_cw)][hash.get(curr_cw)] + 1.0)
								/ (Matrices.transRowSums[hash.get(curr_cw)] + 28);
					}

				}

				else
				{
					td = Integer.MAX_VALUE;
					tp = 0;
				}

				min_d = min4(id, dd, sd, td);
				max_p = 0;

				if (id == min_d)
				{
					max_p += ip;
				}

				if (dd == min_d)
				{
					max_p += dp;
				}

				if (sd == min_d)
				{
					max_p += sp;
				}

				if (td == min_d)
				{
					max_p += tp;
				}

				prob[i][j] = max_p;
				dist[i][j] = min_d;

				prev_cw = curr_cw;
			}

			prev_ww = curr_ww;
		}

		info.distance = dist[len_ww - 1][len_cw - 1];
		info.prob = prob[len_ww - 1][len_cw - 1];

		return info;
	}

	public static int dl_distance(String ww, String cw)
	{

		int i, j, penalty;
		int id, dd, sd, td, min_d;

		int len_ww = ww.length();
		int len_cw = cw.length();

		int[][] dist = new int[len_ww + 1][len_cw + 1];

		dist[0][0] = 0;

		for (i = 1; i <= len_ww; i++)
		{
			dist[i][0] = i;
		}

		for (j = 1; j <= len_cw; j++)
		{
			dist[0][j] = j;
		}

		char curr_ww, curr_cw;

		for (i = 1; i <= len_ww; i++)
		{
			curr_ww = ww.charAt(i - 1);

			for (j = 1; j <= len_cw; j++)
			{
				curr_cw = cw.charAt(j - 1);

				if (curr_cw == curr_ww)
				{
					penalty = 0;
				}

				else
				{
					penalty = 1;
				}

				// Insertion
				id = dist[i - 1][j] + 1;

				// Deletion
				dd = dist[i][j - 1] + 1;

				// Substitution
				sd = dist[i - 1][j - 1] + penalty;

				if (((i > 1) && (j > 1)) && (curr_ww == cw.charAt(j - 2)) && (ww.charAt(i - 2) == curr_cw))
				{
					// Transposition
					td = dist[i - 2][j - 2] + 1;
				}

				else
				{
					td = Integer.MAX_VALUE;
				}

				min_d = min4(id, dd, sd, td);
				dist[i][j] = min_d;

			}
		}

		return dist[len_ww][len_cw];
	}

	private static void print_int_matrix(int[][] mat)
	{
		for (int i = 0; i < mat.length; i++)
		{
			for (int j = 0; j < mat[0].length; j++)
			{
				System.out.print(mat[i][j] + "\t");
			}
			System.out.println();
		}
	}

	private static void print_matrix(double[][] mat)
	{
		for (int i = 0; i < mat.length; i++)
		{
			for (int j = 0; j < mat[0].length; j++)
			{
				System.out.print(mat[i][j] + "\t");
			}
			System.out.println();
		}
	}

	public static int min2i(int i, int j)
	{
		return i <= j ? i : j;
	}

	public static int min4(int i, int j, int k, int l)
	{
		return min2i(min2i(i, j), min2i(k, l));
	}

}
