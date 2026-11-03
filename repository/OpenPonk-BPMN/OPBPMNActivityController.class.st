"
I am the controller for BPMN Activities. I enforce valid connection rules for incoming and outgoing flows on the canvas.
"
Class {
	#name : 'OPBPMNActivityController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNActivityController class >> diagramElementClass [

	^ OPBPMNActivityShape
]

{ #category : 'accessing' }
OPBPMNActivityController class >> viewModelClass [
	^ OPBPMNActivityViewModel
]

{ #category : 'connecting' }
OPBPMNActivityController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNActivityController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNBoundaryEventController) ifTrue: [ ^ true ].
	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].
	^ aController canConnectTo: self
]
