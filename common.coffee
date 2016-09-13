
Radium = require 'radium'
React = require 'react'
ReactDOM = require 'react-dom'

#Create a radium component
Component = (component)->
    React.createFactory Radium React.createClass component

#Internal libraries
mixins = require './styles/mixins'

module.exports = {
React, ReactDOM, Component, mixins, Radium
}
