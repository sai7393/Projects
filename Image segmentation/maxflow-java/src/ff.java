import java.util.*;


public class ff {
	
	 
	private static final int INT_MAX = 100000;

	// Number of vertices in given graph
	static int n=10,i,j=0,k=0;

	static boolean[] visited = new boolean[n];
	static int[] set1 = new int[n];
	static int[] set2 = new int[n];
	/* Returns true if there is a path from source 's' to sink 't' in
	  residual graph. Also fills parent[] to store the path */
	static boolean bfs(int[][] rgraph, int s, int t, int[] parent)
	{
	    
	    
	    for(i=0;i<n;i++)
	    {
	    	visited[i]=false;
	    }
	 
	    
	    Queue q = new LinkedList();
	    q.add(s);
	    visited[s] = true;
	    parent[s] = -1;
	 
	    
	    while (!q.isEmpty())
	    {
	        int u = (int) q.peek();
	        q.remove();
	 
	        for (int v=0; v<n; v++)
	        {
	            if (visited[v]==false && rgraph[u][v] > 0)
	            {
	                q.add(v);
	                parent[v] = u;
	                visited[v] = true;
	            }
	        }
	    }
	 
	    // If we reached sink, return true
	    if(visited[t] == true)
	    {
	    	return true;
	    }
	    else
	    {
	    	return false;
	    }
	}

	public static int ford_fulkerson(int[][] graph, int s, int t)
	{
	    int u, v;
	    n = graph.length;
	    // Create a residual graph and fill the residual graph with
	    
	    int[][] rgraph = new int[n][n]; 
	    for (u = 0; u < n; u++)
	        for (v = 0; v < n; v++)
	             rgraph[u][v] = graph[u][v];
	 
	    int[] parent = new int[n];  
	 
	    int max_flow = 0;  
	 
	    // Augment the flow while there is path from source to sink
	    while (bfs(rgraph, s, t, parent))
	    {
	        
	        //find the maximum flow
	       
	        int path_flow = INT_MAX;
	        for (v=t; v!=s; v=parent[v])
	        {
	            u = parent[v];
	            if(rgraph[u][v] < path_flow)
	            {
	            	path_flow = rgraph[u][v];
	            }
	        }
	 
	        // update residual capacities of the edges and reverse edges
	       
	        for (v=t; v != s; v=parent[v])
	        {
	            u = parent[v];
	            rgraph[u][v] -= path_flow;
	            rgraph[v][u] += path_flow;
	        }
	 
	        // Add path flow to overall flow
	        max_flow += path_flow;
	    }

		
		bfs(rgraph, s, t, parent);
		for(i=0;i<n;i++)
		{
			if(visited[i]==true)
			{
				set1[j] = i;
				j++;
			}
			else
			{
				set2[k] = i;
				k++;
			}
		}
		
	return max_flow;
	}
	 
	public static void main(String[] args)
	{
	    
	    int[][] graph = { {0, 16, 13, 0, 0, 0},
	                        {0, 0, 10, 12, 0, 0},
	                        {0, 4, 0, 0, 14, 0},
	                        {0, 0, 9, 0, 0, 20},
	                        {0, 0, 0, 7, 0, 4},
	                        {0, 0, 0, 0, 0, 0}
	                      };
	 
	    System.out.println("The maximum flow is " + ford_fulkerson(graph, 0, 5));
	 
	 	System.out.println("the first set is");
	 	for(i=0;i<j;i++)
	 	{
	 		System.out.print(set1[i]+ "  ");
	 	}
	 	System.out.println();
	 	System.out.println("The second set is");
	 	for(i=0;i<k;i++)
	 	{
	 		System.out.print(set2[i]+ "  ");
	 	}
	 	
	}
	
	
	
}