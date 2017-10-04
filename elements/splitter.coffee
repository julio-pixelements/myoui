{ React, mixins } = require '../common.coffee'
e = React.createElement

class Splitter extends React.Component
    theme = {}
    constructor: (@myoui, props={}) ->
        super props
        theme = {@myoui.theme..., @theme..., props.theme...}

        custom_btn_theme = {
            button: {
                cursor: 'auto'
                paddingTop: 20
                theme.splitter.title_container...
            }
            label: -> theme.splitter.title
        }

        theme = @theme = {theme..., custom_btn_theme}

        for k,v of custom_theme then custom_btn_theme[k] = v

        ui_props = @ui_props =  {
            key: @props.id
            className: 'myoui splitter_container'
            style: {
                mixins.columnFlex...
                alignItems: 'center'
                justifyContent: 'center'
                width: '100%'
                theme.splitter.container...
            }
        }

        # Adding events
        for k,v of @props when /^on[A-Z]/.test k
            ui_props[k] = v

    render: ->
        splitter = e 'div',
            key: @props.id + '.splitter'
            className: 'myoui splitter'
            style: theme.splitter.style
            value: @state.value

        e 'div', @ui_props, [
            e @myoui.Button,
                key: @props.id + '.button'
                label: @props.label
                icon: @props.icon
            , splitter
            ].concat @props.children

module.exports = Splitter

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
