%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0.2"
%defines
%define parser_class_name {calcxx_parser}
%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires {
	# include <string>
	class calcxx_driver;
}

// The parsing context.
%param { calcxx_driver& driver }
%locations
%initial-action {
  	// Initialize the initial location.
  	@$.begin.filename = @$.end.filename = &driver.file;
};

%define parse.trace
%define parse.error verbose
%code {
	# include <stdio.h>
	# include "calc++-driver.hh"
	# define OUT(e, v) std::cout << e << " -> " << v << "\n"
	# define OUT2(e1, e2, v) std::cout << e1 << " " << e2 << " -> " << v << "\n"
	# define OUT3(e1, e2, e3, v) std::cout << e1 << " " << e2 << " " << e3 << " -> " << v << "\n"
}

%define api.token.prefix {TOK_}
%token
  END  0  "end of file"
  ASSIGN  ":="
  LPAREN  "("
  RPAREN  ")"
  EQUAL   "=="
  NEQUAL  "!="
  LT      "<"
  GT      ">"
  LTE     "<="
  GTE     ">="
  OR      "||"
  AND     "&&"
  NOT     "!"
;
%token <std::string> IDENTIFIER "identifier"
%token <std::string> STRING "string"
%token <int> NUMBER "number"
%type  <std::string> sval
%type  <int> sexp iexp exp ifunction
%printer { yyoutput << $$; } <*>;

%%
%start unit;

unit: 
	exp  { driver.result = $1; };

exp:
	iexp  			{ $$ = $1; 						printf("%d\n", $1, $$);							}
|   sexp			{ $$ = $1;						printf("%d\n", $1, $$);							}
|	"(" exp ")"		{ $$ = $2; 						printf("(%d) => %d\n", $2, $$);					}
| 	"!" exp			{ $$ = !($2); 					printf("!%d => %d\n", $2, $$);					}
;
	
sexp:
	sval "==" sval 	{ $$ = ($1 == $3); 		printf("%s == %s => %d\n", $1.c_str(), $3.c_str(), $$);	}
|	sval "!=" sval 	{ $$ = ($1 != $3); 		printf("%s != %s => %d\n", $1.c_str(), $3.c_str(), $$);	}
;
	
sval:
  	"identifier"	{ $$ = driver.variables[$1]; 	printf("%s\n", $$.c_str());						}
|	"string"  		{ $$ = $1; 						printf("%s\n", $1.c_str());            			}
;

iexp:
 	"number"		{ $$ = $1; 						printf("%d\n", $$);								}
|	ifunction		
| 	exp "==" exp	{ $$ = $1 == $3; 				printf("%d %s %d => %d\n", $1, "==", $3, $$);	}
| 	exp "!=" exp	{ $$ = $1 != $3; 				printf("%d %s %d => %d\n", $1, "!=", $3, $$);	}
| 	exp "||" exp	{ $$ = $1 || $3; 				printf("%d %s %d => %d\n", $1, "||", $3, $$);	}	
| 	exp "&&" exp	{ $$ = $1 && $3; 				printf("%d %s %d => %d\n", $1, "&&", $3, $$);	}
| 	exp "<"  exp	{ $$ = $1 <  $3; 				printf("%d %s %d => %d\n", $1, "<",  $3, $$);	}
| 	exp ">"  exp	{ $$ = $1 >  $3; 				printf("%d %s %d => %d\n", $1, ">",  $3, $$);	}
| 	exp "<=" exp	{ $$ = $1 <= $3; 				printf("%d %s %d => %d\n", $1, "<=", $3, $$);	}
| 	exp ">=" exp	{ $$ = $1 >= $3; 				printf("%d %s %d => %d\n", $1, ">=", $3, $$);	}
;

ifunction:
 	"identifier" "(" exp ")" { 
		$$ = driver.functions[$1]($3); 
		printf("%s(%d) => %d\n", $1.c_str(), $3, $$); 
	}
;

%%
void
yy::calcxx_parser::error (const location_type& l,
                          const std::string& m) {
	driver.error (l, m);
}
