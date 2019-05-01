package iitm.cs.nlp.spellcheck;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Scanner;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;
import org.apache.commons.codec.EncoderException;
import org.apache.commons.codec.language.Metaphone;

public class SpellChecker
{
	public static int k = 3;
	public static int numOfSuggestions = 10;
	public static int numOfFiles = 45;
	static Metaphone metaphone = new Metaphone();
	public static Hashtable<String, ArrayList<String>> homophones;
	public static ArrayList<String> validWords = new ArrayList<String>();
	public static BKTree tree;

	private static void buildHomophones() throws IOException, EncoderException
	{
		BufferedReader reader = new BufferedReader(new FileReader("validwords.txt"));
		homophones = new Hashtable<String, ArrayList<String>>();
		String word;
		String encryption;

		while ((word = reader.readLine()) != null)
		{
			encryption = metaphone.encode(word);
			if (homophones.containsKey(encryption))
			{
				homophones.get(encryption).add(word);
			}
			else
			{
				ArrayList<String> temp = new ArrayList<String>();
				temp.add(word);
				homophones.put(encryption, temp);
			}
		}

		reader.close();
		FileOutputStream fos = new FileOutputStream("homophones.tmp");
		ObjectOutputStream oos = new ObjectOutputStream(fos);

		oos.writeObject(homophones);
		oos.close();

	}

	public static void buildTree(BKTree tree) throws IOException
	{
		BufferedReader reader = new BufferedReader(new FileReader("validwords.txt"));
		String word = null;
		while ((word = reader.readLine()) != null)
		{
			tree.addWord(word);
			validWords.add(word);
		}

		reader.close();
	}

	public static ArrayList<String> removeDups(ArrayList<String> l)
	{
		ArrayList<String> newList = new ArrayList<String>();

		for (String str : l)
		{
			if (!newList.contains(str))
			{
				newList.add(str);
			}
		}
		return newList;
	}

	public static void doWordSpellCheck() throws IOException, EncoderException, ClassNotFoundException
	{
		// FindPriors.CalculateNorvigPriors();
		FileInputStream fis = new FileInputStream("norvig_priors_map.tmp");
		ObjectInputStream ois = new ObjectInputStream(fis);

		FindPriors.norvigWordList = (Hashtable<String, Long>) ois.readObject();

		BufferedReader reader = new BufferedReader(new FileReader("incorrect_words.txt"));
		String word = null;
		int threshold = 2;

		while ((word = reader.readLine()) != null)
		{
			// Get edit distance candidates
			ArrayList<String> suggestions = tree.searchCandidates(word, threshold);

			// Get homonyms
			String encryption = metaphone.encode(word);
			ArrayList<String> homonyms = homophones.get(encryption);

			if (homonyms != null)
			{
				suggestions.addAll(homonyms);
			}

			suggestions = removeDups(suggestions);

			// Calculate scores
			ArrayList<EditdistAndProb> candidates = new ArrayList<EditdistAndProb>();

			for (String candidate : suggestions)
			{
				candidates.add(DamerauLevenshteinDistance.distance(word, candidate));
			}

			// Multiply with priors and do add-one smoothing

			for (EditdistAndProb candidate : candidates)
			{
				String w = candidate.word;
				if (FindPriors.norvigWordList.containsKey(w))
				{
					// System.out.println(w + " : " + candidate.prob + " " +
					// FindPriors.norvigWordList.get(w));
					candidate.prob *= ((float) (1 + FindPriors.norvigWordList.get(w)));
				}

				else
				{
					candidate.prob *= (1);
				}
			}

			// Sort and suggest candidates
			Collections.sort(candidates, new Comparator<EditdistAndProb>()
			{
				@Override
				public int compare(EditdistAndProb arg0, EditdistAndProb arg1)
				{
					if (arg0.prob >= arg1.prob)
					{
						return 0;
					}

					else
					{
						return 1;
					}
				}
			});

			// Print the suggestions
			System.out.print(word + " -> ");
			for (EditdistAndProb candidate : candidates.subList(0, Math.min(numOfSuggestions, candidates.size())))
			{
				System.out.format("<" + candidate.word + ", " + candidate.distance + ", " + candidate.prob + "> ");
			}
			System.out.println();
		}

		reader.close();
	}

	public static void doSentenceSpellCheck() throws IOException, ClassNotFoundException, EncoderException
	{
		BufferedReader reader = new BufferedReader(new FileReader("phrases.txt"));

		String phrase = null;
		while ((phrase = reader.readLine()) != null)
		{
			System.out.println("Calculating scores");
			CalculateScore.findProbability(phrase);
		}

	}

	@SuppressWarnings({ "static-access", "unchecked" })
	public static void main(String[] args) throws IOException, ParserConfigurationException, SAXException,
			EncoderException, ClassNotFoundException
	{

		// Preprocess.removeStopWords();

		FileInputStream fis;
		ObjectInputStream ois;

		tree = new BKTree();
		buildTree(tree);
		System.out.println("BK tree built");

		FindPriors.CalculatePriors();
		fis = new FileInputStream("priors_map.tmp");
		ois = new ObjectInputStream(fis);
		FindPriors.wordList = (Hashtable<String, Long>) ois.readObject();
		System.out.println("Priors calculated with size of hashtable = " + FindPriors.wordList.size());
		System.out.println("Priors calculated");

		// buildHomophones();
		fis = new FileInputStream("homophones.tmp");
		ois = new ObjectInputStream(fis);
		homophones = (Hashtable<String, ArrayList<String>>) ois.readObject();
		System.out.println("Homophones built");
		ois.close();

		Matrices.buildMatrices();
		System.out.println("Matrices built");

		// doWordSpellCheck();

		System.out.println("Context loading..");

		Context.findContext();

		// fis = new FileInputStream("context.tmp");
		// ois = new ObjectInputStream(fis);
		// Context.dataSet = (HashMap<String, Word>) ois.readObject();
		//
		// ois.close();

		System.out.println(Context.dataSet.size());
		System.out.println("Context found");

		doSentenceSpellCheck();

	}
}
