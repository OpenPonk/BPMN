"
I am the controller for BPMN SubProcesses. I manage diagram interactions, connection rules, and provide visual feedback when an invalid connection is attempted.
"
Class {
	#name : 'OPBPMNSubProcessController',
	#superclass : 'OPBPMNSemanticNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNSubProcessController class >> diagramElementClass [

	^ OPBPMNSubProcessShape
]

{ #category : 'accessing' }
OPBPMNSubProcessController class >> viewModelClass [
	^ OPBPMNSubProcessViewModel
]

{ #category : 'connecting' }
OPBPMNSubProcessController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNSubProcessController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNBoundaryEventController) ifTrue: [ ^ true ].
	(aController isKindOf: OPBPMNPoolController) ifTrue: [ ^ false ].
	(aController isKindOf: OPBPMNLaneController) ifTrue: [ ^ false ].
	(aController isKindOf: OPBPMNNodeController) ifTrue: [ ^ true ].
	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].
	^ aController canConnectTo: self
]
