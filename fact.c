#include <stdlib.h>

void main( void ) {
   /* Code to return the the result of the mathematical expression 10! (Fact-
    * orial 10). 
    */

   int a = 10; // Number to get the factorial of
   int result = 1; // Start 1 at because even 0! = 1

   do {
      result *= a;
      a--;    
   } while ( a > 1 );

   printf( "10! is %d", result );

   return 0;
}
