
vector<string> NoProblem(int start, vector<int> created, vector<int> needed)
{
  vector<string> result;

  int sum = start;
  for (size_t i = 0; i < needed.size(); i++)
  {
    if (needed[i] <= sum)
    {
      result.push_back("No problem! :D");
      sum -= needed[i];
    }
    else
    {
      result.push_back("No problem. :(");
    }
    sum += created[i];
  }
  return result;

}
