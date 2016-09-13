
e = exports

chroma = e.chroma = require 'chroma-js'

e.colorInterpolation = colorInterpolation = (a,b,f=0) ->
    chroma.interpolate(a, b, f).hex()

noSelect = e.noSelect =
    WebkitTouchCallout: 'none'  # iOS Safari
    WebkitUserSelect: 'none'    # Chrome/Safari/Opera
    MozUserSelect: 'none'       # Firefox
    msUserSelect: 'none'        # Internet Explorer/Edge
    userSelect: 'none'          # Non-prefixed version, currently
                                # not supported by any browser

bgImg = e.bgImg = (img_url, color='transparent', position='center', size='contain', repeat=false)->
    repeat = if repeat then '' else 'no-repeat'
    "#{color} url(#{img_url}) #{position}  / #{size} #{repeat}"

boxShadow = e.boxShadow = (shadow) ->
    WebkitBoxShadow: shadow
    MozBoxShadow: shadow
    msBoxShadow: shadow
    OBoxShadow: shadow
    boxShadow: shadow

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
    background: '-webkit-' + args
    background: '-moz-' + args
    background: '-ms-' + args
    background: '-o-' + args
    background: args

blur = e.blur = ->
    args = "blur(#{arguments.join(', ')})"
    WebkitFilter: args
    MozFilter: args
    msFilter: args
    OFilter: args
    filter: args

transition = e.transition =(duration, properties) ->
    transitionDuration: duration
    transitionProperty: properties

transform = e.transform =  (args)->
    WebKitTransform: args
    MozTransform: args
    msTransform: args
    OTransform: args
    transform: args

animation = e.animation = (name, duration='1s', iteration_count=1)->
    animationName: name
    animationDuration: duration
    animationIterationCount: iteration_count

no_select = e.no_select = ->
    WebkitTouchCallout: 'none'
    WebkitUserSelect: 'none'
    MozUserSelect: 'none'
    msUserSelect: 'none'
    userSelect: 'none'

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
