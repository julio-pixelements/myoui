{ React, Component, mixins } = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

class Switch
    context: null
    constructor: (custom_theme={}) ->
        @custom_theme = custom_theme
        theme = @context.theme

        custom_btn_theme = {button: justifyContent: 'space-between'}
        for k,v of custom_theme then custom_btn_theme[k] = v

        btn = new @context.Button custom_btn_theme

        @ui = Component
            getDefaultProps: ->
                props = theme.switch.props
                props.useHighlight = false
                props.states = 2
                return props

            componentWillUpdate: ()->
                @state.state = @props.read?() % @props.states

            render: ->
                custom_theme = @props.custom_theme or custom_theme
                # calc next state
                states = @props.states
                state = @state.state or 0

                {radius, buttonWidth, containerBaseWidth, borderWidth, containerHeight} = @props

                containerWidth = containerBaseWidth + buttonWidth # total width of the container
                step = containerBaseWidth/(states-1)

                switchWidth = (step * state) + buttonWidth

                colorFactor = (1/(states-1))*state
                if typeof(@props.switchColor) == 'function'
                    switchColor = @props.switchColor colorFactor
                else
                    switchColor = @props.switchColor

                switchComponent = div
                    className: 'myoui switch'
                    style:[
                        position: 'relative'
                        width: containerWidth
                        height: containerHeight
                        borderRadius: radius
                        overflow: 'hidden'
                        theme.switch.container borderWidth
                        if custom_theme.switch?
                            custom_theme.switch.container borderWidth                 ]
                    div
                        style: [
                            position: 'absolute'
                            width: switchWidth - (borderWidth * 2)
                            height: containerHeight - (borderWidth * 2)
                            marginLeft: borderWidth
                            borderRadius: radius - borderWidth
                            theme.switch.base borderWidth, switchColor
                            if custom_theme.switch?
                                custom_theme.switch.base borderWidth, switchColor
                        ]
                        div
                            style: [
                                position: 'absolute'
                                top: -1
                                right: 0
                                width: containerHeight - (2 * borderWidth)
                                height: containerHeight - (2 * borderWidth)
                                borderRadius: radius
                                theme.switch.button borderWidth
                                if custom_theme.switch?
                                    custom_theme.switch.button borderWidth
                            ]

                props_ui = {
                    label: @props.label
                    icon: @props.icon
                }

                # Adding events
                for k,v of @props when /^on[A-Z]/.test k
                    props_ui[k] = v

                props_ui.onMouseUp = (event) =>
                    @props.write?(state)
                    @props.onMouseUp?(event)
                    @forceUpdate()

                btn.ui props_ui, switchComponent

module.exports = {Switch}

###
visual scheme:

[0  ]   disabled (state 0)
[-0 ]   semienabled (state 1)
[--0]   enabled (state 2)

Example:
variable = 10

{
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    states: 3 # 2 by default
        # number of different states, the switch supports any number of
        # states but we recomend use 2 or 3. More states could be confusing.

    read: -> variable
        # It will be called on render
        # its purpose is to update the switch current state reading it
        # from a external variable.

    write: (currentState)-> variable = (currentState + 1) % 3
        # It will save the new state on a external variable.
        # It will be called on mouse up

    switchColor: (colorFactor)->
        # It could be a css color (string) or
        # a function wich returns a css color (string).
        # the argument of the function is colorFactor defined by
        # (current_state/number_of_states).
        # It is defined by default in mixins.coffee

        return mixins.colorInterpolation colors.red, colors.green, colorFactor
}
###
