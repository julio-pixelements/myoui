{ React, mixins } = require '../common.coffee'
e = React.createElement

Icon = require './icon.coffee'

class Button extends React.Component
    @defaultProps:
        useHighlight: false

    theme: {}
    constructor: (@myoui, props={})->
        super props
        theme = @theme = {@myoui.theme..., @theme..., props.theme...}
        #if label is an string the component will be created here

        @state = mouseover: false
        onMouseOver = (e)=>
            if not @state.mouseover
                @setState 'mouseover': true

        onMouseOut = (e)=>
            if @state.mouseover
                @setState 'mouseover': false

        @ui_props =
            title: props.title
            key: null
            className: 'myoui simple_button'
            onMouseOver: onMouseOver
            onMouseOut: onMouseOut
            style: {
                mixins.rowFlex...
                alignItems: 'center'
                width: '100%'
                userSelect: 'none'
                cursor: 'pointer'
                justifyContent:
                    if props.icon and props.label
                        if props.flip
                            'flex-end'
                        else
                            'flex-start'
                    else
                        'center'
                theme.UIElement...
                theme.button...
            }


        # Adding events
        for k,v of @props when /^on[A-Z]/.test k
            if k == 'onMouseOver'
                @ui_props[k] = do(v)=>(e)=>
                    onMouseOver(e)
                    v(e)
            else if k == 'onMouseOut'
                @ui_props[k] = do(v)=>(e)=>
                    onMouseOut(e)
                    v(e)
            else
                @ui_props[k] = v

    render: ->
        theme = @theme
        label = @props.label
        if typeof(label) == 'string'
            label = e 'div',
                key: @props.id + '.label'
                className: 'label'
                style: theme.label()
                @props.label

        #if icon is an url the component will be created here
        icon = @props.icon

        if typeof(icon) == 'string'
            icon = e Icon
                src: icon
                key: @props.id + '.icon'
                style: theme.icon

        highlighted = (@props.useHighlight and @state.mouseover) or @props.forceHighlight
        ui_props = {
            @ui_props...,
            style: {
                @ui_props.style...
                theme.UIElementContainer(@props.disabled, highlighted)...
                }
            }

        if @props.flip
            e 'div', ui_props, label, icon, @props.children
        else
            e 'div', ui_props, icon, label, @props.children

module.exports = Button
###
Visual scheme:
[ label ]

Example:
{
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    onMouseUp: (event)-> alert 'Hi!'
        # this is a regular onMouseUp function
}
###
