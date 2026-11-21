"
Tests diagram controller interactions, lane containment, and pool management in BPMN diagrams.
"
Class {
	#name : 'OPBPMNDiagramControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-BPMN-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPBPMNDiagramControllerTest >> controllerClass [

	^ OPBPMNDiagramController
]

{ #category : 'constants' }
OPBPMNDiagramControllerTest >> diagramModelClass [

	^ OPBPMNModel
]

{ #category : 'constants' }
OPBPMNDiagramControllerTest >> modelClass [

	^ OPBPMNModel
]

{ #category : 'tests' }
OPBPMNDiagramControllerTest >> testControllerFactory [

	| factory expectedMappings |
	factory := controller controllerFactory.
	self assert: factory class identicalTo: OPControllerFactory.
	expectedMappings := {
		                    (OPBPMNActivityModel -> OPBPMNActivityController).
		                    (OPBPMNStartEventModel -> OPBPMNStartEventController).
		                    (OPBPMNEndEventModel -> OPBPMNEndEventController).
		                    (OPBPMNIntermediateEventModel -> OPBPMNIntermediateEventController).
		                    (OPBPMNGatewayModel -> OPBPMNGatewayController).
		                    (OPBPMNPoolModel -> OPBPMNPoolController).
		                    (OPBPMNLaneModel -> OPBPMNLaneController).
		                    (OPBPMNSubProcessModel -> OPBPMNSubProcessController).
		                    (OPBPMNCollapsedSubProcessModel -> OPBPMNCollapsedSubProcessController).
		                    (OPBPMNBoundaryEventModel -> OPBPMNBoundaryEventController).
		                    (OPBPMNDataObjectModel -> OPBPMNDataObjectController).
		                    (OPBPMNAnnotationModel -> OPBPMNAnnotationController).
		                    (OPBPMNFlowModel -> OPBPMNFlowController).
		                    (OPBPMNDataFlowModel -> OPBPMNDataFlowController).
		                    (OPBPMNMessageFlowModel -> OPBPMNMessageFlowController).
		                    (OPBPMNAssociationModel -> OPBPMNAssociationController) }.
	expectedMappings do: [ :eachMapping |
			| sampleModel |
			sampleModel := eachMapping key new.
			self assert: (factory hasControllerFor: sampleModel) description: (String streamContents: [ :stream |
						 stream << 'Controller factory must register '.
						 stream << eachMapping key name ]).
			self assert: (factory newControllerFor: sampleModel) class identicalTo: eachMapping value ].
	self
		deny: (factory hasControllerFor: OPBPMNModel new)
		description: 'Controller factory must not register diagram model OPBPMNModel'
]

{ #category : 'tests' }
OPBPMNDiagramControllerTest >> testHasPoolsAndRootElementsReturnFalseWithoutModel [

	| emptyDiagramController |
	emptyDiagramController := OPBPMNDiagramController new.
	self deny: emptyDiagramController hasPoolsInDiagramOrModel description: 'Diagram controller without a model must report no pools'.
	self
		deny: emptyDiagramController hasRootProcessElementsInDiagramOrModel
		description: 'Diagram controller without a model must report no root process elements'
]

{ #category : 'tests' }
OPBPMNDiagramControllerTest >> testInitializePalette [

	| palette entries expectedToolClasses |
	palette := OPPalette new.
	controller initializePalette: palette.
	self assert: palette items size equals: 18.
	entries := palette items select: [ :eachItem | eachItem class == OPPaletteEntry ].
	expectedToolClasses := {
		                       ('Activity' -> OPBPMNActivityController).
		                       ('Start Event' -> OPBPMNStartEventController).
		                       ('Intermediate Event' -> OPBPMNIntermediateEventController).
		                       ('End Event' -> OPBPMNEndEventController).
		                       ('Gateway' -> OPBPMNGatewayController).
		                       ('Pool' -> OPBPMNPoolController).
		                       ('Lane' -> OPBPMNLaneController).
		                       ('Expanded SubProcess' -> OPBPMNSubProcessController).
		                       ('Collapsed SubProcess' -> OPBPMNCollapsedSubProcessController).
		                       ('Boundary Event' -> OPBPMNBoundaryEventController).
		                       ('Data Object' -> OPBPMNDataObjectController).
		                       ('Sequence Flow' -> OPBPMNFlowController).
		                       ('Message Flow' -> OPBPMNMessageFlowController).
		                       ('Data Flow' -> OPBPMNDataFlowController).
		                       ('Association' -> OPBPMNAssociationController).
		                       ('Annotation' -> OPBPMNAnnotationController) }.
	self assert: (entries collect: #label as: Array) equals: { 'Select' } , (expectedToolClasses collect: #key).
	expectedToolClasses do: [ :eachPair |
			| entry createdController |
			entry := entries detect: [ :eachEntry | eachEntry label = eachPair key ].
			entry performAction.
			createdController := palette selectedTool instVarNamed: #controller.
			self assert: createdController class identicalTo: eachPair value ]
]
