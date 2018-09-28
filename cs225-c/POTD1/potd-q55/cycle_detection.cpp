#include <iostream>
#include <string>
#include <stack>
#include <queue>
#include <vector>
#include "graph.cpp"

using namespace std;
// TODO: Implement this function

bool isCycleNow(Node * curr, vector<Node*> visited, Node * parent)
{
  visited.push_back(curr);

  vector<Node*>::iterator it;
  for (it = curr->outgoingNeighbors.begin(); it != curr->outgoingNeighbors.end();it++)
  {
    if (!contains(visited,*it))
    {
      if (isCycleNow(*it, visited, curr))
      {
        return true;
      }
    }
    else if (*it != parent)
    {
      return true;
    }
  }
  return false;

}

bool hasCycles(Graph const & g) {

    int V = g.nodes.size();
    vector<Node*> visited;
    vector<Node*> unvisited;


    for(int i = 0; i < V; i++) {
        Node* node = g.nodes[i];
        unvisited.push_back(node);
    }

    for (size_t a = 0; a < g.nodes.size(); a++)
    {
      if (!contains(visited,unvisited[a]))
      {
        if (isCycleNow(unvisited[a], visited, NULL))
        {
          return true;
        }
      }
    }

    return false;
}
