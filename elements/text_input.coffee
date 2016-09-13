{ React, Component, mixins } = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

icon_component = require './icon'

class TextInput
    context: null
    constructor: (custom_theme={}) ->
        theme = @context.theme
        @ui = Component
            getDefaultProps: ->
                labelStyle: []

            componentWillMount: ->
                @setState {value: @props.read()}

            render: ->
                custom_theme = @props.custom_theme or custom_theme
                label = icon = null
                if @props.label
                    label = div
                        key: @props.id + '.label'
                        className: 'label'
                        style: [theme.label(), @props.labelStyle, pointerEvents: 'none']
                        @props.label

                icon = @props.icon
                #if icon is an url the component will be created here
                if typeof(icon) == 'string'
                    icon = icon_component
                        src: icon
                        key: @props.id + '.icon'
                        style:[theme.icon, custom_theme.icon]

                text_input = input
                    key: @props.id + '.input'
                    className: 'text_input'
                    style: [
                        theme.label()
                        theme.textInput
                        custom_theme.textInput
                        margin: '0px 0px 0px 10px'
                    ]
                    value: @state.value

                    onChange: (event) =>
                        v = event.target.value
                        wrong_input = @props.validate?(v)
                        if not wrong_input
                            @props.onChange?(v)
                        @setState {value:v, wrongInput:wrong_input}

                    # dimiss
                    onBlur: (event) =>
                        @setState {value: @props.read()}

                    onKeyDown: (event)=>
                        v = event.target.value
                        if event.keyCode == 13 # ENTER (submit)
                            if @state.wrongInput
                                return
                            # write value
                            @props.onSubmit?(v)
                            event.target.blur()

                        else if event.keyCode == 27 # ESC (dimiss)
                            event.target.blur()
                            @setState {value: @props.read()}

                label_and_input = div
                    key: @props.id + '.label_and_input'
                    style:[
                        width: '100%'
                        mixins.columnFlex
                        alignItems: if @props.flip then 'right' else 'left'
                    ]
                    label, text_input

                props_ui =  {
                    key: @props.id
                    className: 'text_input_container'
                    style:[
                        mixins.rowFlex
                        alignItems: 'center'
                        justifyContent: if icon and label then 'space-between' else 'center'
                        width: '100%'
                        mixins.noSelect
                        theme.UIElement
                        theme.UIElementContainer @props.disabled, @props.useHighlight
                        theme.button
                        custom_theme.button
                        ]
                    }

                # Adding events
                for k,v of @props when /^on[A-Z]/.test(k) and k!='onChange'
                    props_ui[k] = v

                if @props.flip
                    div props_ui, [label_and_input, icon].concat @props.children
                else
                    div props_ui, [icon, label_and_input].concat @props.children

module.exports = {TextInput}
###
visual scheme:

|  A___A    Label:                          |
| ( ↀωↀ)  [ Text input filled with text ] |

Example:
text = 'Myou is a cat'

{
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    read: -> text
        # It will be called on render
        # its purpose is to update the current tex value reading it
        # from a external variable.

    onSubmit: (t)-> text = t
        # It will save the new value on a external variable.
        # It will be called on submit (enter)

    onChange: (t)-> text = t
        # It will save the new value on a external variable.
        # It will be called on each keydown
}
###
