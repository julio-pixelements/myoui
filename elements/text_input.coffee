{ React, mixins } = require '../common.coffee'
e = React.createElement

icon_component = require './icon'

class TextInput extends React.Component
    theme: {}
    constructor: (@myoui, props={}) ->
        super props
        @state =
            value: ''
            editing: false
            mouseover: false

        onMouseOver = (e)=>
            if not @state.mouseover
                @setState 'mouseover': true

        onMouseOut = (e)=>
            if @state.mouseover
                @setState 'mouseover': false

        theme = @theme = {@myoui.theme..., @theme..., props.theme...}

        @ui_props = ui_props =  {
            title: @props.title
            key: @props.id
            className: 'myoui text_input_container'
            style: {
                onMouseOver: onMouseOver
                onMouseOut: onMouseOut
                mixins.rowFlex...
                alignItems: 'center'
                width: '100%'
                userSelect: 'none'
                theme.UIElement...
                theme.button...
                maxWidth: '100%'
                justifyContent: ((@props.icon and @props.label) and 'space-between') or 'center'
            }
        }

        # Adding events
        for k,v of @props when /^on[A-Z]/.test(k) and k!='onChange'
            ui_props[k] = v

    componentWillUpdate: ->
        if not @state.editing
            @state.value = @props.read?()

    componentWillMount: ->
        @setState {value: @props.read()}

    render: ->
        theme = @theme

        label = @props.label

        if @props.label
            label = e 'div',
                key: @props.id + '.label'
                className: 'label'
                style: {
                    pointerEvents: 'none'
                    theme.textInput.label...
                }
                @props.label

        #if icon is an url the component will be created here
        icon = @props.icon
        if typeof(icon) == 'string'
            icon = icon_component
                src: icon
                key: @props.id + '.icon'
                style: theme.icon

        text_input = e 'input',
            autoFocus: @props.autoFocus
            onFocus: (event)->
                event.target.select()

            key: @props.id + '.input'
            className: 'text_input'
            style: {
                margin: '0px 0px 0px 10px'
                theme.textInput.input...
            }
            value: @state.value

            onChange: (event) =>
                v = event.target.value
                wrong_input = @props.validate?(v)
                if not wrong_input
                    @props.onChange?(v)
                @setState {value:v, wrongInput:wrong_input, editing:true}

            # dimiss
            onBlur: (event) =>
                @setState {value: @props.read(), editing:false}

            onKeyDown: (event)=>
                v = event.target.value
                if event.keyCode == 13 # ENTER (submit)
                    if @state.wrongInput
                        return
                    # write value
                    @props.onSubmit?(v)
                    @setState {editing:false}
                    event.target.blur()

                else if event.keyCode == 27 # ESC (dimiss)
                    event.target.blur()
                    @setState {value: @props.read(), editing:false}

        element_body = e 'div',
            key: @props.id + '.element_body'
            className: 'element_body'
            style: {
                mixins.columnFlex...
                width: '100%'
                alignItems: if @props.flip then 'right' else 'left'
            }
            label, text_input

        highlighted = (@props.useHighlight and @state.mouseover) or @props.forceHighlight

        ui_props = {
            @ui_props...,
            style: {
                @ui_props.style...
                theme.UIElementContainer(@props.disabled, highlighted)...
                }
            }

        if @props.flip
            e 'div', ui_props, [element_body, icon].concat @props.children
        else
            e 'div', ui_props, [icon, element_body].concat @props.children

module.exports = TextInput
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
