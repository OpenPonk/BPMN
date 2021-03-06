Class {
	#name : #OPBPMNDiagramController,
	#superclass : #OPDiagramController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNDiagramController >> canBeTargetFor: aController [
	^ aController isKindOf: OPBPMNNodeController 
]

{ #category : #connecting }
OPBPMNDiagramController >> commonModelClassPrefix [
	^ 'OPBPMN'
]

{ #category : #connecting }
OPBPMNDiagramController >> elementsToShowInside [
	^ model elements
]

{ #category : #'ui interaction' }
OPBPMNDiagramController >> initializePalette: aPalette [
	aPalette
		newCreationTool: 'Activity'
			factory: [ OPBPMNActivityController new ]
			icon: OPBPMNIcon current activity;
		newCreationTool: 'Start Event'
			factory: [ OPBPMNStartEventController new ]
			icon: OPBPMNIcon current startEvent;
		newCreationTool: 'Intermediate Event'
			factory: [ OPBPMNIntermediateEventController new ]
			icon: OPBPMNIcon current intermediateEvent;
		newCreationTool: 'End Event'
			factory: [ OPBPMNEndEventController new ]
			icon: OPBPMNIcon current endEvent;
		newCreationTool: 'Gateway'
			factory: [ OPBPMNGatewayController new ]
			icon: OPBPMNIcon current gateway;
		newCreationTool: 'Pool'
			factory: [ OPBPMNPoolController new ]
			icon: OPBPMNIcon current sequenceFlow;
		newCreationTool: 'Lane'
			factory: [ OPBPMNLaneController new ]
			icon: OPBPMNIcon current sequenceFlow;
		newConnectionCreationTool: 'Sequence Flow'
			factory: [ OPBPMNFlowController new ]
			icon: OPBPMNIcon current sequenceFlow
]

{ #category : #'ui interaction' }
OPBPMNDiagramController >> modelClass [
	^ OPBPMNModel 
]

{ #category : #'ui interaction' }
OPBPMNDiagramController >> modelToControllerMapping [
	^ Dictionary new
		at: OPBPMNActivityModel put: OPBPMNActivityController;
		at: OPBPMNStartEventModel put: OPBPMNStartEventController;
		at: OPBPMNEndEventModel put: OPBPMNEndEventController;
		at: OPBPMNGatewayModel put: OPBPMNGatewayController;
		at: OPBPMNFlowModel put: OPBPMNFlowController;
		yourself
]
