package iitm.cs.nlp.spellcheck;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.codec.EncoderException;

public class ConfusionSet
{
	public static List<EditdistAndProb> sortAndGiveSuggestions(String word, ArrayList<String> suggestions, int n)
	{
		// Calculate scores
		ArrayList<EditdistAndProb> candidates = new ArrayList<EditdistAndProb>();

		if (suggestions != null)
		{
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
		}

		return candidates.subList(0, Math.min(n, candidates.size()));
	}

	public static ArrayList<String> buildConfusionSet(String word) throws IOException, ClassNotFoundException,
			EncoderException
	{

		ArrayList<EditdistAndProb> targetWords = new ArrayList<EditdistAndProb>();
		int threshold = 1;
		BKTree tree = SpellChecker.tree;

		// Get edit distance candidates
		ArrayList<String> suggestions = tree.searchCandidates(word, threshold);

		// Get homonyms
		String encryption = SpellChecker.metaphone.encode(word);
		ArrayList<String> homonyms = SpellChecker.homophones.get(encryption);

		if (homonyms != null)
		{
			for (String candidate : suggestions)
			{
				if (!suggestions.contains(candidate))
				{
					suggestions.add(candidate);
				}
			}
		}

		targetWords.addAll(sortAndGiveSuggestions(word, suggestions, 5));

		// targetWords.addAll(sortAndGiveSuggestions(word, homonyms, 4));

		ArrayList<String> confusedWords = new ArrayList<String>();
		for (EditdistAndProb confWord : targetWords)
		{
			if (!confusedWords.contains(confWord.word))
			{
				confusedWords.add(confWord.word);
			}
		}

		return confusedWords;
	}
}