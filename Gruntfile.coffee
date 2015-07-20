path = require 'path'
ExtractTextPlugin = require 'extract-text-webpack-plugin'

module.exports = (grunt) ->
	webpackConfig =
		devtool: 'source-map'
		module:
			loaders: [
				{
					test: /\.(coffee|cjsx)$/
					loader: 'coffee-jsx-loader'
				}
				{
					test: /\.scss$/
					loader: ExtractTextPlugin.extract(
						'css?sourceMap!' +
						'sass?sourceMap'
					)
				}
			]
		plugins: [
			new ExtractTextPlugin('styles/main.css')
		]
		entry: {
			'./src/scripts/index.coffee'
			'./src/styles/main.scss'
		}
		output:
			path: path.join(__dirname, 'dist')
			publicPath: 'dist/'
			filename: '[name].js'

	grunt.initConfig
		clean: ['dist']
		jade:
			dist:
				files: [
					expand: true
					cwd: 'src/'
					dest: 'dist/'
					src: ['**/*.jade']
					ext: '.svg'
				]
		svgmin:
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