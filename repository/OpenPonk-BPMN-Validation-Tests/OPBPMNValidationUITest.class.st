"
Tests headless validation UI highlighting, highlight removal, inspector table and documentation presentations, and model menu validation commands while cleaning up any opened system windows.
"
Class {
	#name : 'OPBPMNValidationUITest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'project',
		'projectController',
		'diagramController',
		'windowsBefore'
	],
	#category : 'OpenPonk-BPMN-Validation-Tests-UI',
	#package : 'OpenPonk-BPMN-Validation-Tests',
	#tag : 'UI'
}

{ #category : 'running' }
OPBPMNValidationUITest >> setUp [

	super setUp.
	windowsBefore := (self currentWorld submorphs select: [ :eachMorph | eachMorph isSystemWindow ]) asIdentitySet.
	model := OPBPMNModel new.
	project := OPProject new.
	project addModel: model.
	projectController := OPProjectController forProject: project.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: (OPOpenPonkDiagram forModelElement: model);
		model: model
]

{ #category : 'running' }
OPBPMNValidationUITest >> tearDown [

	windowsBefore ifNotNil: [
			self currentWorld submorphs copy
				select: [ :eachMorph | eachMorph isSystemWindow and: [ (windowsBefore includes: eachMorph) not ] ]
				thenDo: #delete ].
	diagramController := nil.
	projectController := nil.
	project := nil.
	model := nil.
	windowsBefore := nil.
	super tearDown
]

{ #category : 'tests' }
OPBPMNValidationUITest >> testRemoveValidationHighlightsCommandActivationAndExecute [

	| activity editorDouble command activation activityShape |
	activity := OPBPMNActivityModel new name: 'Highlighted Task'.
	model add: activity.
	diagramController showAllElements.
	activityShape := (diagramController controllerForModel: activity) diagramElement.
	activityShape strokeColor: Color red.

	activation := OPBPMNRemoveValidationHighlightsCommand modelMenuActivation.
	self assert: activation class identicalTo: OPModelMenuActivation.

	editorDouble := Mock new.
	editorDouble stub diagramController willReturn: diagramController.
	command := OPBPMNRemoveValidationHighlightsCommand new.
	self assert: command defaultMenuItemName equals: 'Remove highlights'.
	command prepareFullExecutionInContext: editorDouble.
	command execute.

	self assert: activityShape borderColor equals: Color black
]

{ #category : 'tests' }
OPBPMNValidationUITest >> testUpdateValidatedElementsAndRemoveHighlightsUpdatesColorsAndSkipsNonColoredShapes [

	| activity dataObject annotation results activityShape dataObjectShape |
	activity := OPBPMNActivityModel new name: 'Task'.
	dataObject := OPBPMNDataObjectModel new name: 'Data'.
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	model
		add: activity;
		add: dataObject;
		add: annotation.
	diagramController showAllElements.
	results := OPBPMNValidationController new validate: model.

	OPBPMNValidationUI updateValidatedElements: results using: diagramController.
	activityShape := (diagramController controllerForModel: activity) diagramElement.
	dataObjectShape := (diagramController controllerForModel: dataObject) diagramElement.
	self assert: activityShape borderColor equals: Color red.
	self assert: dataObjectShape borderColor equals: Color orange.

	OPBPMNValidationUI removeHighlightsFromElementsIn: diagramController.
	self assert: activityShape borderColor equals: Color black.
	self assert: dataObjectShape borderColor equals: Color transparent
]

{ #category : 'tests' }
OPBPMNValidationUITest >> testValidateModelCommandActivationAndExecute [

	| activity editorDouble command activation activityShape |
	activity := OPBPMNActivityModel new name: 'Unconnected Task'.
	model add: activity.
	diagramController showAllElements.

	activation := OPBPMNValidateModelCommand modelMenuActivation.
	self assert: activation class identicalTo: OPModelMenuActivation.

	editorDouble := Mock new.
	editorDouble stub diagramController willReturn: diagramController.
	command := OPBPMNValidateModelCommand new.
	self assert: command defaultMenuItemName equals: 'Validate model'.
	command prepareFullExecutionInContext: editorDouble.
	command execute.

	activityShape := (diagramController controllerForModel: activity) diagramElement.
	self assert: activityShape borderColor equals: Color red
]

{ #category : 'tests' }
OPBPMNValidationUITest >> testValidationResultsUIInspectorPresentationsAndSelectionHighlight [

	| activity annotation results resultsUI builder resultsTable docsTable activityShape selectedObject |
	activity := OPBPMNActivityModel new name: 'Task'.
	annotation := OPBPMNAnnotationModel new text: 'Unconnected Note'.
	model
		add: activity;
		add: annotation.
	diagramController showAllElements.
	results := OPBPMNValidationController new validate: model.
	resultsUI := OPBPMNValidationResultsUI createUIFor: results withControllers: diagramController.
	self assert: resultsUI validationResults identicalTo: results.

	activityShape := (diagramController controllerForModel: activity) diagramElement.
	resultsUI changeElementColor: activity toColor: nil.
	self assert: activityShape borderColor equals: Color black.

	resultsUI highlightElement: annotation.
	self assert: resultsUI highlighted identicalTo: annotation.

	builder := SpPresenter newApplication: SpApplication defaultApplication.
	resultsTable := resultsUI inspectorTableIn: builder.
	self assert: resultsTable items size equals: results results size.
	resultsTable selectIndex: 1.
	selectedObject := resultsTable items first objectReference.
	self assert: resultsUI highlighted identicalTo: selectedObject.

	resultsUI notifySelectChanged: nil.
	self assert: resultsUI highlighted identicalTo: selectedObject.

	docsTable := resultsUI inspectorDocumentationReferenceIn: builder.
	self assert: docsTable items size equals: 1.
	self
		assert: (docsTable items first includesSubstring: 'validation-rules.md')
		description: 'Documentation presentation must link to validation-rules.md'
]

{ #category : 'tests' }
OPBPMNValidationUITest >> testValidationUIHandlesControllerWithNilDiagramElement [

	| bareController results resultsUI activity |
	activity := OPBPMNActivityModel new name: 'Detached'.
	bareController := OPBPMNActivityController new.
	bareController
		diagramController: diagramController;
		model: activity.
	results := OPBPMNValidationResults new.

	OPBPMNValidationUI changeElementColorTo: Color red using: bareController.
	OPBPMNValidationUI updateValidatedElementStyle: results using: bareController.
	self deny: bareController diagramElement exists description: 'Bare controller must hold non-existent OPNoShape diagramElement'.

	diagramController controllers add: bareController.
	resultsUI := OPBPMNValidationResultsUI createUIFor: results withControllers: diagramController.
	self
		assert: (resultsUI getElementColor: activity) isNil
		description: 'Controller without existing diagramElement must report nil color'
]
