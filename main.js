if(process.browser){
    //Webpack code
    if(!window.fetch){
        require('whatwg-fetch');
    }
    module.exports = require('./noco-loader!./pack.coffee');
}else {
    //Electron code
    var req = eval('require');
    req('coffee-script/register');
    // req('./engine/node_fetch_file.coffee');
    module.exports = req('./pack.coffee');
}
