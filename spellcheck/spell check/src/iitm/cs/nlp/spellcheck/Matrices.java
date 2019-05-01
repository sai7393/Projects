package iitm.cs.nlp.spellcheck;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Hashtable;

public class Matrices
{

	static double delMatrix[][] = new double[28][28];
	static double insMatrix[][] = new double[28][28];
	static double subMatrix[][] = new double[28][28];
	static double transMatrix[][] = new double[28][28];

	static double delRowSums[] = new double[28];
	static double insRowSums[] = new double[28];
	static double subRowSums[] = new double[28];
	static double transRowSums[] = new double[28];

	static Hashtable<Character, Long> unigrams = new Hashtable<Character, Long>();
	static Hashtable<String, Long> bigrams = new Hashtable<String, Long>();
	static Hashtable<Character, Integer> hash = new Hashtable<Character, Integer>();

	public static void findNormalisingTerms()
	{
		for (int i = 0; i < 28; i++)
		{
			for (int j = 0; j < 28; j++)
			{
				delRowSums[i] += delMatrix[i][j];
				insRowSums[i] += insMatrix[i][j];
				subRowSums[i] += subMatrix[i][j];
				transRowSums[i] += transMatrix[i][j];
			}
		}
	}

	@SuppressWarnings("unchecked")
	public static void buildMatrices() throws IOException, ClassNotFoundException
	{

		createCharacterHash();

		// findUnigramCounts();
		// findBigramCounts();
		//
		// // Include all bigrams possible
		// String s;
		//
		// for (Character c1 : hash.keySet())
		// {
		// if (!unigrams.containsKey(c1))
		// {
		// unigrams.put(c1, (long) 1);
		// }
		//
		// for (Character c2 : hash.keySet())
		// {
		// s = c1 + c2.toString();
		// if (!bigrams.containsKey(s))
		// {
		// bigrams.put(s, (long) 1);
		// }
		//
		// }
		// }
		// FileOutputStream fos = new FileOutputStream("unigram.tmp");
		// ObjectOutputStream oos = new ObjectOutputStream(fos);
		//
		// oos.writeObject(unigrams);
		//
		// fos = new FileOutputStream("bigram.tmp");
		// oos = new ObjectOutputStream(fos);
		//
		// oos.writeObject(bigrams);
		// oos.close();
		//
		// BufferedReader reader = new BufferedReader(new
		// FileReader("matrices.txt"));
		// String word = null;
		//
		// while ((word = reader.readLine()) != null)
		// {
		// String[] op_and_freq = word.split("\t");
		//
		// int freq = Integer.parseInt(op_and_freq[1]);
		//
		// if (not_all_are_chars(op_and_freq[0]))
		// {
		// continue;
		// }
		//
		// String[] chars = op_and_freq[0].split("\\|");
		//
		// int w0, w1, c0, c1;
		// int len_a = chars[0].length(), len_b = chars[1].length();
		//
		// w0 = hash.get(chars[0].charAt(0));
		// w1 = hash.get(chars[0].charAt(len_a - 1));
		//
		// c0 = hash.get(chars[1].charAt(0));
		// c1 = hash.get(chars[1].charAt(len_b - 1));
		//
		// if (len_a == 1)
		// {
		// // substitution
		// if (chars[1].length() == 1)
		// {
		// subMatrix[w0][c0] = freq;
		// }
		//
		// // deletion
		// else
		// {
		// delMatrix[w0][c1] = freq;
		// }
		// }
		//
		// else
		// {
		// // insertion
		// if (len_b == 1)
		// {
		// insMatrix[w0][w1] = freq;
		// }
		//
		// // transposition
		// else
		// {
		// transMatrix[c0][c1] = freq;
		// }
		// }
		//
		// }
		//
		// reader.close();
		//
		// fos = new FileOutputStream("del.tmp");
		// oos = new ObjectOutputStream(fos);
		//
		// oos.writeObject(delMatrix);
		//
		// fos = new FileOutputStream("ins.tmp");
		// oos = new ObjectOutputStream(fos);
		// oos.writeObject(insMatrix);
		//
		// fos = new FileOutputStream("sub.tmp");
		// oos = new ObjectOutputStream(fos);
		// oos.writeObject(subMatrix);
		//
		// fos = new FileOutputStream("trans.tmp");
		// oos = new ObjectOutputStream(fos);
		// oos.writeObject(transMatrix);
		//
		// oos.close();

		FileInputStream fis = new FileInputStream("del.tmp");
		ObjectInputStream ois = new ObjectInputStream(fis);

		delMatrix = (double[][]) ois.readObject();

		fis = new FileInputStream("ins.tmp");
		ois = new ObjectInputStream(fis);

		insMatrix = (double[][]) ois.readObject();

		fis = new FileInputStream("sub.tmp");
		ois = new ObjectInputStream(fis);

		subMatrix = (double[][]) ois.readObject();

		fis = new FileInputStream("trans.tmp");
		ois = new ObjectInputStream(fis);

		transMatrix = (double[][]) ois.readObject();

		fis = new FileInputStream("bigram.tmp");
		ois = new ObjectInputStream(fis);

		bigrams = (Hashtable<String, Long>) ois.readObject();

		fis = new FileInputStream("unigram.tmp");
		ois = new ObjectInputStream(fis);

		unigrams = (Hashtable<Character, Long>) ois.readObject();

		ois.close();

		findNormalisingTerms();
	}

	private static void createCharacterHash()
	{
		// map values from a to z
		for (int i = 0; i < 26; i++)
		{
			hash.put((char) ('a' + i), i);
		}

		// map start character to 26
		hash.put('>', 26);
		hash.put('\'', 27);
	}

	private static void findUnigramCounts() throws IOException
	{

		BufferedReader reader = new BufferedReader(new FileReader("count_1w.txt"));
		String line = null;
		long words = 0;

		while ((line = reader.readLine()) != null)
		{
			words++;
			String word = null;
			long freq = 0;

			word = line.split("\t")[0];
			freq = parseLong((line.split("\t"))[1]);
			char[] bigram_chars = { '>', word.charAt(0) };

			String bigram = new String(bigram_chars);

			if (bigrams.containsKey(bigram))
			{
				bigrams.put(bigram, bigrams.get(bigram) + freq);
			}

			else
			{
				bigrams.put(bigram, freq);
			}

			for (int i = 0; i < word.length(); i++)
			{

				char c = word.charAt(i);

				if (unigrams.containsKey(c))
				{
					unigrams.put(c, unigrams.get(c) + freq);
				}

				else
				{
					unigrams.put(c, freq);
				}
			}
		}

		unigrams.put('>', words);
		reader.close();
	}

	public static long parseLong(String string)
	{
		long freq = 0;
		for (int i = 0; i < string.length(); i++)
		{
			freq = freq * 10 + (string.charAt(i) - '0');
		}
		return freq;
	}

	private static void findBigramCounts() throws IOException
	{

		BufferedReader reader = new BufferedReader(new FileReader("count_2l.txt"));
		String line = null;
		String bigram = "";
		long freq;

		while ((line = reader.readLine()) != null)
		{

			bigram = line.split("\t")[0];
			freq = parseLong(line.split("\t")[1]);

			if (bigrams.containsKey(bigram))
			{
				bigrams.put(bigram, bigrams.get(bigram) + freq);
			}

			else
			{
				bigrams.put(bigram, freq);
			}
		}

		reader.close();
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

	private static boolean not_all_are_chars(String str)
	{
		for (int i = 0; i < str.length(); i++)
		{
			char c = str.charAt(i);
			if (!((c >= 'a' && c <= 'z') || (c == '|') || (c == '<') || (c == '\'')))
			{
				return true;
			}
		}

		return false;
	}
}
