# Design note
## name
newly designed element should start with "ME" prefix

## structure
METerm (MENumericToken: 数値、MEVariableToken: 変数, )

about parenthesis
atomic METerm does not include parenthesis, since upper element also might have parentesis...


1 + ( 2 * 3 + x ) * 3 
### Tokens
METerm MEOperator MEParenthesis MENumericTerm MEOperator(*) MENumericTerm(3) MEOperator(+) MEVariableTerm(x) MECloseParenthesis METimeOperator(*) MENumericTerm(3)



### AST
    PlusOperator
     /         \
METerm         TimeOperator
                /        \ 
      MEParenthesisTerm   3
                 \
                  PlusOperator
                  /    \
        TimeOperator     x
       /        \
      2          3      
