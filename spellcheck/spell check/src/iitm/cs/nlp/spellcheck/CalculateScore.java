package iitm.cs.nlp.spellcheck;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Hashtable;

import org.apache.commons.codec.EncoderException;

public class CalculateScore
{
	static Hashtable<String, Double> scores;

	public static Hashtable<Integer, String> findErrorWords(String line)
	{
		// System.out.println("In finding errors wordlist size = " +
		// FindPriors.wordList.size());
		Hashtable<Integer, String> errorWords = new Hashtable<Integer, String>();

		String[] words = line.split(" ");

		for (int i = 0; i < words.length; i++)
		{
			if (!SpellChecker.validWords.contains(words[i]))
			{
				errorWords.put(i, words[i]);
			}
		}

		return errorWords;
	}

	public static String preprocess(String sentence)
	{
		String ret = "";

		for (int i = 0; i < sentence.length(); i++)
		{
			char c = sentence.charAt(i);
			c = Character.toLowerCase(c);

			if (c >= 'a' && c <= 'z')
			{
				ret += c;
			}

			else if (c == ' ')
			{
				ret += c;
			}

			else if (c == '\'')
			{
				if (sentence.charAt(i + 1) == 's')
				{
					i++;
				}

				else
				{
					ret += c;
				}
			}
		}

		return ret;
	}

	public static void findProbability(String line) throws IOException, ClassNotFoundException, EncoderException
	{
		Hashtable<Integer, String> errorWords = findErrorWords(line);
		System.out.println("Errors : " + errorWords);

		String preprocessed_line = preprocess(line);
		String[] words = preprocessed_line.split(" ");
		int k = SpellChecker.k;

		for (Integer wrongIdx : errorWords.keySet())
		{
			scores = new Hashtable<String, Double>();
			String inCorrectword = words[wrongIdx];
			ArrayList<String> candidates = ConfusionSet.buildConfusionSet(inCorrectword);

			for (String candidate : candidates)
			{
				double score = 0, freq;

				if (FindPriors.wordList.containsKey(candidate))
				{
					freq = FindPriors.wordList.get(candidate);
				}

				else
				{
					freq = 1; // Probability of a word not occurring in corpus
								// : Decide delta??
				}

				if (Context.dataSet.containsKey(candidate))
				{
					for (int i = 0; i < words.length; i++)
					{
						if (i == wrongIdx || (!SpellChecker.validWords.contains(words[i])))
						{
							continue;
						}

						if (Context.dataSet.get(candidate).contextFeatures.containsKey(words[i]))
						{
							System.out.print(words[i] + " "
									+ ((double) Context.dataSet.get(candidate).contextFeatures.get(words[i]) / (freq))
									+ " ");
							if (score != 0)
							{
								score *= ((double) Context.dataSet.get(candidate).contextFeatures.get(words[i]) / (freq));
							}
							else
							{
								score = ((double) Context.dataSet.get(candidate).contextFeatures.get(words[i]) / (freq));
							}
						}

						else
						{
							System.out.print("else: " + words[i] + " ");
							// score *= (1 / (freq)); // Decide delta
						}
					}

					System.out.println();
					scores.put(candidate, score);
				}
				else
				{
					scores.put(candidate, (double) 0);
				}

			}

			Collections.sort(candidates, new Comparator<String>()
			{
				@Override
				public int compare(String arg0, String arg1)
				{
					if (scores.get(arg0) >= scores.get(arg1))
					{
						return 0;
					}

					else
					{
						return 1;
					}
				}
			});

			for (String str : candidates)
			{
				System.out.print(str + ": " + scores.get(str) + " ");
			}

			System.out.println("\n");
		}
	}
}
