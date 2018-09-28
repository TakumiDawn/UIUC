#include "Rectangle.h"

//Empty Constructor sets instantiates a rectangle with length and width set as 0
Rectangle::Rectangle(){
  length = 0;
  width = 0;
}

//Standard Constructor sets instantiates a rectangle with length and width set as input values
Rectangle::Rectangle(int input_length, int input_width){
  length = input_length;
  width = input_width;
}

//Copy Constructor
//Instantiate a rectangle with length R1 = length R2 and width R1 = width R2
//when set x=y;
Rectangle::Rectangle( const Rectangle& other ){
  length = other.get_length();
  width = other.get_width();
}

//Setter and Getter functions
void Rectangle::set_length(int input_length){length= input_length;}

void Rectangle::set_width(int input_width){ width = input_width;}
int Rectangle::get_length(void) const{ return length;}
int Rectangle::get_width(void) const{return width;}

//Calculate Area of rectangle
int Rectangle::area(void){
  return length*width;
}

//Calculate Perimeter of rectangle
int Rectangle::perimeter(void){
  return 2*(length+width);
}

/*Addition operator overload
* We define addition of two rectangles to be as follows: R3 = R1 + R2
* where length of R3 = length R1 + length R2
* and width R3 = max(width R1, width R2)
*/
Rectangle Rectangle::operator + (const Rectangle& other){
  int dest_length = length + other.get_length();
  int dest_width = width + other.get_width();
  return Rectangle(dest_length,dest_width);
}

/*Multiplication operator overload
* We define addition of two rectangles to be as follows: R3 = R1 * R2
* where length of R3 = length R1 + length R2
* and width R3 = width R1 + width R2
*/
Rectangle Rectangle::operator * (const Rectangle& other){
  int dest_length = length * other.get_length();
  int dest_width = width * other.get_width();
  return Rectangle(dest_length,dest_width);
}
