#ifndef _QUEEN_H
#define _QUEEN_H

#include "Piece.h"
//#include <string>
//using namespace std;

class Queen: public Piece
{
  private:
    string type_;
  public:
    Queen();
    string getType();


};

#endif
