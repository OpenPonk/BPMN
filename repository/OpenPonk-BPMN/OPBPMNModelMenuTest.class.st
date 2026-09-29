Class {
	#name : 'OPBPMNModelMenuTest',
	#superclass : 'TestCase',
	#instVars : [
		'toolbarPresenter',
		'mockWorkbench',
		'mockProjectController',
		'mockUndoManager',
		'undoAnnouncer'
	],
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNModelMenuTest >> setUp [
	super setUp.
	undoAnnouncer := Announcer new.
	mockUndoManager := Mock new.
	mockUndoManager stub announcer willReturn: undoAnnouncer.
	mockUndoManager stub canUndo willReturn: false.
	mockUndoManager stub canRedo willReturn: false.
	mockUndoManager stub undoStack willReturn: OrderedCollection new.
	mockUndoManager stub redoStack willReturn: OrderedCollection new.
	mockProjectController := Mock new.
	mockProjectController stub undoManager willReturn: mockUndoManager.
	mockWorkbench := Mock new.
	mockWorkbench stub projectController willReturn: mockProjectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	toolbarPresenter := OPWorkbenchToolbar newApplication: SpApplication defaultApplication.
	toolbarPresenter owner: mockWorkbench
]

{ #category : 'running' }
OPBPMNModelMenuTest >> tearDown [
	toolbarPresenter := nil.
	mockWorkbench := nil.
	mockProjectController := nil.
	mockUndoManager := nil.
	undoAnnouncer := nil.
	super tearDown
]

{ #category : 'tests' }
OPBPMNModelMenuTest >> testModelMenuContainsBpmnCommanderActivationsWhenBpmnEditorFocused [
	"Verifies that the Model menu contains BPMN-specific Commander 1 commands when a BPMN editor is focused."
	| bpmnPlugin testEditor modelMenuItem allMenuItems validationMenuItem validationSubMenu validationItemLabels |
	bpmnPlugin := OPBPMNPlugin new.
	testEditor := (OPEditor on: bpmnPlugin)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachTopMenuItem | eachTopMenuItem name = 'Model' ].
	allMenuItems := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachTopGroup | eachTopGroup menuItems ].

	self assertCollection: (allMenuItems collect: [ :eachItem | eachItem name ])
		includesAll: #( 'Simulation' 'Validations' 'Export as XML...' ).

	validationMenuItem := allMenuItems detect: [ :eachValidItem | eachValidItem name = 'Validations' ].
	validationSubMenu := validationMenuItem subMenu.
	validationItemLabels := validationSubMenu menuGroups
		flatCollect: [ :eachSubGroup | eachSubGroup menuItems collect: [ :eachSubItem | eachSubItem name ] ].

	self assertCollection: validationItemLabels hasSameElements: #( 'Validate model' 'Remove highlights' )
]
