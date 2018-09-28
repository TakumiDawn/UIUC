#include <map>
#include <vector>
#include <fstream>
#include <string>
#include <iostream>
using namespace std;


vector<string> topThree(string filename) {
    string line;
    ifstream infile (filename);
    vector<string> ret;
    map<string,int> mymap;
    if (infile.is_open()) {
        while (getline(infile, line))
        {
          if (mymap.find(line) == mymap.end())
          {
            mymap.insert(pair<string, int>(line, 0));
          }
          else
          {
            auto here = mymap.find(line);
            here->second++;
          }
        }
    }
    infile.close();

    auto maxval = mymap.begin()->second;
    auto maxkey = mymap.begin()->first;
    for (auto it = mymap.begin(); it != mymap.end(); ++it)
    {
      if (it->second > maxval)
      {
        maxval = it->second;
        maxkey = it->first;
      }
    }
    ret.insert(ret.end(), maxkey);
    mymap.erase(mymap.find(maxkey));

    maxval = mymap.begin()->second;
    maxkey = mymap.begin()->first;
    for (auto it = mymap.begin(); it != mymap.end(); ++it)
    {
      if (it->second > maxval)
      {
        maxval = it->second;
        maxkey = it->first;
        //mymap.erase(it);
      }
    }
    ret.insert(ret.end(), maxkey);
    mymap.erase(mymap.find(maxkey));

    maxval = mymap.begin()->second;
    maxkey = mymap.begin()->first;
    for (auto it = mymap.begin(); it != mymap.end(); ++it)
    {
      if (it->second > maxval)
      {
        maxval = it->second;
        maxkey = it->first;
        //mymap.erase(it);
      }
    }
    ret.insert(ret.end(), maxkey);
    mymap.erase(mymap.find(maxkey));

    return ret;
}
