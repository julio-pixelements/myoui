{ React, Component, mixins} = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

icon_component = require './icon.coffee'

class Button
    context: null
    constructor: (custom_theme={})->
        theme = @context.theme
        self = @ # to be used in the component
        @ui = Component
            getDefaultProps: ->
                useHighlight: false

            render: ->
                custom_theme = @props.custom_theme or custom_theme
                #if label is an string the component will be created here
                label = @props.label
                if typeof(label) == 'string'
                    label = div
                        key: @props.id + '.label'
                        className: 'label'
                        style: [theme.label(), custom_theme.label?()]
                        @props.label

                #if icon is an url the component will be created here
                icon = @props.icon
                if typeof(icon) == 'string'
                    icon = icon_component
                        src: icon
                        key: @props.id + '.icon'
                        style:[theme.icon, custom_theme.icon]

                # ui_props
                ui_props = {}

                ui_props.title = @props.title
                ui_props.key = null
                ui_props.className = 'myoui simple_button'
                ui_props.style = [
                    mixins.rowFlex
                    alignItems: 'center'
                    justifyContent:
                        if icon and label
                            if @props.flip
                                'flex-end'
                            else
                                'flex-start'
                        else
                            'center'
                    width: '100%'
                    mixins.noSelect
                    cursor: 'pointer'
                    theme.UIElement
                    theme.UIElementContainer @props.disabled, @props.useHighlight, @props.forceHighlight
                    theme.button
                    custom_theme.button
                    ]

                # Adding events
                for k,v of @props when /^on[A-Z]/.test k
                    ui_props[k] = v

                if @props.flip
                    div ui_props, label, icon, @props.children
                else
                    div ui_props, icon, label, @props.children



module.exports = {Button}
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
