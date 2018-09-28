#include "Piece.h"
// implementation of class piece

Piece::Piece()
{
  type_ = "Unknown Piece Type";
}

string Piece::getType()
{
  return type_;
}
