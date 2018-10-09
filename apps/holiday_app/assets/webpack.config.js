const path = require('path');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: './js/app.js',
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
         test: /\.(scss)$/,
         use: [{
           loader: 'style-loader', // inject CSS to page
         }, {
           loader: 'css-loader', // translates CSS into CommonJS modules
         }, {
           loader: 'postcss-loader', // Run post css actions
           options: {
             plugins: function () { // post css plugins, can be exported to postcss.config.js
               return [
                 require('precss'),
                 require('autoprefixer')
               ];
             }
           }
         }, {
           loader: 'sass-loader' // compiles Sass to CSS
         }]
       },
       {
         test: /\.css$/,
         use: [MiniCssExtractPlugin.loader, 'css-loader']
       }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }]),
    new webpack.ProvidePlugin({$: "jquery",jQuery: "jquery"})
  ]
});
