JavaImporter = require '../lib/java-importer'
ImporterView = require '../lib/java-importer-view'

describe 'JavaImporter', ->
  [workspaceElement, activationPromise, view] = []
  
  describe 'Should have all commands', ->
    it 'Should be activated without problem', ->
      #atom.project.setPaths(["#{__dirname}/test"])
      waitsForPromise ->
        atom.packages.activatePackage('java-importer')
      runs ->
        expect(atom.packages.isPackageActive('java-importer')).toBe true
