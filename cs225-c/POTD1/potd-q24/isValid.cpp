#include <string>
#include <stack>
#include <stdio.h>
#include <string.h>

using namespace std;

bool isValid(string input) {
  stack<char> st1;
  basic_string<char> t = input;
  basic_string<char> t2;

  char temp1, temp2, temp3, temp;
  int stringsize = 0;
  while (t.size() != 0)
  {
    temp = t.front();
    if (temp == '('|| temp == ')')
    {
      stringsize++;
    }
    if (temp == '['|| temp == ']')
    {
      stringsize++;
    }
    if (temp == '{'|| temp == '}')
    {
      stringsize++;
    }
    t.erase(t.begin());
  }
  int intsize = input.size();
  for (int j = 0; j < intsize; j++)
  {
    temp = input.front();
    if (temp == '('|| temp == ')')
    {
      t2[j] = temp;
    }
    if (temp == '['|| temp == ']')
    {
      t2[j] = temp;
    }
    if (temp == '{'|| temp == '}')
    {
      t2[j] = temp;
    }
    input.erase(input.begin());
  }


  for (int i = 0; i < stringsize; i++)
  {
    char temp = input.front();
    if (temp == '('|| temp == '['||temp == '{')
    {
      st1.push(temp);
    }
    else
    {
      // if (st1.size() == 0)
      // {
      //   return false;
      // }
      switch (temp)
      {
        case ')':
          temp1 = st1.top();
          st1.pop();
          if (temp1=='['||temp1=='{')
          {
            return false;
          }

        case ']':
          temp2 = st1.top();
          st1.pop();
          if (temp2=='('||temp2=='{')
          {
            return false;
          }
        case '}':
          temp3 = st1.top();
          st1.pop();
          if (temp3=='['||temp3=='(')
          {
            return false;
          }

      }

    }
  }

  // while (input.size() != 0)
  // {
  //   temp = input.front();
  //   if (temp == '('|| temp == '['||temp == '{')
  //   {
  //     st1.push(temp);
  //   }
  //   input.erase(input.begin());
  // }
  //


  if (st1.empty())
  {
    return true;
  }
  else
  {
    return false;
  }

}
