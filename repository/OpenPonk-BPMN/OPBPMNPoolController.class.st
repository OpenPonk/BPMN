"
I am the controller for BPMN Pools. I manage lane structures, canvas hooks, and handle elements entering or leaving the pool boundaries.
"
Class {
	#name : 'OPBPMNPoolController',
	#superclass : 'OPBPMNSemanticNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNPoolController class >> diagramElementClass [

	^ OPBPMNPoolShape
]

{ #category : 'accessing' }
OPBPMNPoolController class >> viewModelClass [
	^ OPBPMNPoolViewModel
]

{ #category : 'connecting' }
OPBPMNPoolController >> canBeSourceFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController) or: [
		  aController isKindOf: OPBPMNAssociationController ]
]

{ #category : 'connecting' }
OPBPMNPoolController >> canBeTargetFor: aTargetController [

	(aTargetController isKindOf: OPBPMNMessageFlowController) ifTrue: [
		^ aTargetController source model enclosingPool ~= self model enclosingPool and: [ aTargetController source ~= self ] ].

	(aTargetController isKindOf: OPBPMNAssociationController) ifTrue: [ ^ aTargetController source ~= self ].

	(aTargetController isKindOf: OPBPMNLaneController) ifTrue: [ ^ self model elements isEmpty or: [ self model hasLanes ] ].

	(aTargetController isKindOf: self class) ifTrue: [ ^ false ].

	self model hasLanes ifTrue: [ ^ false ].

	^ aTargetController isKindOf: OPBPMNNodeController
]
