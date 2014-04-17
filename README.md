Simple example of boolean expressions evaluation written in C++ using Bison.
I compiled this program on Win7 using Cygwin and a separate download of Bison.

> make                    % to build the example

> calc++ examples.txt     % to run the example and evaluate the content of a file

Supports:
- simple language to check expressions and print a symbol and error code in case they are not verified
- expressions
	- can access variables (usage of predefined string values)
	- simple string comparisons with string literals or variables
	- boolean operators with integer expressions
	- function calls (usage of predefined functions accepting one integer parameter)

Todo
- remove double quotes from string literals
- support predefined functions with variable argument list
