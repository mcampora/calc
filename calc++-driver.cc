#line 11104 "./doc/bison.texi"
#include "calc++-driver.hh"
#include "calc++-parser.tab.hh"

int fn_identity(int n) {
	return n;
}

int fn_invert(int n) {
	return !n;
}

calcxx_driver::calcxx_driver ()
  : trace_scanning (false), trace_parsing (false)
{
  // some examples of variables and functions
  variables["one"] = "one";
  variables["two"] = "two";
  
  functions["identity"] = fn_identity;
  functions["invert"] = fn_invert;
  
}

calcxx_driver::~calcxx_driver ()
{
}

int
calcxx_driver::parse (const std::string &f)
{
  file = f;
  scan_begin ();
  yy::calcxx_parser parser (*this);
  parser.set_debug_level (trace_parsing);
  int res = parser.parse ();
  scan_end ();
  return res;
}

void
calcxx_driver::error (const yy::location& l, const std::string& m)
{
  std::cerr << l << ": " << m << std::endl;
}

void
calcxx_driver::error (const std::string& m)
{
  std::cerr << m << std::endl;
}
