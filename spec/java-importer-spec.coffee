JavaImporter = require '../lib/java-importer'
ImporterView = require '../lib/java-importer-view'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'JavaImporter', ->
  [workspaceElement, activationPromise, view] = []
  
  describe 'Should have all commands', ->
    it 'Should be activated without problem', ->
      #atom.project.setPaths(["#{__dirname}/test"])
      waitsForPromise ->
        atom.packages.activatePackage('java-importer')
      runs ->
        expect(atom.packages.isPackageActive('java-importer')).toBe true
