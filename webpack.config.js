const YAML = require('js-yaml');
const fs = require('fs');
const path = require('path');
const webpack = require('webpack');
const AssetsPlugin = require('assets-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CleanPlugin = require('clean-webpack-plugin');

const production = process.env.NODE_ENV === 'production';
const server = !production ? 'http://localhost:8080' : '';

const svgoConfig = JSON.stringify(
  YAML.safeLoad(fs.readFileSync(path.resolve(__dirname, 'svgo.yaml')))
);

let plugins = [
  new webpack.DefinePlugin({
    'process.env.NODE_ENV': '"development"',
  }),
  new ExtractTextPlugin('styles.css'),
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
        warnings: false,
      },
    }),
    new webpack.optimize.OccurenceOrderPlugin(),
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
        exclude: /node_modules/,
      },
      {
        test: /\.json$/,
        loader: 'json-loader',
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract(
          [
            'css?sourceMap!',
            'sass?sourceMap&includePaths[]=',
            path.resolve(__dirname, 'src', 'styles'),
          ].join('')
        ),
      },
      {
        test: /\.yaml$/,
        loader: 'json-loader!yaml-loader',
      },
      {
        test: /\.svg$/,
        loader: `raw-loader!svgo-loader?${svgoConfig}`,
      },
    ],
  },
  resolve: {
    root: path.resolve(__dirname, 'src', 'scripts'),
    alias: {
      'history/lib/createMemoryHistory': 'history/lib/createBrowserHistory',
      logo: path.resolve(__dirname, 'src', 'svg', 'logo.svg'),
    },
  },
  entry: {
    scripts: './src/scripts/main.js',
    styles: './src/styles/main.scss',
  },
  plugins,
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: production ? 'scripts/[chunkhash].js' : '[name].js',
    publicPath: `${server}/`,
  },
};
