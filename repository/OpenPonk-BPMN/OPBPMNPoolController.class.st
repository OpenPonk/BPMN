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
	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
		^ self isBlackBox ].
	^ aController isKindOf: OPBPMNAssociationController
]

{ #category : 'connecting' }
OPBPMNPoolController >> canBeTargetFor: aTargetController [
	(aTargetController isKindOf: OPBPMNBoundaryEventController) ifTrue: [ ^ false ].
	(aTargetController isKindOf: OPBPMNMessageFlowController) ifTrue: [
		^ aTargetController canConnectTo: self ].
	(aTargetController isKindOf: OPBPMNAssociationController) ifTrue: [
		^ aTargetController canConnectTo: self ].
	(aTargetController isKindOf: OPBPMNLaneController) ifTrue: [ ^ true ].
	(aTargetController isKindOf: self class) ifTrue: [ ^ false ].
	self model hasLanes ifTrue: [ ^ false ].
	^ aTargetController isKindOf: OPBPMNNodeController
]

{ #category : 'testing' }
OPBPMNPoolController >> isBlackBox [
	"Answers whether the underlying pool model is an unpartitioned black-box pool."
	^ self model ifNil: [ true ] ifNotNil: [ :activeModel | activeModel isBlackBox ]
]
