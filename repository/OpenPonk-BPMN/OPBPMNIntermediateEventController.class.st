"
I am the controller for BPMN Intermediate Events. I enforce valid diagram connection rules for events occurring during the execution of a process.
"
Class {
	#name : 'OPBPMNIntermediateEventController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNIntermediateEventController class >> diagramElementClass [

	^ OPBPMNIntermediateEventShape
]

{ #category : 'accessing' }
OPBPMNIntermediateEventController class >> viewModelClass [
	^ OPBPMNIntermediateEventViewModel
]

{ #category : 'connecting' }
OPBPMNIntermediateEventController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
			aController source model enclosingPool = self model enclosingPool
				ifTrue: [ ^ false ] ].

	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
			(aController source model isKindOf: OPBPMNDataObjectModel)
				ifFalse: [ ^ false ] ].

	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].

	^ aController source ~= self
]
