# include<iostream>
# include<stdio.h>
# include<limits.h>
# include<string.h>
# include<queue>
using namespace std;
 
// Number of vertices in given graph
#define n 6

bool visited[n];
int i,j=0,k=0;
int set1[n],set2[n]; 
/* Returns true if there is a path from source 's' to sink 't' in
  residual graph. Also fills parent[] to store the path */
bool bfs(int rgraph[n][n], int s, int t, int parent[])
{
    
    
    for(i=0;i<n;i++)
    {
    	visited[i]=0;
    }
 
    
    queue <int> q;
    q.push(s);
    visited[s] = true;
    parent[s] = -1;
 
    
    while (!q.empty())
    {
        int u = q.front();
        q.pop();
 
        for (int v=0; v<n; v++)
        {
            if (visited[v]==0 && rgraph[u][v] > 0)
            {
                q.push(v);
                parent[v] = u;
                visited[v] = 1;
            }
        }
    }
 
    // If we reached sink, return true
    if(visited[t] == 1)
    {
    	return 1;
    }
    else
    {
    	return 0;
    }
}

int ford_fulkerson(int graph[n][n], int s, int t)
{
    int u, v;
 
    // Create a residual graph and fill the residual graph with
    
    int rgraph[n][n]; 
    for (u = 0; u < n; u++)
        for (v = 0; v < n; v++)
             rgraph[u][v] = graph[u][v];
 
    int parent[n];  
 
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
		if(visited[i]==1)
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
 
int main()
{
    
    int graph[n][n] = { {0, 16, 13, 0, 0, 0},
                        {0, 0, 10, 12, 0, 0},
                        {0, 4, 0, 0, 14, 0},
                        {0, 0, 9, 0, 0, 20},
                        {0, 0, 0, 7, 0, 4},
                        {0, 0, 0, 0, 0, 0}
                      };
 
    printf("The maximum flow is %d \n",ford_fulkerson(graph, 0, 5));
 
 	printf("the first set is\n");
 	for(i=0;i<j;i++)
 	{
 		printf("%d ",set1[i]);
 	}
 	printf("\nthe second set is \n");
 	for(i=0;i<k;i++)
 	{
 		printf("%d ",set2[i]);
 	}
 	printf("\n");
    return 0;
}
