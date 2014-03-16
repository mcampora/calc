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
	# include "calc++-driver.hh"
	# define ECHO(v);
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
%type  <int> exp
%printer { yyoutput << $$; } <*>;

%%
%start unit;

unit: 
	assignments exp  { driver.result = $2; };

assignments:
	%empty                 	{}
| 	assignments assignment 	{}
;

assignment:
	IDENTIFIER ":=" exp { driver.variables[$1] = $3; }
;

exp:
  	"identifier"	{ $$ = driver.variables[$1]; OUT($1, $$); }
| 	"number"		{ $$ = $1; OUT($1, $$);			}
| 	"string"		{ } //$$ = $1; OUT($1, $$);						}

|	"(" exp ")"		{ $$ = $2; OUT3("(", $2, ")", $$);			}
| 	"!" exp			{ $$ = !($2); OUT2("!", $2, $$);			}

| 	exp "==" exp	{ $$ = $1 == $3; OUT3($1, "==", $3, $$);		}
| 	exp "!=" exp	{ $$ = $1 != $3; OUT3($1, "!=", $3, $$);		}
| 	exp "||" exp	{ $$ = $1 || $3; OUT3($1, "||", $3, $$);		}	
| 	exp "&&" exp	{ $$ = $1 && $3; OUT3($1, "&&", $3, $$);		}
| 	exp "<" exp		{ $$ = $1 <  $3; OUT3($1, "<", $3, $$);		}
| 	exp ">" exp		{ $$ = $1 >  $3; OUT3($1, ">", $3, $$);		}
| 	exp "<=" exp	{ $$ = $1 <= $3; OUT3($1, "<=", $3, $$);		}
| 	exp ">=" exp	{ $$ = $1 >= $3; OUT3($1, ">=", $3, $$);		}
;

%%
void
yy::calcxx_parser::error (const location_type& l,
                          const std::string& m) {
	driver.error (l, m);
}
