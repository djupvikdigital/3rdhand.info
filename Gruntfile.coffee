path = require 'path'

module.exports = (grunt) ->
	webpackConfig = 
		module:
			loaders: [
				test: /\.coffee$/
				loader: 'coffee-jsx-loader'
			]
		entry: './src/scripts/index.coffee'
		output:
			path: path.join(__dirname, 'dist/scripts')
			publicPath: 'dist/scripts/'
			filename: '[name].js'

	grunt.initConfig
		clean: ['dist']
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
	grunt.loadNpmTasks 'grunt-svgmin'
	grunt.loadNpmTasks 'grunt-webpack'

	grunt.registerTask 'default', ['clean', 'svgmin', 'webpack']
	grunt.registerTask 'server', ['webpack-dev-server']