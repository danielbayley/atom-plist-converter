{exec} = require 'child_process'

subs = null
activate = =>
  sp = require 'simple-plist'
  subs = atom.workspace.observeTextEditors (editor) =>
    plist = editor.getPath()
    {scopeName} = editor.getGrammar()

    if /plist|strings/.test scopeName
      [line] = editor.buffer?.getLines()
      switch
        when line?.startsWith 'bplist00'
          data = sp.readFileSync plist
          format = 'binary1'

        when line?.startsWith '{'
          data = JSON.parse editor.getText()
          format = 'json'
        else return

      editor.save()
      editor.setText sp.stringify data

      editor.onDidDestroy => # Recompile to original format.
        exec "plutil -convert #{format} '#{plist}'"

deactivate = => subs.dispose()
#-------------------------------------------------------------------------------
module.exports = {activate, deactivate}
