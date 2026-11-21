"
Verifies the population, activation state, and command execution within the BPMN editor toolbar menu.
"
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
	#category : 'OpenPonk-BPMN-Tests-Commands',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Commands'
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
OPBPMNModelMenuTest >> testChangeLaneHeightsCommandDefaultDescription [

	| command |
	command := OPBPMNChangeLaneHeightsCommand new.
	self assert: command defaultDescription equals: 'Move Lane Separator'
]

{ #category : 'tests' }
OPBPMNModelMenuTest >> testExportPackagePassesModelOrControllerToExportDialogWithFallbackName [

	| capturedBlock capturedFileName capturedExtensions capturedFilterName capturedTitle bpmnModel project projectController diagramController controllerModel emptyModel |
	(OPExportFileDialog stub
		 exportBlock: Any
		 defaultFileName: Any
		 extensions: Any
		 named: Any
		 title: Any) will: [ :exportBlock :defaultFileName :extensions :filterName :dialogTitle |
			capturedBlock := exportBlock.
			capturedFileName := defaultFileName.
			capturedExtensions := extensions.
			capturedFilterName := filterName.
			capturedTitle := dialogTitle ].

	bpmnModel := OPBPMNModel named: 'Order / Process'.
	OPBPMNPlugin exportPackage: bpmnModel.
	self assert: capturedFileName equals: (FileNameSanitizer sanitize: 'Order / Process') , '.bpmn'.
	self assert: capturedExtensions equals: #( bpmn xml ).
	self assert: capturedFilterName equals: 'BPMN XML files'.
	self assert: capturedTitle equals: 'Choose a BPMN file to export to'.
	self
		assert: (capturedBlock value includesSubstring: '<bpmn:definitions')
		description: 'Export block must serialize BPMN XML definitions'.

	controllerModel := OPBPMNModel named: 'Controller Model'.
	project := OPProject named: 'Export Test'.
	project addModel: controllerModel.
	projectController := OPProjectController forProject: project.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: controllerModel.
	OPBPMNPlugin exportPackage: diagramController.
	self assert: capturedFileName equals: 'Controller Model.bpmn'.

	emptyModel := OPBPMNModel new name: '   '.
	OPBPMNPlugin exportPackage: emptyModel.
	self assert: capturedFileName equals: 'export.bpmn'
]

{ #category : 'tests' }
OPBPMNModelMenuTest >> testExportXmlCommandActivationAndExecutionDelegatesToPlugin [

	| activation mockDiagramController mockEditor exportCommand exportedTarget toolContext |
	activation := OPBPMNExportXmlCommand modelMenuActivation.
	self assert: activation menuGroup identicalTo: OPModelBasicMenuGroup.
	self assert: activation menuItemOrder equals: 30.

	mockDiagramController := Mock new.
	mockEditor := Mock new.
	mockEditor stub diagramController willReturn: mockDiagramController.
	exportedTarget := nil.
	(OPBPMNPlugin stub exportPackage: Any) will: [ :aTarget | exportedTarget := aTarget ].

	exportCommand := OPBPMNExportXmlCommand new.
	toolContext := CmdSimpleToolContext for: mockEditor.
	CmdCommandActivator new
		command: exportCommand;
		context: toolContext;
		executeCommand.
	self assert: exportedTarget identicalTo: mockDiagramController
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
