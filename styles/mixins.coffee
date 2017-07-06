
e = exports

chroma = e.chroma = require 'chroma-js'

e.colorInterpolation = colorInterpolation = (a,b,f=0) ->
    chroma.interpolate(a, b, f).hex()

bgImg = e.bgImg = (img_url, color='transparent', position='center', size='contain', repeat=false)->
    repeat = if repeat then '' else 'no-repeat'
    "url(#{img_url}) #{position} / #{size} #{repeat} #{color}"

border3d = e.border3d = (opacity=1, width='1px', inset=false) ->
    if inset
        borderLeft: 'none'
        borderRight: 'none'
        borderTop: "solid rgba(0,0,0,#{opacity}) #{width}"
        borderBottom: "solid rgba(255,255,255,#{opacity + 1.5}) #{width}"
    else
        borderLeft: 'none'
        borderRight: 'none'
        borderTop: "solid rgba(255,255,255,#{opacity * 1.5}) #{width}"
        borderBottom: "solid rgba(0,0,0,#{opacity}) #{width}"

bgLinearGradient = e.bgLinearGradient = (args)->
    args = "linear-gradient(#{args})"
    background: args

blur = e.blur = ->
    args = "blur(#{arguments.join(', ')})"
    filter: args

transition = e.transition =(duration, properties) ->
    transitionDuration: duration
    transitionProperty: properties

animation = e.animation = (name, duration='1s', iteration_count=1)->
    animationName: name
    animationDuration: duration
    animationIterationCount: iteration_count

columnFlex = e.columnFlex =
    display: 'flex'
    flexDirection: 'column'
    flexWrap: 'nowrap'
    justifyContent: 'flex-start'
    alignItems: 'center'

rowFlex = e.rowFlex =
    display: 'flex'
    flexDirection: 'row'
    flexWrap: 'nowrap'
    justifyContent: 'flex-start'
    alignItems: 'center'


e.fullWindow = fullWindow =
    position: 'fixed'
    top: 0
    left: 0
    width: '100vw'
    height: '100vh'
