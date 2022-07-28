# SDSDataProcessor

convenient class/struct/enum/actor collection

## MathExpression/MathExpressionParser/BruteForceLexer

lexer/parser for math expression 
currently only accept numeric, +(plus) / -(minus) / *(multi) / /(div)

- can convert "1 + 2 * 2" into MathExpression (AST)
- understand operator priority */ > +-

usage from SwiftUI
```
struct ContentView: View {
    @State private var expresionString: String = "1 + 2 * 3"
    @State private var result: String = "not yet"
    var body: some View {
        VStack {
            TextEditor(text: $expresionString)
            Button(action: {
                do {
                    let lexer = BruteForceLexer()
                    let tokens = try lexer.lex(expresionString)
                    let parser = MathExpressionParser()
                    let expression = try parser.parse(tokens)
                    let resultDouble = try expression.calc()
                    result = "\(resultDouble)"
                } catch {
                    print("\(error.localizedDescription)")
                    result = "Error"
                }
            }, label: {
                Text("Evaluate")
            })
            Text("Result: \(result)")
        }
            .padding()
    }
}
```
