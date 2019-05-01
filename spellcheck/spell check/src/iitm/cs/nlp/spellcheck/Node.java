package iitm.cs.nlp.spellcheck;

import java.util.ArrayList;
import java.util.HashMap;

public class Node
{

	String word;
	HashMap<Integer, Node> children;

	public Node(String word)
	{
		this.word = word;
		children = new HashMap<Integer, Node>();
	}

	public void addWord(String newWord)
	{

		int d = DamerauLevenshteinDistance.dl_distance(this.word, newWord);
		Node child = children.get(d);

		if (child != null)
		{
			child.addWord(newWord);
		}

		else
		{
			children.put(d, new Node(newWord));
		}

	}

	public void searchCandidates(String word, int editThreshold, ArrayList<String> candidates)
	{

		int dist_val;
		int d = DamerauLevenshteinDistance.dl_distance(word, this.word);

		if (d <= editThreshold)
		{
			candidates.add(this.word);
		}

		for (dist_val = d - editThreshold; dist_val <= d + editThreshold; dist_val++)
		{

			Node child = children.get(dist_val);
			if (child != null)
			{
				child.searchCandidates(word, editThreshold, candidates);
			}

		}

	}
}
