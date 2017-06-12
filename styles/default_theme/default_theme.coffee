
mixins = require '../mixins.coffee'

# global:
class Theme
    constructor: ->
        @spacing = spacing = 10

        @fontStyles = fontStyles =
            p:
                fontSize: 15
                fontWeight: 400
            pBold:
                fontSize: 15
                fontWeight: 600
            titleLight:
                fontSize: 60
                fontWeight: 300
            titleLightM:
                fontSize:30
                fontWeight: 300
            titleLightS:
                fontSize: 20
                fontWeight: 300
            titleLightXS:
                fontSize: 15
                fontWeight: 300

        @colors = colors =
            t1: '#5f5f5f'
            light: '#efefef'
            gray: '#d5d5d5'
            dark: '#838383'
            very_dark: '#3f3f3f'
            purple: '#c188cf'
            blue: '#94bdec'
            orange: '#db8851'
            green: '#b1c151'
            yellow: '#eec151'
            red: '#f16b5c'

        @socketColors = socketColors =
            basic: 'white'
            float: mixins.chroma(@colors.green).brighten(0.1)
            int: mixins.chroma(@colors.green).brighten(1)
            bool: @colors.yellow
            string: @colors.blue
            vector: @colors.purple
            collection: @colors.red

        @shadows = shadows =
            long: '0 5px 40px rgba(0,0,0,0.5)'
            soft: '0 5px 20px rgba(0,0,0,0.5)'
            hard: '0 5px 8px rgba(0,0,0,0.3)'
            small: '0 0 8px rgba(0,0,0,0.5)'
            smallSoft: '0 0 8px rgba(0,0,0,0.2)'
            insetSoft: 'inset 0 0 20px rgba(0,0,0,0.5)'
            insetSmall: 'inset 0 0 4px rgba(0,0,0,0.5)'
            insetHard: 'inset 0 0 8px rgba(0,0,0,1)'
            textSoft: '2px 2px 4px rgba(0,0,0,0.5)'
            text: '1px 1px 0px rgba(0,0,0,0.5)'
            textWhite: '1px 1px 0px white'

        @radius = radius =
            r1: 3
            r2: 5
            r3: 7
            r4: 9

        @invalidInput = invalidInput =
            background: mixins.chroma(colors.red).brighten(0.6)

        # UI elements:

        @UIElement = [
            minHeight: 44
            paddingBottom: spacing
            paddingTop: spacing
            paddingLeft: spacing
            paddingRight: spacing
            color: colors.t1
            fontStyles.p
            textShadow: shadows.textWhite
            background: 'transparent'
        ]

        @UIElementContainer = (disabled, useHighlight, forceHighlight)-> [
            if useHighlight
                ':hover': [
                    mixins.boxShadow shadows.smallSoft
                    background: 'white'
                    color: 'black' # it's not working
                    ]
            if forceHighlight
                [
                    mixins.boxShadow shadows.smallSoft
                    background: 'white'
                    color: 'black' # it's not working
                ]
            mixins.transition '250ms', 'background shadow width'
            if disabled
                opacity: 0.5
                pointerEvents: 'none'
            else
                opacity: 1
                pointerEvents:'all'
        ]

        @icon =
            margin: "#{-spacing}px #{spacing/2}px #{-spacing}px #{-spacing/2}px"

        @label = (maxWidth=200, textAlign='center')->
            maxWidth: maxWidth
            margin: "0px #{spacing}px"
            whiteSpace: 'pre-wrap'
            textAlign: textAlign


        @textInput = [
            color: colors.t1
            fontStyles.p
            borderRadius: radius.r1
            background: mixins.chroma(colors.light).darken(0.2)
            borderLeft: 'none' # to disable default style
            mixins.border3d 0.1, '1px', true
            outline: 'none'
        ]

        @button = {}

        @slider =
            props:
                barColor: (f=0) ->
                    mixins.colorInterpolation(colors.red, colors.green, f)
            slider: null
            value: [
                width: 70
                height: 24
                mixins.rowFlex
                @textInput
            ]
            label:{maxWidth: 100}

            bar: (color, allowTransitions, flip)-> [
                mixBlendMode: 'multiply'
                height: "100%"
                minWidth: "4px"
                background: color
                borderRadius: if flip then "#{radius.r2}px 0 0 #{radius.r2}px" else "0 #{radius.r2}px #{radius.r2}px 0"
                mixins.boxShadow shadows.smallSoft
                mixins.border3d 0.1, '1px'
                if allowTransitions then mixins.transition '0.1s', 'width'
                transformOrigin: "left"
                # animation 'unhide_zoom', '0.5s'
                ]

        @switch =
            props:
                radius: 12 # border radius
                buttonWidth: 24 # button width
                containerBaseWidth: 24 # base width of the widget (without the extremes)
                borderWidth: 1 # size of the 3d border
                containerHeight: 24 # height of the widget
                switchColor: (f)->
                    mixins.colorInterpolation(colors.red, colors.green, f)
            container: (borderWidth)-> [
                background: mixins.chroma(colors.light).darken(0.2)
                mixins.border3d 0.1, "#{borderWidth}px", true
                ]
            base: (borderWidth, switchColor)-> [
                background: switchColor
                mixins.border3d 0.2, "#{borderWidth}px"
                mixins.boxShadow shadows.small
                mixins.transition '0.25s', 'width color'
                ]
            button: (borderWidth)-> [
                background: colors.light
                mixins.border3d 0.2, "#{borderWidth}px"
                mixins.boxShadow shadows.small
                mixins.transform "scale(0.8)"
                mixins.transition '0.25s', 'transform'
                # animation 'unhide_zoom', '1s'
            ]

        @vector = {
            elementsContainer: (vertical, hasLabel) ->
                if vertical
                    paddingTop: 0
                    paddingRight: 0
                    paddingBottom: 0
                    paddingLeft: 0
                else if hasLabel
                    paddingTop: 0
                    paddingRight: 5
                    paddingBottom: 5
                    paddingLeft: 5
                else
                    paddingTop: 5
                    paddingRight: 5
                    paddingBottom: 5
                    paddingLeft: 5
            element:
                # It's based on sliders and will overwrite the slider's style
                style:
                    minHeight: 30
                    paddingTop: 0
                    paddingRight: 5
                    paddingBottom: 0
                    paddingLeft: 5
                input: (vertical, vectorLength) -> [
                    if not vertical then width: Math.min(300/vectorLength, 50)
                    fontSize: 12
                    height: 20
                    ]
                label:
                    margin: '0px 5px 0px 0px'
                    fontSize: 12
                    height: 16
                container: (vertical) ->
                    minWidth: 0
                    minHeight: 0
                    if not vertical
                        width: 'auto'
                        margin: '0px 5px 0px 0px'
                bar: (vertical) ->
                    if not vertical then borderRadius: radius.r1
        }

        @selector = [
            color: colors.t1
            fontStyles.p
            background: mixins.chroma(colors.light).darken(0.2),
            mixins.border3d 0.1, "1px", true
        ]

        @splitter = {
            style:[
                mixins.border3d 0.3, "1px", true
                width: 'calc(100% - 20px)'
            ]
            title:[
                color: mixins.chroma(colors.dark).brighten(0.1)
                pointerEvents: 'none'
                fontStyles.titleLightXS
            ]
        }

        @popupMenu = (enabled) -> [
            mixins.boxShadow shadows.soft
            # if enabled then animation('unhide_zoom', '250ms') else animation('hide_zoom', '250ms')
            borderRadius: radius.r2
            background: colors.light
            mixins.border3d 0.2, '1px'
            transformOrigin: "top left"
        ]

module.exports = Theme
