{ React, mixins } = require '../common.coffee'
e = React.createElement
class Switch extends React.Component
    @defaultProps = {states: 2}
    theme: {}
    constructor: (myoui, props={}) ->
        super props
        props = @switch_props = {myoui.theme.switch.props..., props...}

        @state =
            state: 0

        @myoui = myoui
        theme = @theme = {@myoui.theme..., @theme..., props.theme...}

        @ui_props = ui_props = {
            button:
                justifyContent: 'space-between'
            label: @props.label
            icon: @props.icon
            theme.switch.props...
        }

        # Adding events
        for k,v of @props when /^on[A-Z]/.test k
            ui_props[k] = v

        ui_props.onMouseUp = (event) =>
            props.write?(@state.state)
            props.onMouseUp?(event)
            @forceUpdate()

    componentWillUpdate: ()->
        @state.state = @props.read?() % @props.states

    render: ->
        theme = @theme
        props = @switch_props
        # calc next state
        states = props.states

        if not states or states < 2
            throw 'Invalid number of states: ' + states + '\n The number of states must be 2 or more.'
        state = @state.state or 0

        {
            radius=0, buttonWidth=0, containerBaseWidth=0,
            borderWidth=0, containerHeight=0
        } = props


        containerWidth = containerBaseWidth + buttonWidth # total width of the container

        step = containerBaseWidth/(states-1)

        switchWidth = (step * state) + buttonWidth

        colorFactor = (1/(states-1))*state
        if typeof(props.switchColor) == 'function'
            switchColor = props.switchColor colorFactor
        else
            switchColor = props.switchColor

        switchComponent = e 'div',
            className: 'myoui switch'
            style: {
                position: 'relative'
                width: containerWidth
                height: containerHeight
                borderRadius: radius
                overflow: 'hidden'
                theme.switch.container(borderWidth)...
            }
            e 'div',
                style: {
                    position: 'absolute'
                    width: switchWidth - (borderWidth * 2)
                    height: containerHeight - (borderWidth * 2)
                    marginLeft: borderWidth
                    borderRadius: radius - borderWidth
                    (theme.switch.base borderWidth, switchColor)...
                }
                e 'div',
                    style: {
                        position: 'absolute'
                        top: -1
                        right: 0
                        width: containerHeight - (2 * borderWidth)
                        height: containerHeight - (2 * borderWidth)
                        borderRadius: radius
                        (theme.switch.button borderWidth)...
                    }

        e @myoui.Button, @ui_props, switchComponent

module.exports = Switch

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
