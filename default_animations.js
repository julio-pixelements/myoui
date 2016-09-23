if(process.browser){ //Webpack code
    require('./noco-loader!./styles/default_theme/add_default_animations.coffee');
}else { //Electron code
    var req = eval('require');
    req('coffee-script/register');
    req('./styles/default_theme/add_default_animations.coffee');
}
