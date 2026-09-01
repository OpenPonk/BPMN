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

	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
		^ aController source model isKindOf: OPBPMNDataObjectModel ].

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
			aController source model enclosingPool = self model enclosingPool
				ifTrue: [ ^ false ] ].

	((aController isKindOf: OPBPMNMessageFlowController) or: [
		 aController isKindOf: OPBPMNAssociationController ]) ifFalse: [
		^ false ].

	^ aController source ~= self
]
