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
OPBPMNDiagramControllerTest >> testInitializePalette [

	| palette entryLabels |
	palette := OPPalette new.
	controller initializePalette: palette.
	self assert: palette items size equals: 18.
	entryLabels := palette items select: [ :eachItem | eachItem class == OPPaletteEntry ] thenCollect: #label.
	self
		assert: entryLabels asArray
		equals: #( 'Select' 'Activity' 'Start Event' 'Intermediate Event' 'End Event' 'Gateway' 'Pool' 'Lane' 'Expanded SubProcess'
			   'Collapsed SubProcess' 'Boundary Event' 'Data Object' 'Sequence Flow' 'Message Flow' 'Data Flow' 'Association' 'Annotation' )
]
