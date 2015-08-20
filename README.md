# java-importer package [![Build Status](https://travis-ci.org/CodeMySky/java-importer.svg?branch=master)](https://travis-ci.org/CodeMySky/java-importer)
Project Page: https://atom.io/packages/java-importer 

## How to use:
### Import class
1. install the package using package manager.
2. select the class you want to import.
3. right click and select "Get import statement"
  1. Select appropriate path when there are multiple candidates.
4. Look at the notifications, success: paste the statement to wherever it is appropriate, failed, you should import it manually.

### Organize import statements
1. Select all import statements, select "Organize imports" in Edit menu.
2. Paste the sorted statements and remove the original one.

## Update dictionary manually
1. Press Cmd+Shift+P to open command panel.
2. Type java-importer:update to trigger manual update.

## Attention:
1. Only supports: JAVA 8 classes, and classes in your project, and classes to have used in your project.

## Roadmap:
- Run scan function every hour to catch the latest changes.
- Add extra line break when sorting statements.
- Add function: detect unused statements
- Warn if you have already imported the class.
- Detect libs in local environment and import automatically.

- ~~Detect import statements you once used.~~
- ~~Solve the window freeze problem.~~
- ~~Add more test cases.~~
