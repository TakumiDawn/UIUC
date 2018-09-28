#include <string>
#ifndef _PIECE_H
#define _PIECE_H

using namespace std;

class Piece
{
  private:
    string type_;
  public:
    Piece();
    string getType();

};

#endif
