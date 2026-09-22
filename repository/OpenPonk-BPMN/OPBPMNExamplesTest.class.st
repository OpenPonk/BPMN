Class {
	#name : 'OPBPMNExamplesTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNExamplesTest >> setUp [
	super setUp.
	workbench := nil
]

{ #category : 'running' }
OPBPMNExamplesTest >> tearDown [
	workbench ifNotNil: [ :activeWorkbench | 
		activeWorkbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPBPMNExamplesTest >> testEmptyModel [
	| model |
	model := OPBPMNExamples emptyModel.
	self assert: model class equals: OPBPMNModel.
	self assertEmpty: model elements
]

{ #category : 'tests' }
OPBPMNExamplesTest >> testEssentialChildrenModelsResolvesAllElements [
	| model modelViewModel essentialElements expectedClasses presentClasses |
	model := OPBPMNExamples exampleOrderFulfillment.
	modelViewModel := OPBPMNModelViewModel new model: model.
	essentialElements := modelViewModel essentialChildrenModels.
	expectedClasses := { 
		OPBPMNPoolModel . OPBPMNStartEventModel . OPBPMNActivityModel . 
		OPBPMNGatewayModel . OPBPMNIntermediateEventModel . OPBPMNSubProcessModel . 
		OPBPMNCollapsedSubProcessModel . OPBPMNBoundaryEventModel . OPBPMNEndEventModel . 
		OPBPMNDataObjectModel . OPBPMNAnnotationModel . OPBPMNFlowModel . 
		OPBPMNMessageFlowModel . OPBPMNDataFlowModel . OPBPMNAssociationModel } asSet.
	presentClasses := (essentialElements collect: [ :element | element class ]) asSet.
	self assertCollection: presentClasses includesAll: expectedClasses
]

{ #category : 'tests' }
OPBPMNExamplesTest >> testExampleOrderFulfillmentContainsAllElementTypes [
	| model allElements expectedClasses presentClasses |
	model := OPBPMNExamples exampleOrderFulfillment.
	allElements := model allElements.
	expectedClasses := { 
		OPBPMNPoolModel . OPBPMNStartEventModel . OPBPMNActivityModel . 
		OPBPMNGatewayModel . OPBPMNIntermediateEventModel . OPBPMNSubProcessModel . 
		OPBPMNCollapsedSubProcessModel . OPBPMNBoundaryEventModel . OPBPMNEndEventModel . 
		OPBPMNDataObjectModel . OPBPMNAnnotationModel . OPBPMNFlowModel . 
		OPBPMNMessageFlowModel . OPBPMNDataFlowModel . OPBPMNAssociationModel } asSet.
	presentClasses := (allElements collect: [ :element | element class ]) asSet.
	self assertCollection: presentClasses includesAll: expectedClasses
]

{ #category : 'tests' }
OPBPMNExamplesTest >> testOpenExampleRendersControllersForAllElements [
	| exampleProcessModel activeDiagramController missingControllers unrenderedControllers |
	exampleProcessModel := OPBPMNExamples exampleOrderFulfillment.
	workbench := OPBPMNExamples openExample: exampleProcessModel.
	self assert: workbench focusedEditor isNotNil description: 'Workbench must have a focused editor after opening example'.
	activeDiagramController := workbench focusedEditor diagramController.
	missingControllers := OrderedCollection new.
	unrenderedControllers := OrderedCollection new.
	exampleProcessModel allElements asSet do: [ :eachDomainElement | 
		activeDiagramController
			controllerForModel: eachDomainElement
			ifFound: [ :elementController | 
				(elementController diagramElement isNil or: [ elementController diagramElement isRendered not ])
					ifTrue: [ unrenderedControllers add: eachDomainElement ] ]
			ifNone: [ missingControllers add: eachDomainElement ] ].
	self
		assert: missingControllers isEmpty
		description: (String streamContents: [ :stream | 
			stream << 'Missing controllers ('.
			stream print: missingControllers size.
			stream << '): '.
			missingControllers do: [ :eachMissing | 
				stream cr.
				stream << '  - '.
				stream << eachMissing class name asString.
				stream << ' (name: ''' , (eachMissing name ifNil: [ '' ]) , ''')' ] ]).
	self
		assert: unrenderedControllers isEmpty
		description: (String streamContents: [ :stream | 
			stream << 'Unrendered diagram elements ('.
			stream print: unrenderedControllers size.
			stream << '): '.
			unrenderedControllers do: [ :eachUnrendered | 
				stream cr.
				stream << '  - '.
				stream << eachUnrendered class name asString.
				stream << ' (name: ''' , (eachUnrendered name ifNil: [ '' ]) , ''')' ] ]).
	self deny: workbench projectController undoManager canUndo description: 'Example initialization must have clean undo history'
]
