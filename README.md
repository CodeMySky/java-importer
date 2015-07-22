# java-importer package

## How to use:
1. install the package
2. select the class you want to import
3. right click and select "Get import statement"
  1. Select appropriate path when there are multiple candidates.
4. Look at the notifications, success: paste the statement to wherever it is appropriate, failed, you should import it manually.

### Organize import statements
1. Select all import statements, right click and select "Organize import statements" in context menu.
2. Paste the sorted statements and remove the original one.

## Attention:
1. Initialization may takes a long time when the project is big, the window may freeze.
2. Only supports: JAVA 8 classes, and classes in your project.

## Roadmap:
1. Solve the window freeze problem
2. Add extra line break when sorting statements.
3. Add function: detect unused statements
4. Detect libs in local environment and import automatically.
