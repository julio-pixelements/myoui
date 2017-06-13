
css_utils = require '../css_utils.coffee'

font_faces = font_faces or [
        # font_face 'roboto', 'Roboto thin', 100, 'normal', require './fonts/roboto/Roboto-Thin.woff'
        # font_face 'roboto', 'Roboto thin Italic', 100, 'normal', require './fonts/roboto/Roboto-ThinItalic.woff'
        css_utils.font_face 'Roboto', 'Roboto Light', 300, 'normal', require './fonts/roboto/Roboto-Light.woff'
        # font_face 'Roboto', 'Roboto Light Italic', 300, 'italic', require './fonts/roboto/Roboto-LightItalic.woff'
        css_utils.font_face 'Roboto', 'Roboto Regular', 400, 'normal', require './fonts/roboto/Roboto-Regular.woff'
        # font_face 'Roboto', 'Roboto Italic', 400, 'italic', require './fonts/roboto/Roboto-Italic.woff'
        # font_face 'Roboto', 'Roboto Bold', 700, 'normal', require './fonts/roboto/Roboto-Bold.woff'
        # font_face 'Roboto', 'Roboto Bold Italic', 700, 'italic', require './fonts/roboto/Roboto-BoldItalic.woff'
        # font_face 'Roboto', 'Roboto Black', 900, 'normal', require './fonts/roboto/Roboto-Black.woff'
        # font_face 'Roboto', 'Roboto Black Italic', 900, 'italic', require './fonts/roboto/Roboto-BlackItalic.woff'

    ].join '\n'

# setting Roboto font-family as global myoui style
global_font_family = '''
    .myoui * {
        font-family: 'Roboto', 'sans-serif';
      }
    .myoui {
        font-family: 'Roboto', 'sans-serif';
      }
    '''


css_utils.add_css font_faces + global_font_family
