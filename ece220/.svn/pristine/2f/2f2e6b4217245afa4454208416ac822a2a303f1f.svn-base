#include "shape.hpp"


//Intro paragraph:
//This program reads a file containing a list of shapes, set them into a vector
//list, and output the MaxArea and MaxVolume. It can also perform the Addition
//and subtraction.

/******************************************************************************/
//Base class
//Please implement Shape's member functions
//constructor, getName()
//
//Base class' constructor should be called in derived classes'
//constructor to initizlize Shape's private variable

//Base Constructor
Shape::Shape(string name)
{
  name_ = name;
}
//getName() in Base
string Shape::getName()
{
  return name_;
}
/******************************************************************************/
//Rectangle
//Please implement the member functions of Rectangle:
//constructor, getArea(), getVolume(), operator+, operator-

//Rectangle constructor
Rectangle::Rectangle(double width,double length):Shape("Rectangle")
{
  width_ = width;
  length_ = length;
}

//Rectangle getArea()
double Rectangle::getArea()const
{
  return length_*width_;
}
//Rectangle getVolume()
double Rectangle::getVolume()const
{
  return 0;
}
//Rectangle operator+
Rectangle Rectangle::operator + (const Rectangle& rec)
{
  double dest_length = length_ + rec.getLength();
  double dest_width = width_ + rec.getWidth();
  return Rectangle(dest_width,dest_length);
}
//Rectangle operator-
Rectangle Rectangle::operator - (const Rectangle& rec)
{
  double dest_length = max(0.0, length_ - rec.getLength());
  double dest_width = max(0.0, width_ - rec.getWidth());
  return Rectangle(dest_width,dest_length);
}

double Rectangle::getWidth()const{return width_;}
double Rectangle::getLength()const{return length_;}

/******************************************************************************/
//Circle
//Please implement the member functions of Circle:
//constructor, getArea(), getVolume(), operator+, operator-

//Circle construcor
Circle::Circle(double radius):Shape("Circle")
{
  radius_ = radius;
}
//Circle getArea()
double Circle::getArea() const
{
  return 3.14159265*radius_*radius_;
}
//Circle getVolume
double Circle::getVolume() const
{
  return 0;
}
//Circle operator+
Circle Circle:: operator + (const Circle& cir)
{
  double dest_radius = radius_ + cir.getRadius();
  return Circle(dest_radius);
}
//Circle operator-
Circle Circle:: operator - (const Circle& cir)
{
  double dest_radius = max(0.0, radius_ - cir.getRadius());
  return Circle(dest_radius);
}
double Circle::getRadius()const{return radius_;}
/*****************************************************************************/
//Sphere
//Please implement the member functions of Sphere:
//constructor, getArea(), getVolume(), operator+, operator-

//Sphere constructor
Sphere::Sphere(double radius):Shape("Sphere")
{
  radius_ = radius;
}
//Sphere getArea()
double Sphere::getArea() const
{
  return 4*3.14159265*radius_*radius_;
}
//Sphere get volume()
double Sphere::getVolume() const
{
  return (4.0/3.0)*radius_*radius_*radius_* 3.14159265;
}
//Sphere operator+
Sphere Sphere:: operator + (const Sphere& sph)
{
  double dest_radius = radius_ + sph.getRadius();
  return Sphere(dest_radius);
}
//Sphere operator-
Sphere Sphere:: operator - (const Sphere& sph)
{
  double dest_radius = max(0.0, radius_ - sph.getRadius());
  return Sphere(dest_radius);
}

double Sphere::getRadius()const{return radius_;}
/*****************************************************************************/
//Rectprism
//Please implement the member functions of RectPrism:
//constructor, getArea(), getVolume(), operator+, operator-

//RectPrism constructor
RectPrism::RectPrism(double width, double length, double height):Shape("RectPrism")
{
  length_ = length;
  width_ = width;
  height_ = height;
}
//RectPrism getVolume
double RectPrism::getVolume() const
{
  return length_*width_*height_;
}
//RectPrism getArea
double RectPrism::getArea() const
{
  return 2*(length_*width_+length_*height_+width_*height_);
}
//RectPrism operator +
RectPrism RectPrism:: operator + (const RectPrism& rectp)
{
  double dest_length = length_ + rectp.getLength();
  double dest_width = width_ + rectp.getWidth();
  double dest_height = height_ + rectp.getHeight();
  return RectPrism(dest_width, dest_length, dest_height);
}
//RectPrism operator -
RectPrism RectPrism:: operator - (const RectPrism& rectp)
{
  double dest_length = max(0.0, length_ - rectp.getLength());
  double dest_width = max(0.0, width_ - rectp.getWidth());
  double dest_height = max(0.0, height_ - rectp.getHeight());
  return RectPrism(dest_width, dest_length, dest_height);
}

double RectPrism::getWidth()const{return width_;}
double RectPrism::getHeight()const{return height_;}
double RectPrism::getLength()const{return length_;}


/*****************************************************************************/
// Read shapes from test.txt and initialize the objects
// Return a vector of pointers that points to the objects
vector<Shape*> CreateShapes(char* file_name)
{
  //read the file and initialize the vector list
  string name;
  int num_shapes;
  ifstream ifs (file_name, std::ifstream::in);
  ifs >> num_shapes;
  vector<Shape*> head;
  double r, w, l, h;
  //set the vectors accordingly
  for (int i = 0; i < num_shapes; i++)
  {
    ifs >> name;
    if (name=="Rectangle")
    {
      ifs >> w >> l;
      head.push_back(new Rectangle(w,l));
    }
    if (name=="Circle")
    {
      ifs >> r;
      head.push_back(new Circle(r));
    }
    if (name=="Sphere")
    {
      ifs >> r;
      head.push_back(new Sphere(r));
    }
    if (name=="RectPrism")
    {
      ifs >> w >> l >> h;
      head.push_back(new RectPrism(w, l, h));
    }
  }

  ifs.close();
	return head;
}

// call getArea() of each object
// return the max area
double MaxArea(vector<Shape*> shapes)
{
	double max_area = 0;
  int num_shapes = shapes.size();
  for (int i = 0; i < num_shapes; i++)
  {
    max_area = max(max_area, shapes[i]->getArea());
  }
	return max_area;
}


// call getVolume() of each object
// return the max volume
double MaxVolume(vector<Shape*> shapes)
{
	double max_volume = 0;
  int num_shapes = shapes.size();
  for (int i = 0; i < num_shapes; i++)
  {
    max_volume = max(max_volume, shapes[i]->getVolume());
  }
	return max_volume;
}
