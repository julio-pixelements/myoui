{ React, Component, mixins } = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video, select, option} = React.DOM

icon_component = require './icon.coffee'
Radium = require 'radium'
Select = React.createFactory Radium require 'react-select'

class Selector
    constructor: (@context, custom_theme={})->
        theme = @context.theme
        @ui = Component
            getDefaultProps: ->
                labelStyle: []

            componentWillUpdate: ()->
                @state.value = @props.read?()

            componentWillMount: ->
                 @setState {value: @props.read()}

            render: ->
                custom_theme = @props.custom_theme or custom_theme
                label = icon = null
                if @props.label
                    label = div
                        key: @props.id + '.label'
                        className: 'myoui label'
                        style: [
                            theme.label()
                            custom_theme.label?()
                        ]
                        @props.label

                icon = @props.icon
                #if icon is an url the component will be created here
                if typeof(icon) == 'string'
                    icon = icon_component
                        src: icon
                        key: @props.id + '.icon'
                        style:[
                            theme.icon
                            custom_theme.icon
                        ]

                selectorProps = @props.config
                selectorProps.options = @props.options
                selectorProps.value = @state.value
                #TODO Modify react-select to support Radium styling
                selectorProps.style = [
                    theme.selector
                    custom_theme.selector
                ]

                selectorProps.onChange = (item) =>
                    @setState {value: item}
                    @props.onChange? item

                selectorProps.name = @props.id

                selector = Select selectorProps

                label_and_selector = div
                    key: @props.id + '.label_and_input'
                    style:[
                        width: '100%'
                        mixins.columnFlex
                        alignItems: if @props.flip then 'right' else 'left'
                    ]
                    label, selector

                props_ui =  {
                    key: @props.id
                    className: 'myoui selector_container'
                    style:[
                        # required style
                        mixins.rowFlex
                        alignItems: 'center'
                        justifyContent: if icon and label then 'space-between' else 'center'
                        width: '100%'
                        mixins.noSelect
                        # cursor: 'pointer'
                        theme.UIElement
                        theme.UIElementContainer @props.disabled, @props.useHighlight, @props.forceHighlight
                        theme.button
                        custom_theme.UIElement
                        custom_theme.UIElementContainer? @props.disabled, @props.useHighlight, @props.forceHighlight
                        custom_theme.button
                        ]
                    }

                # Adding events
                for k,v of @props when /^on[A-Z]/.test(k) and k!='onChange'
                    props_ui[k] = v

                if @props.flip
                    div props_ui, [label_and_selector, icon].concat @props.children
                else
                    div props_ui, [icon, label_and_selector].concat @props.children

module.exports = {Selector}

###
visual scheme:

|  A___A    Label:                          |
| ( ↀωↀ)  [ selection ] |

Example:
selection = null

{
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    config: {} # react-select config:
        # https://github.com/JedWatson/react-select#further-options

    options: [{value: 10, label: 'Option 1'}, {value: 2, label: 'Option 2'}]
        # list of options, each option must be an object with 2 items, value and label.

    read: -> selection
        # It will be called when the component will mountv
        # its purpose is to update the current tex value reading it
        # from a external variable.

    onChange: (sel)-> selection = sel
        # if config.multi then sel = [{value: 10, label: 'Option 1'}, {value: 2, label: 'Option 2'}, ...]
        # else sel = {value:10, label: 'Option 1'}

        # It will save the new selection (sel) on a external variable.
}
###
