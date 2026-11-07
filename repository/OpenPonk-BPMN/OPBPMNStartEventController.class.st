"
I am the controller for BPMN Start Events. I enforce valid connection rules, ensuring that start events correctly generate outgoing flows on the diagram canvas.
"
Class {
	#name : 'OPBPMNStartEventController',
	#superclass : 'OPBPMNEventController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNStartEventController class >> diagramElementClass [

	^ OPBPMNStartEventShape
]

{ #category : 'accessing' }
OPBPMNStartEventController class >> viewModelClass [
	^ OPBPMNStartEventViewModel
]

{ #category : 'connecting' }
OPBPMNStartEventController >> canBeSourceFor: aController [

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
		^ false ].

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNStartEventController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNFlowController) ifTrue: [ ^ false ].
	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [ ^ false ].
	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].
	^ aController canConnectTo: self
]
