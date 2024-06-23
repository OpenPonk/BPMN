Class {
	#name : 'OPBPMNValidationWorkbench',
	#superclass : 'SpPresenter',
	#instVars : [
		'editors',
		'notebook',
		'topToolbar',
		'focusedEditor',
		'diagramsList',
		'pluginRegistry',
		'projectTree',
		'project',
		'projectController'
	],
	#classInstVars : [
		'isDevelopmentMode'
	],
	#category : 'OpenPonk-BPMN-Validation-Extensions',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Extensions'
}

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newTopToBottom
				   add: #topToolbar;
				   yourself)
		  expand: false;
		  add: (SpPanedLayout newLeftToRight
				   add: (SpPanedLayout newTopToBottom
						    add: #projectTree;
						    add: #diagramsList;
						    yourself);
				   positionOfSlider: self initialListsWidth;
				   add: (SpBoxLayout newTopToBottom
						    add: #notebook;
						    yourself);
				   yourself);
		  yourself
]

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> initialExtent [

	^ self currentWorld extent * 0.8 min: 1600 @ 1000
]

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> initialListsWidth [

	^ 250
]

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> isDevelopmentMode [

	^ OPWorkbench isDevelopmentMode
]

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> open [

	^ (self newApplication: OPApplication new) open
]

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> openModel: aModel [
	| project |
	project := OPProject new.
	project name: 'Click Project'.
	project addModel: aModel.
	^ self open
		openProject: project;
		yourself
]

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> openProject: aProject [

	^ (self newApplication: OPApplication new)
		  openProject: aProject;
		  yourself
]

{ #category : 'layout' }
OPBPMNValidationWorkbench class >> verificationFrameworkSettingsGroups: aBuilder [

	"I create groups for anti-patterns and verifications."

	<systemsettings>
	"(aBuilder group: #antipatterns)
		label: 'Anti-patterns';
		parent: #openponk;
		order: 250."
	"(aBuilder group: #bpmnValidations)
		label: 'BPMN Validations';
		parent: #openponk;
		order: 240"
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> closeEditorOfDiagram: aDiagram [

	editors
		at: aDiagram
		ifPresent: [ :editorInfo | 
		notebook removePage: (editorInfo at: #page) ]
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> closedTabOfEditor: anEditor [

	self projectController updateDiagram:
		anEditor diagramController diagramElement.
	anEditor tabDeleted.
	topToolbar activeEditor: nil.
	editors removeKey: anEditor diagramController diagram.
	anEditor diagramController diagram isSelected: false.
	focusedEditor = anEditor ifTrue: [ 
		focusedEditor := nil.
		self announce: (OPEditorUnfocused on: anEditor) ].
	self announce: (OPEditorClosed on: anEditor)
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> connectPresenters [

	super connectPresenters.
	notebook
		whenSelectedPageChangedDo: [ :newPage | 
			self focusEditorOf: (editors associations detect: [ :pair | 
							 (pair value at: #page) = newPage ]) key ];
		whenPageRemovedDo: [ :page | self pageRemoved: page ]
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> deleteDiagram: aDiagram [
	self closeEditorOfDiagram: aDiagram.
	self projectController removeDiagram: aDiagram
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> diagramsList [
	^ diagramsList
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> focusEditorOf: aDiagram [

	| editorTabInfo |
	(focusedEditor isNotNil and: [ 
		 focusedEditor diagramController diagramElement = aDiagram ]) 
		ifTrue: [ ^ self ].
	editorTabInfo := editors at: aDiagram.
	notebook selectedPage = (editorTabInfo at: #page) ifFalse: [ 
		^ notebook selectPage: (editorTabInfo at: #page) ].

	focusedEditor ifNotNil: [ 
		focusedEditor diagramController diagramElement ifNotNil: [ 
			:oldDiagram | 
			self projectController updateDiagram: oldDiagram.
			oldDiagram isSelected: false ].
		self announce: (OPEditorUnfocused on: focusedEditor) ].
	focusedEditor := editorTabInfo at: #editor.
	aDiagram isSelected: true.
	self announce: (OPEditorFocused on: focusedEditor).
	topToolbar activeEditor: focusedEditor.
	focusedEditor diagramController diagramElement: aDiagram.
	focusedEditor diagramController showElements
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> focusedEditor [
	^ focusedEditor
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> initialize [
	pluginRegistry := OPPluginRegistry default.
	editors := IdentityDictionary new.
	super initialize
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> initializePresenters [

	topToolbar := self instantiate: OPWorkbenchToolbar.
	diagramsList := self instantiate: OPDiagramsList.
	projectTree := self instantiate: OPProjectNavigator.
	notebook := self newNotebook.
	self focusOrder
		add: topToolbar;
		add: diagramsList;
		add: projectTree;
		add: notebook
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> initializeWindow: aWindow [

	aWindow
		windowIcon: OPCoreIcons openponkIcon;
		title: self title;
		initialExtent: self class initialExtent
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> notebook [
	^ notebook
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> openEditorOn: aModel [
	self
		openEditorOnDiagram: (project diagrams detect: [ :each | each model = aModel ])
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> openEditorOnDiagram: aDiagram [

	| editor notebookPage plugin model |
	(self projectController hasDiagram: aDiagram) ifTrue: [ 
		^ self focusEditorOf: aDiagram ].
	model := aDiagram modelElement.
	plugin := pluginRegistry pluginFor: model.
	editor := OPEditor on: plugin.
	editor workbench: self.
	notebookPage := self newNotebookPage.
	notebookPage beCloseable.
	editors at: aDiagram put: { 
			(#editor -> editor).
			(#page -> notebookPage) } asDictionary.
	editor owner: notebook.
	editor openEmptyModel: model.
	(model respondsTo: #whenChanged:) ifTrue: [ 
		model whenChanged: [ 
			notebookPage title: '[' , aDiagram name , '] ' , model name ] ].
	editor palette rebuildWidget.
	notebookPage
		title: '[' , aDiagram name , '] ' , model name;
		icon: plugin icon;
		presenterProvider: [ editor ].
	self announce: (OPEditorCreated on: editor).
	notebook addPage: notebookPage.
	self focusEditorOf: aDiagram.
	^ editor
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> openProject: aProject [

	project := aProject.
	(projectController := aProject controllerClass new)
		project: project;
		workbench: self.
	self hasWindow ifFalse: [ self open ].
	self updateTitle.
	topToolbar updateProjectMenu.
	project whenChanged: [ self updateTitle ].
	self withWindowDo: [ :window | 
		window whenClosedDo: [ project unsubscribe: self ] ].
	diagramsList project: project.
	projectTree openOn: project.
	projectController openDiagrams
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> pageRemoved: aPage [

	"activePresenter is editor"

	self closedTabOfEditor: aPage activePresenter
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> pluginRegistry [
	^ pluginRegistry
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> projectController [
	^ projectController
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> projectTree [
	^ projectTree
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> showAllElementsInAllDiagrams [

	self projectController controllers do: [ :each | 
		each
			showAllElements;
			applyDefaultLayout.
		each canvas extent max <= 500 ifTrue: [ 
			each canvasPresenter whenExtentChangedDo: [ :evt | 
				each zoomToFit.
				each canvasPresenter whenExtentChangedDo: [ :event |  ] ] ] ].
	self projectController controllers do: #zoomToFit
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> title [

	^ project
		  ifNil: [ 'OpenPonk' ]
		  ifNotNil: [ project name , ' - OpenPonk' ]
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> topToolbar [
	^ topToolbar
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> updateTitle [

	^ self withWindowDo: [ :window | window title: self title ]
]

{ #category : 'opening' }
OPBPMNValidationWorkbench >> workbench [
	^ self
]
