"
I am the controller for BPMN End Events. I enforce valid connection rules, ensuring that end events correctly process incoming flows on the diagram canvas.
"
Class {
	#name : 'OPBPMNEndEventController',
	#superclass : 'OPBPMNEventController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNEndEventController class >> diagramElementClass [

	^ OPBPMNEndEventShape
]

{ #category : 'accessing' }
OPBPMNEndEventController class >> viewModelClass [
	^ OPBPMNEndEventViewModel
]

{ #category : 'connecting' }
OPBPMNEndEventController >> canBeSourceFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController) or: [
		  aController isKindOf: OPBPMNAssociationController ]
]

{ #category : 'connecting' }
OPBPMNEndEventController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
		^ false ].

	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
			(aController source model isKindOf: OPBPMNDataObjectModel)
				ifFalse: [ ^ false ] ].

	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].

	^ aController source ~= self
]
