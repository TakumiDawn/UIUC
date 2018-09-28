#include "Pattern.h"
#include <string>
#include <iostream>
#include <vector>
#include <map>
using namespace std;

bool wordPattern(std::string pattern, std::string str)
{
  vector<char> patterns;
  vector<string> words;

  for (auto it = pattern.begin(); it != pattern.end(); it++)
  {
    patterns.push_back(*it);
  }
  size_t i = 0;
  string tempword = "";
  while (i < str.length())
  {
    tempword = "";
    if(str[i] != ' ')
    {
      tempword += str.at(i);
    }
    else
    {
      words.push_back(tempword);
      tempword = "";
    }
    i++;
  }
  words.push_back(tempword);

  bool flag = true;
  map<char, string> mymap;
  for (size_t x = 0; x < patterns.size(); x++)
  {
    auto it2 = mymap.find(patterns.at(x));
    if (it2 == mymap.end())
      mymap.insert(it2, pair<char, string>(patterns.at(x), words[x]));
    else
    {
      if (mymap.find(patterns.at(x))->second != words.at(x))
      {
        flag = false;
      }
    }
  }
  return flag;
}
