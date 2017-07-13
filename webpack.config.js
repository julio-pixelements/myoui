'use strict'
var webpack = require('webpack');
// generating banner
var fs = require('fs');
var license = fs.readFileSync('./LICENSE', 'utf8').toString()

var config = {
    output: {
        path: __dirname + '/build',
        filename: '[name].js',
        libraryTarget: "commonjs2",
    },
    context: __dirname,
    entry: {
        myoui: './main.coffee',
        default_fonts: './styles/default_theme/add_default_fonts.coffee',
        default_animations: './styles/default_theme/add_default_animations.coffee',
    },
    stats: {
        colors: true,
        reasons: true
    },
    module: {
        rules: [
            {
                test: /\.coffee$/,
                loaders: [
                    'coffee-loader',
                ]
            },
            {
                test: /\.(png|jpe?g|gif)$/i,
                loader: 'url-loader?limit=18000&name=[path][name].[ext]',
            },
            {test: /\.svg$/, loader: 'url-loader?mimetype=image/svg+xml'},
            {test: /\.json$/, loader: 'json-loader'},
            {test: /\.html$/, loader: 'raw-loader'},
            {test: /\.woff2?$/, loader: 'url-loader?mimetype=application/font-woff'},
            {test: /\.eot$/, loader: 'url-loader?mimetype=application/font-woff'},
            {test: /\.ttf$/, loader: 'url-loader?mimetype=application/font-woff'},
            {test: /\.styl$/, loader: 'raw!stylus-loader'},
        ]
    },
    plugins: [
        new webpack.BannerPlugin({banner:license, raw:false}),
        new webpack.BannerPlugin({banner:'"use strict";', raw:true}),
        new webpack.IgnorePlugin(/^(fs|stylus|path|coffee-script)$/),
    ],
    resolve: {
        extensions: [".webpack.js", ".web.js", ".js", ".coffee", ".json"],
    },
}

module.exports = (env) => {
    if(env && (env.prod)){
        config.plugins.push(new webpack.optimize.UglifyJsPlugin({
            minimize: true,
            mangle: true,
            compress: {
        		sequences: true,
        		dead_code: true,
        		conditionals: true,
        		booleans: true,
        		unused: true,
        		if_return: true,
        		join_vars: true,
        		drop_console: true
                }
            })
        )
    }else{
        config.module.rules[0].loaders.unshift('source-map-loader');
        config.devtool = 'cheap-module-eval-source-map';
    }
    return config

}
