{ React, Component, mixins } = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

class Splitter
    context: null
    constructor: (custom_theme={}) ->
        @custom_theme = custom_theme
        theme = @context.theme

        custom_btn_theme = {
            button:
                cursor: 'auto'
                paddingTop: 20
            label: -> [
                theme.splitter.title
                custom_theme.splitter? and custom_theme.splitter.title
            ]
        }

        for k,v of custom_theme then custom_btn_theme[k] = v

        btn = new @context.Button custom_btn_theme

        @ui = Component
            render: ->
                custom_theme = @props.custom_theme or custom_theme
                splitter = div
                    key: @props.id + '.splitter'
                    className: 'myoui splitter'
                    style: [
                        theme.splitter.style,
                        custom_theme.splitter? and custom_theme.splitter.style
                    ]
                    value: @state.value

                props_ui =  {
                    key: @props.id
                    className: 'myoui splitter_container'
                    style:[
                        mixins.columnFlex
                        alignItems: 'center'
                        justifyContent: 'center'
                        width: '100%'
                        custom_theme.splitter? and custom_theme.splitter.container
                        ]
                    }

                # Adding events
                for k,v of @props when /^on[A-Z]/.test k
                    props_ui[k] = v

                div props_ui, [
                    btn.ui
                        key: @props.id + '.button'
                        label: @props.label
                        icon: @props.icon

                    splitter
                    ].concat @props.children

module.exports = {Splitter}

###
Visual scheme:
     [ label ]
------------------------

Example:
{
    label: 'string'
        # it could be a string or null
}
###
