module.exports = class Parser

  constructor: ->
    @index = 0

  token: -> @tokens[@index]

  parse: (@tokens) ->
    @index = 0
    @parseToken i, token for token, i in @tokens

    @expression(0)

  advance: -> @index++

  expression: (rbp) ->
    t = @token()
    @advance()
    throw "Unexpected token: #{t.type}" unless t.nud
    left = t.nud(t)
    while rbp < @token().lbp
      t = @token()
      @advance()
      throw "Unexpected token: #{t.type}" unless t.led
      left = t.led(left)
    left

  parseToken: (index, token) ->
    switch token.type
      when 'number' then @parseNumber(index)
      when 'operator' then @parseOperator(index)

  parseNumber: (index) ->
    @tokens[index].nud = -> @value

  parseOperator: (index) ->
    token = @tokens[index]

    switch token.value
      when '+'
        token.lbp = 50
        token.led = (left) =>
          right = @expression(50)
          left + right
      when '-'
        token.lbp = 50
        token.led = (left) =>
          right = @expression(50)
          left - right
      when '*'
        token.lbp = 60
        token.led = (left) =>
          right = @expression(60)
          left * right
      when '/'
        token.lbp = 60
        token.led = (left) =>
          right = @expression(60)
          left / right

    @tokens[index] = token
