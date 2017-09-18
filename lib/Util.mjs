import chalk from 'chalk'

const isHexColor = str => str.charAt(0) === '#'

const getChalkColor = color =>
  isHexColor(color) ? chalk.hex(color) : chalk[color]

export const getColor = colors => {
  let stylize
  for (const color of colors) stylize = getChalkColor(color)
  return stylize
}

export const colorize = (colors, value) => getColor(colors)(value)
