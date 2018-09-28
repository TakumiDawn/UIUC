// Pet.cpp
#include "Pet.h"
using namespace std;


Pet::Pet() : name_("Fluffy"), owner_name_("Cinda") {setType("cat"); setFood("fish");}

Pet::Pet(string type, string food,string name,string on) :  name_(name),owner_name_(on) { setType(type);setFood(food); }
//Pet::Pet(string y, string f, string n,string o):Animal(y,f){ name_=n; owner_name_=o;}

void Pet::setFood(string nu_food) {
    food_ = nu_food;
}

string Pet::getFood() {
    return food_;
}

void Pet::setOwnerName(string nu_on) {
    owner_name_ = nu_on;
}

string Pet::getOwnerName() {
    return owner_name_;
}

void Pet::setName(string nu_name) {
    name_ = nu_name;
}

string Pet::getName() {
    return name_;
}

string Pet::print() {
    return "My name is " + name_;
}
