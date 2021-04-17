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

{ #category : #'ui interaction' }
OPBPMNDiagramController >> controllerFactory [
	^ super controllerFactory
		register: OPBPMNActivityController forModel: OPBPMNActivityModel;
		register: OPBPMNStartEventController forModel: OPBPMNStartEventModel;
		register: OPBPMNEndEventController forModel: OPBPMNEndEventModel;
		register: OPBPMNIntermediateEventController forModel: OPBPMNIntermediateEventModel;
		register: OPBPMNGatewayController forModel: OPBPMNGatewayModel;
		register: OPBPMNPoolController forModel: OPBPMNPoolModel;
		register: OPBPMNLaneController forModel: OPBPMNLaneModel;
		register: OPBPMNFlowController forModel: OPBPMNFlowModel;
		register: OPBPMNMessageFlowController forModel: OPBPMNMessageFlowModel
]

{ #category : #connecting }
OPBPMNDiagramController >> elementsToShowInside [
	| poolNodes poolFlows |
	poolNodes := (model nodes flatCollect: [ :each | each nodes ]).
	poolFlows := (poolNodes flatCollect: [ :each | each outgoing ]).
	^ model nodes, 
	poolNodes,
	poolFlows,
	(model nodes flatCollect: [ :each | each outgoing ])
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
			icon: OPBPMNIcon current pool;
		newCreationTool: 'Lane'
			factory: [ OPBPMNLaneController new ]
			icon: OPBPMNIcon current lane;
		newConnectionCreationTool: 'Sequence Flow'
			factory: [ OPBPMNFlowController new ]
			icon: OPBPMNIcon current sequenceFlow;
		newConnectionCreationTool: 'Message Flow'
			factory: [ OPBPMNMessageFlowController new ]
			icon: OPBPMNIcon current messageFlow
]

{ #category : #'ui interaction' }
OPBPMNDiagramController >> modelClass [
	^ OPBPMNModel 
]

{ #category : #userinterface }
OPBPMNDiagramController >> updateView [
	self controllers do: [ :each | each refreshFigure ].
	self view edges
		do: [ :each | 
			(each isKindOf: OPBPMNPoolController) 
				ifTrue: [ each pushBack ] 
				ifFalse: [ each pushFront ].
			"each pushFront."
			each update ].
	self view signalUpdate
]
