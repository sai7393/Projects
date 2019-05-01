package iitm.cs.nlp.spellcheck;

import java.util.ArrayList;

public class BKTree
{

	Node root;
	ArrayList<String> candidates;

	public BKTree()
	{
		root = null;
	}

	public void addWord(String word)
	{

		if (root != null)
		{
			root.addWord(word.toLowerCase());
		}

		else
		{
			root = new Node(word.toLowerCase());
		}

	}

	public ArrayList<String> searchCandidates(String word, int threshold)
	{
		candidates = new ArrayList<String>();
		root.searchCandidates(word, threshold, candidates);
		return candidates;
	}

	public void printBKTree(Node root, int dist)
	{

		for (Integer edit : root.children.keySet())
		{
			printBKTree(root.children.get(edit), edit);
		}

		return;
	}
}
