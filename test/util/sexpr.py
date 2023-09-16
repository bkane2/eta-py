from eta.util.sexpr import *

def main():
     
  sexpr = read_lisp('agents/sophie-gpt/rules/user-interpretation/gist/rules-for-yes-no.lisp')
  print(sexpr)

  test = "((^you go.v (to.p (the.d |Store|.n))) ** E1)"
  s_expr = parse_s_expr(test)
  print(s_expr)

  print(list_to_s_expr(s_expr))

  test = "(^you paraphrase-to.v ^me '(this is a test quote .))"
  s_expr = parse_s_expr(test)
  print(s_expr)

  test = "((^you paraphrase-to.v ^me '(this is a test quote .)) ** E1)"
  s_expr = parse_s_expr(test)
  print(s_expr)
     
  test = "(((PRES BE.V) (THE.D (| Nvidia| BLOCK.N)) (TO.P (THE.D (LEFT-OF.N (THE.D | Texaco| BLOCK.N))))) ?)"
  s_expr = parse_s_expr(test)
  print(s_expr)


if __name__ == "__main__":
  main()