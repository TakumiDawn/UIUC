// a code generator for the ALU chain in the 32-bit ALU
// see example_generator.cpp for inspiration

#include <iostream>
using namespace std;

int main() {
//  cout << "alu1 a" << 0  << "(out[" << 0 << "], carryout[" << 0 << "], A[" << 0 << "], B[" << 0 << "], control[" << 0 << "], control[" << "2:0" << "]);" << endl;
  for (int i = 0; i < 32; i++) {
    cout << "dffe d" << i << "(q[" << i << "],d[" << i << "],clk,enable,reset);" << endl;
  }
}
