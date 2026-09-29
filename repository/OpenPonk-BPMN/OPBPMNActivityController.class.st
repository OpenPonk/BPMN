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

	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
			aController source model enclosingPool = self model enclosingPool
				ifTrue: [ ^ false ] ].

	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
			(aController source model isKindOf: OPBPMNDataObjectModel)
				ifFalse: [ ^ false ] ].

	^ aController source ~= self
]
