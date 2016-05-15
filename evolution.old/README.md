## evolution.old

This was my first primitive attempt at porting the [Java solution](http://rosettacode.org/wiki/Evolutionary_algorithm#Java) 
for the [Evolutionary algorithm](http://rosettacode.org/wiki/Evolutionary_algorithm) task 
for [Pony](http://rosettacode.org/wiki/Category:Pony).

For some reason I decided to use `Array[U8]` instead of `String`. That turned out to be a 
mistake, as I was forced to do repeated byte-by-byte copying, using the `arrayVal` function.
