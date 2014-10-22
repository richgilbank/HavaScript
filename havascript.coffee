#!/usr/local/bin/coffee

fs     = require('fs')
repl   = require('repl')
Lexer  = require('./lexer')
Parser = require('./parser')

class HavaScript

  constructor: ->
    args = process.argv.slice(2)
    if args.length
      if fs.existsSync(args[0])
        data = fs.readFileSync(args[0], encoding: 'utf8')
        process.stdout.write "#{@execute(data)}\n"
      else
        process.stdout.write('Invalid file\n')
    else
      repl.start
        prompt: 'HavaScript> '
        input: process.stdin
        output: process.stdout
        eval: @replEval

  execute: (input) ->
    @lexer ?= new Lexer()
    @parser ?= new Parser()
    tokens = @lexer.lex(input)
    tree = @parser.parse(tokens)

  replEval: (cmd, context, filename, callback) =>
    callback(null, @execute(cmd))

module.exports = new HavaScript
