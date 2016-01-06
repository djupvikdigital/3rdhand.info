path = require 'path'
ExtractTextPlugin = require 'extract-text-webpack-plugin'

module.exports = (grunt) ->
	webpackConfig =
		devtool: 'source-map'
		module:
			loaders: [
				{
					test: /\.json$/
					loader: 'json-loader'
				}
				{
					test: /\.coffee$/
					loader: 'coffee-loader'
				}
				{
					test: /\.scss$/
					loader: ExtractTextPlugin.extract(
						'css?sourceMap!' +
						'sass?sourceMap&includePaths[]=' + path.resolve __dirname, 'src/styles'
					)
				}
				{
					test: /\.yaml$/
					loader: 'json-loader!yaml-loader'
				}
			]
		resolve:
			extensions: [ '', '.webpack.js', '.web.js', '.js', '.json', '.coffee' ]
			alias:
				'history/lib/createMemoryHistory': 'history/lib/createBrowserHistory'
		plugins: [
			new ExtractTextPlugin('styles/main.css')
		]
		entry: {
			'scripts/main.js': './src/scripts/index.coffee'
			'styles/main.css': './src/styles/main.scss'
		}
		output:
			path: path.resolve __dirname, 'dist'
			publicPath: 'dist/'
			filename: '[name]'

	grunt.initConfig
		clean: ['dist']
		jade:
			options:
				doctype: 'html'
			dist:
				files: [
					expand: true
					cwd: 'src/'
					dest: 'dist/'
					src: ['**/*.jade']
					ext: '.svg'
				]
		svgmin:
			options:
				js2svg:
					tagShortEnd: ' />'
			dist:
				files: [
					expand: true
					cwd: 'src/svg/'
					dest: 'dist/svg/'
					src: ['*.svg']
				]
		webpack:
			dist:
				options: webpackConfig
		'webpack-dev-server':
			options: 
				webpack: webpackConfig
				publicPath: '/' + webpackConfig.output.publicPath
			start:
				keepAlive: true
				webpack:
					debug: true
					devtool: 'source-map'

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-sass'
	grunt.loadNpmTasks 'grunt-svgmin'
	grunt.loadNpmTasks 'grunt-webpack'

	grunt.registerTask 'default', ['clean', 'jade', 'sass', 'svgmin']
	grunt.registerTask 'dist', ['default', 'webpack']
	grunt.registerTask 'server', ['webpack-dev-server']