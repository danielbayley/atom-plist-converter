{execSync,exec} = require 'child_process'

module.exports = activate: ->
	atom.workspace.observeTextEditors (editor) ->

		plist = editor.getPath()
		#if editor.getGrammar().scopeName == 'text.xml.plist' #source.plist
		if /\.(plist|strings)$/.test plist

			# Convert from binary to XML for editing
			buffer = execSync "plutil -convert xml1 -o - '#{plist}'"
			editor.setText buffer.toString()
			#exec "plutil -convert xml1 '#{plist}'"

			# Convert back to binary from XML
			editor.onDidDestroy -> #onDidSave
			#editor.buffer.onWillSave ->
				exec "plutil -convert binary1 '#{plist}'"
				#exec "plutil -convert binary1 -o - > '#{plist}'" #sudo?
