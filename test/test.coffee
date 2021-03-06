'use strict'

should = require 'should'

util = require './util'
acho   = require '..'

describe 'acho', ->

  describe 'constructor', ->

    it 'new keyword', ->
      should(acho()).be.an.Object()

    it 'non new keyword', ->
      should(new acho()).be.an.Object()

  describe 'internal store', ->

    describe 'initialization', ->

      it 'passing a initial store state', ->
        log = acho
          transport: util.createFakeTransport()
          messages:
            info: ['info message']

        log.print()

        should(log.transport.store.length).be.equal(1)

    describe '.push', ->
      it 'add message into a internal level collection', ->
        log = acho().push 'error', 'hello world'
        should(log.messages.error.length).be.equal(1)

    describe '.add', ->
      it 'push and print a message', ->
        log = acho transport: util.createFakeTransport()
        log.add 'error', 'hello world'

        should(log.transport.store.length).be.equal(1)
        should(log.messages.error.length).be.equal(1)
        should(log.messages.error[0]).be.equal('hello world')

  describe 'levels', ->

    it 'print a normal level message', ->
      log = acho transport: util.createFakeTransport()
      log.warn 'warn message'

      should(log.transport.store.length).be.equal(1)

    it 'no ouptut messages out of the level',  ->
      log = acho
        transport: util.createFakeTransport()
        level: 'fatal'

      log.error 'test of message'
      should(log.transport.store.length).be.equal(0)

  describe 'customization', ->
    it 'default skin', ->
      log = acho()
      util.printLogs log
      should(log.keyword?).be.false()

    it 'change the color behavior',  ->
      log = acho
        transport: util.createFakeTransport()
        types: error: color: ['underline', 'bgRed']

      log.push 'error', 'hello world'
      log.print()

      should(log.transport.store.length).be.equal(1)

    it 'specifying a keyword', ->
      log = acho keyword: 'acho'
      util.printLogs log
      should(log.keyword).be.equal('acho')

    it 'specifying "symbol" keyword', ->
      log = acho keyword: 'symbol'
      util.printLogs log
      should(log.keyword).be.equal('symbol')

    it 'enabling diff between logs', (done) ->
      log = acho
        diff: true
        trace: true

      printWarn = -> log.warn 'hello world'
      printErr = -> log.error 'oh noes!'

      warn = setInterval(printWarn, util.randomInterval(1000, 2000))
      err = setInterval(printErr, util.randomInterval(2000, 2500))

      setTimeout(->
        clearInterval warn
        clearInterval err
        done()
      , 5000)
