package iitm.cs.nlp.spellcheck;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

public class Context
{
	static HashMap<String, Integer> trigrams = new HashMap<String, Integer>();
	static HashMap<String, Integer> bigrams = new HashMap<String, Integer>();
	static HashMap<String, Word> dataSet = new HashMap<String, Word>();
	static String[] stopWords = { "a", "able", "about", "across", "after", "all", "almost", "also", "am", "among",
			"an", "and", "any", "are", "as", "at", "be", "because", "been", "but", "by", "can", "cannot", "could",
			"dear", "did", "do", "does", "either", "else", "ever", "every", "for", "from", "get", "got", "had", "has",
			"have", "he", "her", "hers", "him", "his", "how", "however", "i", "if", "in", "into", "is", "it", "its",
			"just", "least", "let", "like", "likely", "may", "me", "might", "most", "must", "my", "neither", "no",
			"nor", "not", "of", "off", "often", "on", "only", "or", "other", "our", "own", "rather", "said", "say",
			"says", "she", "should", "since", "so", "some", "than", "that", "the", "their", "them", "then", "there",
			"these", "they", "this", "tis", "to", "too", "twas", "us", "wants", "was", "we", "were", "what", "when",
			"where", "which", "while", "who", "whom", "why", "will", "with", "would", "yet", "you", "your" };

	public static void findContext() throws IOException, ClassNotFoundException
	{
		int k = SpellChecker.k;
		ArrayList<String> stops = new ArrayList<String>(Arrays.asList(stopWords));
		Scanner in = new Scanner(new FileInputStream("reuter_preprocessed.txt"));

		String str;
		ArrayList<String> window = new ArrayList<String>();
		Word word = null;

		// Getting the initial window
		for (int i = 0; (i < k && in.hasNext()); i++)
		{
			str = in.next();
			if (stops.contains(str))
			{
				i--;
				continue;
			}

			window.add(str);
			word = new Word(str);

			if (!dataSet.containsKey(str))
			{
				dataSet.put(str, word);
			}

			word.count++;

			for (String contextWord : window)
			{
				if (!word.contextFeatures.containsKey(contextWord))
				{
					word.contextFeatures.put(contextWord, 1);
				}
				else
				{
					word.contextFeatures.put(contextWord, word.contextFeatures.get(contextWord) + 1);
				}
			}

		}

		for (int i = 0; (i <= k && in.hasNext()); i++)
		{
			str = in.next();
			if (stops.contains(str))
			{
				i--;
				continue;
			}
			window.add(str);
		}

		String nextStr;

		while (in.hasNext())
		{
			nextStr = in.next();
			if (stops.contains(nextStr))
			{
				continue;
			}

			str = window.get(k);

			if (!dataSet.containsKey(str))
			{
				word = new Word(str);
				dataSet.put(str, word);
			}
			else
			{
				word = dataSet.get(str);
			}

			word.count++;

			for (String contextWord : window)
			{
				if (!word.contextFeatures.containsKey(contextWord))
				{
					word.contextFeatures.put(contextWord, 1);
				}
				else
				{
					word.contextFeatures.put(contextWord, word.contextFeatures.get(contextWord) + 1);
				}
			}

			// // Bigrams and Trigrams in the window
			// String tri_g = "", bi_g = "";
			//
			// for (int i = 0; i < 3; i++)
			// {
			// if (i < 2)
			// {
			// bi_g = bi_g + window.get(i);
			// }
			//
			// tri_g = tri_g + window.get(i);
			// }
			//
			// if (trigrams.containsKey(tri_g))
			// {
			// trigrams.put(tri_g, trigrams.get(tri_g) + 1);
			// }
			//
			// else
			// {
			// trigrams.put(tri_g, 1);
			// }
			//
			// if (bigrams.containsKey(bi_g))
			// {
			// bigrams.put(bi_g, bigrams.get(bi_g) + 1);
			// }
			//
			// else
			// {
			// bigrams.put(bi_g, 1);
			// }

			window.remove(0);
			window.add(nextStr);
		}

		// Getting the final window
		for (int i = k + 1; i < window.size(); i++)
		{
			str = window.get(i);

			if (!dataSet.containsKey(str))
			{
				word = new Word(str);
				dataSet.put(str, word);
			}
			else
			{
				word = dataSet.get(str);
			}

			word.count++;

			for (String contextWord : window)
			{
				if (!word.contextFeatures.containsKey(contextWord))
				{
					word.contextFeatures.put(contextWord, 1);
				}
				else
				{
					word.contextFeatures.put(contextWord, word.contextFeatures.get(contextWord) + 1);
				}
			}

			// // Bigrams and Trigrams in the final window
			// String tri_g = "", bi_g = "";
			//
			// if (i + 3 < window.size())
			// {
			// for (int j = i; j < i + 3; i++)
			// {
			// if (i < 2)
			// {
			// bi_g = bi_g + window.get(i);
			// }
			//
			// tri_g = tri_g + window.get(i);
			// }
			//
			// if (trigrams.containsKey(tri_g))
			// {
			// trigrams.put(tri_g, trigrams.get(tri_g) + 1);
			// }
			//
			// else
			// {
			// trigrams.put(tri_g, 1);
			// }
			// }
			//
			// if (bigrams.containsKey(bi_g))
			// {
			// bigrams.put(bi_g, bigrams.get(bi_g) + 1);
			// }
			//
			// else
			// {
			// bigrams.put(bi_g, 1);
			// }
		}

		// FileOutputStream fos = new FileOutputStream("context.tmp");
		// ObjectOutputStream oos = new ObjectOutputStream(fos);
		//
		// oos.writeObject(dataSet);
		// oos.close();
	}
}
