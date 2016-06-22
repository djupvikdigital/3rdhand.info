var YAML = require('js-yaml');
var fs = require('fs');
var path = require('path');
var webpack = require('webpack');
var AssetsPlugin = require('assets-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CleanPlugin = require('clean-webpack-plugin');

var production = process.env.NODE_ENV === 'production';
var server = !production ? 'http://localhost:8080' : '';

var svgoConfig = JSON.stringify(
  YAML.safeLoad(fs.readFileSync(path.resolve(__dirname, 'svgo.yaml')))
);

var plugins = [
  new webpack.DefinePlugin({
    'process.env.NODE_ENV': '"development"',
  }),
  new ExtractTextPlugin('styles.css')
];

if (production) {
  plugins = [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': '"production"',
    }),
    new CleanPlugin(['dist/styles', 'dist/scripts']),
    new AssetsPlugin({ path: path.resolve(__dirname, 'dist') }),
    new ExtractTextPlugin('styles/[contenthash].css'),
    new webpack.optimize.UglifyJsPlugin({
      mangle: true,
      compress: {
        warnings: false
      }
    }),
    new webpack.optimize.OccurenceOrderPlugin()
  ];
}

module.exports = {
  debug: !production,
  devtool: production ? 'source-map' : 'eval',
  module: {
    loaders: [
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/
      },
      {
        test: /\.json$/,
        loader: 'json-loader'
      },
      {
        test: /\.coffee$/,
        loader: 'coffee-loader'
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract(
          'css?sourceMap!' +
          'sass?sourceMap&includePaths[]=' +
            path.resolve(__dirname, 'src', 'styles')
        )
      },
      {
        test: /\.yaml$/,
        loader: 'json-loader!yaml-loader'
      },
      {
        test: /\.svg$/,
        loader: 'raw-loader!svgo-loader?' + svgoConfig
      }
    ],
  },
  resolve: {
    extensions: [
      '',
      '.webpack.js',
      '.web.js',
      '.js',
      '.json',
      '.coffee',
      '.yaml'
    ],
    root: path.resolve(__dirname, 'src', 'scripts'),
    alias: {
      'history/lib/createMemoryHistory': 'history/lib/createBrowserHistory',
      'logo': path.resolve(__dirname, 'src', 'svg', 'logo.svg')
    }
  },
  entry: {
    'scripts': './src/scripts/main.coffee',
    'styles': './src/styles/main.scss'
  },
  plugins: plugins,
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: production ? 'scripts/[chunkhash].js' : '[name].js',
    publicPath: server + '/'
  }
}
