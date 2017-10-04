{ React, mixins } = require '../common.coffee'
e = React.createElement
Icon = require './icon.coffee'
Select = require('react-select').default

class Selector extends React.Component
    constructor: (@myoui, props={})->
        super props
        theme = @theme = {@myoui.theme..., @theme..., props.theme...}

        @state = mouseover: false
        onMouseOver = (e)=>
            if not @state.mouseover
                @setState 'mouseover': true

        onMouseOut = (e)=>
            if @state.mouseover
                @setState 'mouseover': false

        @ui_props =  {
            key: @props.id
            className: 'myoui selector_container'
            onMouseOver: onMouseOver
            onMouseOut: onMouseOut
            style: {
                # required style
                mixins.rowFlex...
                alignItems: 'center'
                justifyContent: if @props.icon and @props.label then 'space-between' else 'center'
                width: '100%'
                userSelect: 'none'
                # cursor: 'pointer'
                theme.UIElement...
                theme.button...
            }
        }

        # Adding events
        for k,v of props when /^on[A-Z]/.test(k) and k!='onChange'
            if k == 'onMouseOver'
                @ui_props[k] = (e)=>
                    onMouseOver(e)
                    v(e)
            else if k == 'onMouseOut'
                @ui_props[k] = (e)=>
                    onMouseOut(e)
                    v(e)
            else
                @ui_props[k] = v

        @selectorProps = selectorProps = @props.config
        selectorProps.options = @props.options
        #TODO Modify react-select to support Radium styling
        selectorProps.style = theme.selector

        selectorProps.onChange = (item) =>
            @setState {value: item}
            @props.onChange? item

        selectorProps.name = @props.id

    componentWillUpdate: ()->
        @state.value = @props.read?()

    componentWillMount: ->
         @setState {value: @props.read()}

    render: ->
        {theme, state, props} = @
        label = icon = null
        if props.label
            label = e 'div',
                key: props.id + '.label'
                className: 'myoui label'
                style: theme.label()
                props.label

        icon = props.icon
        #if icon is an url the component will be created here
        if typeof(icon) == 'string'
            icon = e Icon,
                src: icon
                key: props.id + '.icon'
                style: theme.icon

        selector = e Select, {@selectorProps..., value: state.value}

        label_and_selector = e 'div',
            key: props.id + '.label_and_input'
            style: {
                mixins.columnFlex...
                width: '100%'
                alignItems: if props.flip then 'right' else 'left'
            }
            label, selector

        highlighted = (@props.useHighlight and @state.mouseover) or @props.forceHighlight
        ui_props = {
            @ui_props...,
            style: {
                @ui_props.style...
                theme.UIElementContainer(@props.disabled, highlighted)...
                }
            }

        if props.flip
            e 'div', ui_props, [label_and_selector, icon].concat props.children
        else
            e 'div', ui_props, [icon, label_and_selector].concat props.children

module.exports = Selector

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
