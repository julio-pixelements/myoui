if(process.browser){ //Webpack code
    module.exports = require('./noco-loader!./main.coffee');
}else {  //Electron code
    var req = eval('require');
    req('coffee-script/register');
    module.exports = req('./main.coffee');
}
