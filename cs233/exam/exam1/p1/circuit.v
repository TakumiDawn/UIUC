// Netflix has been engaged by movie studios to advertise new movies.
// Netflix will show visitors one of 4 ads based on the kind of movie
// they last watched.

// The following characteristics of the last watched movie are
// considered:
// - Whether the movie was animated? (A = 1 means the movie was
//     animated; otherwise A = 0)
// - Whether the starring actor was female (F = 1) or male (F = 0)?
// - The type of movie: (T = 2'b00 (action movie), 2'b01 (romance),
//     2'b10 (comedy), 2'b11 (thriller))

// The ad served is chosen by the following rules:
// - "A Good Day to Die Hard" (M = 2'b00) will be shown to viewers of
//     action movies and thrillers, unless they are animated or had a
//     female starring actor.
// - "Safe Haven" (M = 2'b01) will be selected for people who had
//     viewed romance movies or movies with a female starring actor that
//     are not comedies.
// - When the previous two movie ads aren't shown, "Escape from Planet
//     Earth" (M = 2'b10) will be shown to people viewing animated movies,
//     comedies, or action movies.
// - Otherwise, "Saving Lincoln" (M = 2'b11) will be shown.

module movies(M, A, F, T);
   output [1:0] M;
   input  	A, F;
   input  [1:0]	T;
   wire m1,m2,m3,m4,w1,w2,w3,w4,w5,w6,w7,t1,t2,t3,t4;

   or o1(w1,t1,t4);
   nor no1(w2,A,F);
   and a1(m1,w1,w2);
   or o2(w4,t2,F);
   not n1(w3,t3);
   and a2(m2,w4,w3);

   not n2(w5,m1);
   not n3(w6,m2);
   or o3(w7,A,t3,t1);
   and a3(m3,w5,w6,w7);

   nor no2(m4,m3,m2,m1);

   assign t1 = T[1:0]==2'b00;
   assign t2 = T[1:0]==2'b01;
   assign t3 = T[1:0]==2'b10;
   assign t4 = T[1:0]==2'b11;

   assign M[0] = m2|m4;
   assign M[1] = m3|m4;


endmodule // movies
