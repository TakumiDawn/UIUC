#include <iostream>
using namespace std;

class Shape{
	protected:
	double width, height;
	public:
	Shape() {width = 1; height = 1;}
	Shape(double a, double b) { width = a; height = b; }
	double area(){ cout << "Base class area unknown." << endl; return 0;}
};

class Rectangle : public Shape{
	public:
	Rectangle(double a, double b){width = a; height = b;}
	double area() { 
		cout << "Rectangle object area is " << width*height << endl;
		return (double)width*height; }
};

class Triangle : public Shape{
	public:
	Triangle(double a, double b) : Shape(a,b){}
	double area() {
		cout << "Triangle object area is " << width*height/2 << endl;
		return (double)width*height/2; }
};


//What does this program print?
//What needs to be changed to call the area function defined in derived class?
int main(){
	Shape *ptr;
	Shape shape1(1,2);
	Rectangle rec(3,5);
	Triangle tri(4,5);
/*
	shape1.area();
	rec.area();
	tri.area();
*/
	ptr = &shape1;
	ptr->area();

	//use ptr to point to rec
	ptr = &rec;
	ptr->area();

	//use ptr to point to tri
	ptr = &tri;
	ptr->area();

	return 0;
}
