// Animal.h
#include <string>
using namespace std;

#ifndef ANIMAL_H
#define ANIMAL_H

class Animal
{
private:
  string type_;
protected:
  string food_;
public:
  Animal();
  Animal(string,string);
  string getType();
  void setType(string);
  string getFood();
  void setFood(string);
  string print();
};

#endif
