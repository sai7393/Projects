package iitm.cs.nlp.spellcheck;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.util.Hashtable;
import java.util.Scanner;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class FindPriors
{

	static Hashtable<String, Long> wordList = new Hashtable<String, Long>();
	static Hashtable<String, Long> norvigWordList = new Hashtable<String, Long>();

	static long totalWords = 0;

	public static long parseLong(String string)
	{
		long freq = 0;
		for (int i = 0; i < string.length(); i++)
		{
			freq = freq * 10 + (string.charAt(i) - '0');
		}
		return freq;
	}

	public static void CalculateNorvigPriors() throws IOException
	{
		BufferedReader reader = new BufferedReader(new FileReader("count_1w.txt"));
		String line = null;

		while ((line = reader.readLine()) != null)
		{
			String[] words = line.split("\t");
			norvigWordList.put(words[0], parseLong(words[1]));
		}

		FileOutputStream fos = new FileOutputStream("norvig_priors_map.tmp");
		ObjectOutputStream oos = new ObjectOutputStream(fos);

		oos.writeObject(norvigWordList);
		oos.close();

		System.out.println(norvigWordList.size());
	}

	public static void CalculatePriors() throws IOException
	{
		BufferedReader reader = new BufferedReader(new FileReader("reuter_preprocessed.txt"));
		String line = null;

		while ((line = reader.readLine()) != null)
		{
			String[] words = line.split(" ");
			for (String word : words)
			{
				totalWords++;
				if (wordList.containsKey(word))
				{
					wordList.put(word, wordList.get(word) + 1);
				}
				else
				{
					wordList.put(word, (long) 1);
				}
			}
		}

		FileOutputStream fos = new FileOutputStream("priors_map.tmp");
		ObjectOutputStream oos = new ObjectOutputStream(fos);

		oos.writeObject(wordList);
		oos.close();

		System.out.println(wordList.size());
	}

	public void ReadXmlFile(int totalSets) throws ParserConfigurationException, SAXException, IOException
	{

		String fileName = "ReutersSubset";
		int subsetNumber = 1;
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc;

		while (subsetNumber <= totalSets)
		{

			File folder = new File(fileName + "/" + Integer.toString(subsetNumber++));

			for (File xmlFile : folder.listFiles())
			{
				doc = dBuilder.parse(xmlFile);

				doc.getDocumentElement().normalize();
				Element eElement;

				NodeList nList = doc.getElementsByTagName("text");

				for (int temp = 0; temp < nList.getLength(); temp++)
				{
					Node nNode = nList.item(temp);
					if (nNode.getNodeType() == Node.ELEMENT_NODE)
					{
						eElement = (Element) nNode;

						String text;
						int numOfItems = eElement.getElementsByTagName("p").getLength();

						for (int idx = 0; idx < numOfItems; idx++)
						{
							text = eElement.getElementsByTagName("p").item(idx).getTextContent();
							System.out.println(text);
						}
					}
				}
			}
		}
	}
}
