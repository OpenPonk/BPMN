Class {
	#name : 'OPBPMNDiagramController',
	#superclass : 'OPDiagramController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'connecting' }
OPBPMNDiagramController >> canBeTargetFor: aController [

	(super canBeTargetFor: aController) ifTrue: [ ^ true ].

	((aController isKindOf: OPBPMNBoundaryEventController) or: [
		 aController modelClass inheritsFrom: OPBPMNFlowNodeModel ])
		ifTrue: [
				^ self controllers noneSatisfy: [ :any |
					  any isKindOf: OPBPMNPoolController ] ].

	^ aController isKindOf: OPBPMNNodeController
]

{ #category : 'accessing' }
OPBPMNDiagramController >> commonModelClassPrefix [
	^ 'OPBPMN'
]

{ #category : 'accessing' }
OPBPMNDiagramController >> controllerFactory [
	^ super controllerFactory
		register: OPBPMNActivityController forModel: OPBPMNActivityModel;
		register: OPBPMNStartEventController forModel: OPBPMNStartEventModel;
		register: OPBPMNEndEventController forModel: OPBPMNEndEventModel;
		register: OPBPMNIntermediateEventController forModel: OPBPMNIntermediateEventModel;
		register: OPBPMNGatewayController forModel: OPBPMNGatewayModel;
		register: OPBPMNPoolController forModel: OPBPMNPoolModel;
		register: OPBPMNSubProcessController forModel: OPBPMNSubProcessModel;
		register: OPBPMNCollapsedSubProcessController forModel: OPBPMNCollapsedSubProcessModel;
		register: OPBPMNBoundaryEventController forModel: OPBPMNBoundaryEventModel;
		register: OPBPMNDataObjectController forModel: OPBPMNDataObjectModel;
		register: OPBPMNFlowController forModel: OPBPMNFlowModel;
		register: OPBPMNDataFlowController forModel: OPBPMNDataFlowModel;
		register: OPBPMNMessageFlowController forModel: OPBPMNMessageFlowModel
]

{ #category : 'accessing' }
OPBPMNDiagramController >> elementsToShowInside [

	| poolNodes poolFlows laneNodes laneFlows |
	poolNodes := self model nodes flatCollect: [ :each | each nodes ].
	poolFlows := poolNodes flatCollect: [ :each | each outgoing ].
	laneNodes := poolNodes flatCollect: [ :each | each nodes ].
	laneFlows := laneNodes flatCollect: [ :each | each outgoing ].
	^ self model nodes , poolNodes , poolFlows , laneNodes , laneFlows
	  , (self model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : 'ui interaction' }
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
		newCreationTool: 'Expanded SubProcess'
		factory: [ OPBPMNSubProcessController new ]
		icon: OPBPMNIcon current expandedSubprocess;
		newCreationTool: 'Collapsed SubProcess'
		factory: [ OPBPMNCollapsedSubProcessController new ]
		icon: OPBPMNIcon current subProcessCollapsed;
		newCreationTool: 'Data Object'
		factory: [ OPBPMNDataObjectController new ]
		icon: OPBPMNIcon current dataObject16;
		newConnectionCreationTool: 'Sequence Flow'
		factory: [ OPBPMNFlowController new ]
		icon: OPBPMNIcon current sequenceFlow;
		newConnectionCreationTool: 'Message Flow'
		factory: [ OPBPMNMessageFlowController new ]
		icon: OPBPMNIcon current messageFlow;
		newConnectionCreationTool: 'Data Flow'
		factory: [ OPBPMNDataFlowController new ]
		icon: OPBPMNIcon current messageFlow;
		newConnectionCreationTool: 'Association'
		factory: [ OPBPMNAssociationController new ]
		icon: OPBPMNIcons accessLink16Icon;
		newCreationTool: 'Annotation'
		factory: [ OPBPMNAnnotationController new ]
		icon: (Smalltalk ui icons iconNamed: #smallLeftFlush)
]

{ #category : 'accessing' }
OPBPMNDiagramController >> modelClass [
	^ OPBPMNModel 
]
