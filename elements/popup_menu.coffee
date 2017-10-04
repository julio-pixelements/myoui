{ React, ReactDOM, mixins } = require '../common.coffee'
e = React.createElement

class PopupMenuManager
    constructor: (@myoui, options={})->
        {@zIndex=1000000, @useHighlight=true} = options

        @pums = {}
        @active = []
        # allow/avoid parent overflow.

        # It will be overwritten when the component is mounted.
        # If @update is called before mounting the component.
        # It will throw an error.
        @update = ->
            throw 'The component is not mounted.'

        pum_manager = @
        myoui = @myoui
        @PopupMenu = PopupMenu = class PopupMenu extends React.Component
            @defaultProps:
                children: []
                top: '0px'
                left: '0px'

            constructor: (props={})->
                super props
                theme = @theme = {myoui.theme..., props.theme...}

            # Setting pum position and correcting it if overfows the window.
            componentDidMount: ->
                {props} = @
                element = ReactDOM.findDOMNode @
                # launched as a sub pum
                if props.parent_element?
                    rect = props.parent_element.getClientRects()[0]
                    original_width = element.offsetWidth
                    element.style.top = "calc(#{rect.top}px + #{props.left})"
                    element.style.left = "calc(#{rect.left + rect.width - 2}px + #{props.top})"

                    # calculating overflow
                    {top, left, width, height,
                    top_overflow, left_overflow} = get_screen_overflow element

                    if left_overflow
                        final_left = rect.left - original_width + 2

                        if final_left > 0 # inside the left side of the window
                            # placing the pum in the other side of the item
                            element.style.left =  final_left
                        else
                            # correcting horizontal position
                            element.style.left = left - left_overflow + 'px'

                else
                    element.style.top = props.top
                    element.style.left = props.left

                    # calculating overflow
                    {top, left, top_overflow,
                    left_overflow} = get_screen_overflow element

                    # correcting horizontal position
                    element.style.left = left - left_overflow + 'px'

                # correcting vertical position
                element.style.top = top - top_overflow + 'px'

            render: ->
                {props, theme} = @

                # This component is a css triangle, to be added in the items with sub-pum
                triangle = e 'div',
                    style:
                        width: 10
                        height: 10
                    e 'div',
                        style:
                            borderTop: 'solid transparent 5px'
                            borderBottom: 'solid transparent 5px'
                            borderLeft: "solid #{theme.colors.dark} 5px"
                            width: 0
                            height:0

                e 'div',
                    className: 'myoui popup_menu'
                    key: props.id
                    onMouseUp: (event)-> event.stopPropagation()
                    style: {
                        mixins.columnFlex...
                        alignItems: 'flex-start'
                        position: 'absolute'
                        top: 0
                        left: 0
                        overflow: 'hidden'
                        theme.popupMenu(props.enabled)...
                    }

                    for item in props.menu
                        do (item)=>
                            # the default onMouseOver closes all the sub-pums
                            item.onMouseOver = =>
                                props.pum_manager._close_all_pums_of(props)
                                props.pum_manager.update()

                            if item.pum
                                # close all the sub pums and after open this sub-pum
                                item.onMouseOver = (event)=>
                                    element = event.currentTarget
                                    item.pum.parent_element = element
                                    props.pum_manager._close_all_pums_of(props)
                                    item.pum.enable()
                                UI = item.UI or 'Button'
                                e myoui[UI], item, triangle
                            else
                                UI = item.UI or 'Button'
                                e myoui[UI], item

        class Component extends React.Component
            componentDidMount: ->
                pum_manager.update = @forceUpdate.bind @
            render: ->
                {pums, active, zIndex} = pum_manager
                e 'div',
                    className: 'myoui popup_menu_manager'

                    onMouseUp: (event) ->
                        to_close  = for key in active then key
                        # iterate over a copy of the "active" array, because
                        # when the active menu is closed it is being removed
                        # from the array changing the index of the rest of items
                        for key in to_close
                            pum = pums[key]
                            if pum.onClose?
                                event.persist()
                                pum.onClose(event)
                            pum_manager.disable key
                            event.stopPropagation()
                        pum_manager.update()

                    style:
                        position: 'fixed'
                        top: '0px'
                        left: '0px'
                        width: "100vw"
                        height: '100vh'
                        display: if active.length then 'block' else 'none'
                        zIndex: zIndex

                    for key in active
                        pum = pums[key]
                        pum.key = pum.id = key
                        pum.pum_manager = pum_manager
                        e PopupMenu, pum


        @reactElement = e Component
    register: (key, pum)->
        pum.id = key

        pum.enable = (top,left)=>
            pum.top = top or pum.top
            pum.left = left or pum.left
            @enable key
            @update()

        pum.disable = =>
            @disable key
            @update()

        # registering sub pums
        for item in pum.menu
            item.key = item.id = key + '.item_' + pum.menu.indexOf item
            item.useHighlight =
                if item.useHighlight?
                    item.useHighlight
                else
                    @useHighlight

            if item.menu?.length
                pum_key = item.key + '.pum'
                sub_pum = {
                    key:pum_key
                    id:pum_key
                    menu:item.menu
                    }
                pum.pums = pum.pums or []
                pum.pums.push sub_pum
                @register pum_key, sub_pum
                item.pum = sub_pum

        @pums[key] = pum
        return pum

    unregister: (key)->
        @disable key
        delete @pums[key]

    enable: (key)=>
        @disable key
        @pums[key].enabled = true
        @active.push key

    disable: (key)=>
        pum = @pums[key]
        if key in @active
            @_close_all_pums_of pum
            pum.enabled = false

            #remove
            i = @active.indexOf key
            if i!= -1
                @active.splice i, 1

    # close all sub pums of a pum
    _close_all_pums_of: (pum)=>
        if not pum.pums?
            return
        for sub_pum in pum.pums
            @disable sub_pum.id
            if sub_pum.pums?
                @_close_all_pums_of sub_pum

get_screen_overflow = (element)->
    # corrections to fit the window
    {top, left} = element.getClientRects()[0]

    # offsetHeight and offsetWidth are not affected by animation scaling
    height = element.offsetHeight
    width = element.offsetWidth

    # overflow calc
    top_overflow = Math.max(top + height - innerHeight, 0)
    left_overflow= Math.max(left + width - innerWidth, 0)

    return {top, left, width, height, top_overflow, left_overflow}

module.exports = PopupMenuManager
