package iitm.cs.nlp.spellcheck;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class Preprocess
{
	static String[] stopWords = { "a", "able", "about", "across", "after", "all", "almost", "also", "am", "among",
			"an", "and", "any", "are", "as", "at", "be", "because", "been", "but", "by", "can", "cannot", "could",
			"dear", "did", "do", "does", "either", "else", "ever", "every", "for", "from", "get", "got", "had", "has",
			"have", "he", "her", "hers", "him", "his", "how", "however", "i", "if", "in", "into", "is", "it", "its",
			"just", "least", "let", "like", "likely", "may", "me", "might", "most", "must", "my", "neither", "no",
			"nor", "not", "of", "off", "often", "on", "only", "or", "other", "our", "own", "rather", "said", "say",
			"says", "she", "should", "since", "so", "some", "than", "that", "the", "their", "them", "then", "there",
			"these", "they", "this", "tis", "to", "too", "twas", "us", "wants", "was", "we", "were", "what", "when",
			"where", "which", "while", "who", "whom", "why", "will", "with", "would", "yet", "you", "your" };

	public static void removeStopWords() throws IOException
	{
		Scanner in = new Scanner(new FileInputStream("reuter_preprocessed.txt"));
		String word = null;
		ArrayList<String> stops = new ArrayList<String>(Arrays.asList(stopWords));
		BufferedWriter writer = new BufferedWriter(new FileWriter("final.txt"));
		int count = 10;

		while (in.hasNext())
		{
			if (count == 0)
			{
				writer.write("\n");
				count = 10;
			}

			word = in.next();
			if (stops.contains(word))
			{
				continue;
			}

			count--;
			writer.write(word + " ");
		}

		writer.close();
	}

	public static void preprocess() throws IOException
	{
		FileInputStream fis = new FileInputStream("reuters.txt");
		char current;

		while (fis.available() > 0)
		{
			current = (char) fis.read();
			current = Character.toLowerCase(current);

			if (current >= 'a' && current <= 'z')
			{
				System.out.print(current);
			}

			else
			{
				if (current == '\n')
				{
					System.out.println();
				}

				else if (current == ' ')
				{
					System.out.print(current);
				}

				else if (current == '\'')
				{
					current = (char) fis.read();
					current = Character.toLowerCase(current);

					if (current != 's')
					{
						System.out.print(current);
					}

				}
			}
		}

		fis.close();
	}
}
