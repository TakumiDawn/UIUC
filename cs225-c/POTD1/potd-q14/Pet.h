// Pet.h
#ifndef PET_H
#define PET_H

#include "Animal.h"

class Pet : public Animal
{
private:
  string name_;
  string owner_name_;
public:
  Pet();
  Pet(string type, string food,string name,string on);

  void setFood(string nu_food);
  string getFood();
  void setOwnerName(string nu_on);
  string getOwnerName();
  void setName(string nu_name);
  string getName();
  string print();

};

#endif
