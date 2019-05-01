package iitm.cs.nlp.spellcheck;

import java.io.Serializable;
import java.util.HashMap;

public class Word implements Serializable
{
	String word;
	int count;
	ConfusionSet confusionSet;
	HashMap<String, Integer> contextFeatures;

	public Word(String _word)
	{
		word = _word;
		count = 0;
		contextFeatures = new HashMap<String, Integer>();
	}

	public void printDetails()
	{
		System.out.println(word + ": " + count);
		System.out.println(contextFeatures);
	}
}
