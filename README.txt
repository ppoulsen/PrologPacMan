------------
0) TOC
------------
1) Instructions
2) Assumptions
3) Sources
------------

------------
1) Instructions
------------
 - Place all submitted files and test rig in directory
   - csce322a3p1.pl
   - csce322a3p2.pl
   - csce322a3p3.pl
   - fullTests.pl
 - Run tests in fullTests
 - NOTE: I did all testing on Windows 7 using SWI-Prolog
         (Multi-threaded, 64 bits, Version 6.4.1)
		 If there are any problems, please test from that
		 environment. All tests provided passed on my machine
		 (though when multiple variables were possible, the order
		 may differ).
------------

------------
2) Assumptions
------------
 - I wrote and tested all files on a Windows 7 platform with SWI-Prolog
   (Multi-threaded, 64 bits, Version 6.4.1). All tests passed on this
   platform.   

 - I assume order of test output does not matter. For example, main3p2 and
   main4p3, I get the correct variable values but output them in a different
   order.

 - I assume time of execution does not matter. On my laptop, main5p3
   immediately returns [b,b,b,b,b,b,b], but takes between 1 and 2 minutes
   to output that there are no other options. This is the only test case
   where there was any noticeable delay.   
------------

------------
3) Sources
------------
Aside from the sources provided in the assignment, I used Seven
Languages in Seven Weeks as a tutorial when first learning ProLog.

Also, for the shortest path algorithm, I drew a lot of inspiration from
this StackOverflow post:
http://stackoverflow.com/a/20344609/1440310
Specifically, the use of findall(), keysort(), and memberchk() to generate
a list of all possible paths and then sort to find the shortest one. The
algorithm had to be altered beyond that to fit the needs of this assignment. 
------------