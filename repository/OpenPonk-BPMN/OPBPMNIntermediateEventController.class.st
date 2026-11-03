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
	(aController isKindOf: OPBPMNFlowController) ifTrue: [
		^ self model isNil or: [ self model type ~= OPBPMNNodeType LinkThrow ] ].
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].
	((aController isKindOf: OPBPMNFlowController) and: [
		self model isNotNil and: [ self model type = OPBPMNNodeType Link ] ])
		ifTrue: [ ^ false ].
	^ aController canConnectTo: self
]
