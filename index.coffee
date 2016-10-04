{exec} = require 'child_process'

module.exports =
  activate: ->
#-------------------------------------------------------------------------------

    @subs = atom.workspace.observeTextEditors (editor) ->
      buffer = editor.buffer
      plist = buffer.file?.path
      {scopeName} = editor.getGrammar()

      if /\.(plist|strings)$/.test(scopeName) and
        buffer.getLines()[0]?.startsWith 'bplist00'

          # Convert from binary to XML for editing
          {stdout} = exec "plutil -convert xml1 -o - '#{plist}'"
          stdout.on 'data', (XML) -> editor.setText XML

          # Convert back to binary from XML
          editor.onDidDestroy ->
            exec "plutil -convert binary1 '#{plist}'"

#-------------------------------------------------------------------------------
  deactivate: -> @subs.dispose()
