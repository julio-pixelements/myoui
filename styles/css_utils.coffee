# Add css to the document.
add_css = (src) ->
    style = document.createElement('style')
    style.innerHTML = src
    style.type = 'text/css'
    document.body.appendChild style

font_face = (family, local_name, weight, style, font_uri) ->
    """@font-face {
      font-family: '#{family}';
      font-style: #{style};
      font-weight: #{weight};
      src: local('#{local_name}'), local('#{font_uri.split('/').pop().split('.')[0]}'), url(#{font_uri}) format('woff');
    }
    """


module.exports = {add_css, font_face}
