'use strict'

const CONST = require('./Constants')
const DEFAULT = require('./Default')

function Acho (opts = {}) {
  !(this instanceof Acho) && new Acho(opts)
  let acho = Object.assign({}, DEFAULT(), opts)
  acho.diff && (acho.diff = [])

  acho.messages = (() => {
    const messages = {}
    for (const type in acho.types) {
      if (acho.types.hasOwnProperty(type)) {
        messages[type] = (opts.messages || {})[type] || []
        acho[type] = acho.generateTypeMessage(type)
      }
    }
    return messages
  })()

  acho.push = function (type, ...messages) {
    const message = this.format(messages)
    this.messages[type].push(message)
    return this
  }

  acho.add = function (type, ...messages) {
    const message = this.format(messages)
    this[type](message)
    this.push(type, message)
    return this
  }

  return acho
}

module.exports = Acho
module.exports.constants = CONST