module.exports = class Lexer

  lex: (@input) ->
    @index = 0
    @current = @input[0]
    @tokens = []

    while @index < @input.length
      if @isWhiteSpace(@current) then @advance()
      else if @isOperator(@current) then @addOperator()
      else if @isDigit(@current) then @addDigit()
      else if @isIdentifier(@current) then @addIdentifier()
      else @advance()

    if @tokens[0].value == '(' && @tokens[@tokens.length - 1].value == ')'
      @tokens.pop()
      @tokens.shift()

    @addToken
      type: '(end)'
      lbp: 0

    @tokens

  advance: -> @current = @input[++@index]

  addToken: (attrs) -> @tokens.push attrs

  addOperator: ->
    @addToken
      type: 'operator'
      value: @current
    @advance()

  addDigit: ->
    num = @current
    num += @current while @isDigit(@advance())
    if @current == '.'
      num += @current while @isDigit(@advance())
    num = parseFloat(num)
    @addToken
      type: 'number'
      value: num

  addIdentifier: ->
    id = @current
    id += @current while @isIdentifier(@advance())
    @addToken
      type: 'identifier'
      value: id

  isOperator: (c) -> /[+\-*\/\^%=(),]/.test(c)
  isDigit: (c) -> /[0-9]/.test(c)
  isWhiteSpace: (c) -> /\s/.test(c)
  isIdentifier: (c) ->
    typeof c == "string" &&
      !@isOperator(c) &&
      !@isDigit(c) &&
      !@isWhiteSpace(c)
