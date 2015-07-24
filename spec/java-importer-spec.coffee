JavaImporter = require '../lib/java-importer'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "JavaImporter", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    waitsForPromise ->
      atom.packages.activatePackage('java-importer')

  describe "Should have all commands", ->
    it 'Should be activated without problem', ->
      expect(atom.packages.isPackageActive('java-importer')).toBe true
