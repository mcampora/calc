%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0.2"
%defines
%define parser_class_name {calcxx_parser}
#line 11170 "./doc/bison.texi"
%define api.token.constructor
%define api.value.type variant
%define parse.assert
%code requires
{
# include <string>
class calcxx_driver;
}
// The parsing context.
%param { calcxx_driver& driver }
%locations
%initial-action
{
  // Initialize the initial location.
  @$.begin.filename = @$.end.filename = &driver.file;
};
%define parse.trace
%define parse.error verbose
%code
{
# include "calc++-driver.hh"
}

%define api.token.prefix {TOK_}
%token
  END  0  "end of file"
  ASSIGN  ":="
  LPAREN  "("
  RPAREN  ")"
  EQUAL   "=="
  LT      "<"
  GT      ">"
  LTE     "<="
  GTE     ">="
  OR      "||"
  AND     "&&"
  NOT     "!"
;
%token <std::string> IDENTIFIER "identifier"
%token <int> NUMBER "number"
%type  <int> exp
%printer { yyoutput << $$; } <*>;
%%
%start unit;

unit: assignments exp  { driver.result = $2; };

assignments:
  %empty                 {}
| assignments assignment {};

assignment:
  "identifier" ":=" exp { driver.variables[$1] = $3; };

//%left OR
//%left AND
//%left UNOT

exp:
  "(" exp ")"   { std::swap ($$, $2); }
| "identifier"  { $$ = driver.variables[$1]; }
| "number"      { std::swap ($$, $1); }
| exp "==" exp  { $$ = $1 == $3; }
| exp "||" exp  { $$ = $1 || $3; }
| exp "&&" exp  { $$ = $1 && $3; }
| exp "<" exp  { $$ = $1 < $3; }
| exp ">" exp  { $$ = $1 > $3; }
| exp "<=" exp  { $$ = $1 <= $3; }
| exp ">=" exp  { $$ = $1 >= $3; }
| NOT exp %prec UNOT { $$ = !($2); }
;

%%
void
yy::calcxx_parser::error (const location_type& l,
                          const std::string& m)
{
  driver.error (l, m);
}