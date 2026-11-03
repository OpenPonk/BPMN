"
I am the controller for BPMN Message Flows. I manage the interactions and diagram logic for directed edges representing message exchanges between distinct process participants (pools).
"
Class {
	#name : 'OPBPMNMessageFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNMessageFlowController class >> diagramElementClass [

	^ OPBPMNMessageFlowShape
]

{ #category : 'accessing' }
OPBPMNMessageFlowController class >> viewModelClass [
	^ OPBPMNMessageFlowViewModel
]

{ #category : 'connecting' }
OPBPMNMessageFlowController >> canConnectSource: aSourceController toTarget: aTargetController [
	| sourcePool targetPool |
	(super canConnectSource: aSourceController toTarget: aTargetController) ifFalse: [ ^ false ].
	aSourceController ifNil: [ ^ true ].
	(self isValidMessageTarget: aTargetController) ifFalse: [ ^ false ].
	sourcePool := aSourceController model enclosingPool.
	targetPool := aTargetController model enclosingPool.
	((sourcePool isKindOf: OPBPMNPoolModel) and: [ targetPool isKindOf: OPBPMNPoolModel ]) ifFalse: [ ^ false ].
	sourcePool == targetPool ifTrue: [ ^ false ].
	(aSourceController isKindOf: OPBPMNPoolController) ifTrue: [
		aSourceController isBlackBox ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'private' }
OPBPMNMessageFlowController >> isValidMessageTarget: aTargetController [
	(aTargetController isKindOf: OPBPMNPoolController) ifTrue: [
		^ aTargetController isBlackBox ].
	^ (aTargetController isKindOf: OPBPMNActivityController)
		or: [ (aTargetController isKindOf: OPBPMNSubProcessController)
		or: [ (aTargetController isKindOf: OPBPMNCollapsedSubProcessController)
		or: [ (aTargetController isKindOf: OPBPMNStartEventController)
		or: [ (aTargetController isKindOf: OPBPMNIntermediateEventController)
		or: [ aTargetController isKindOf: OPBPMNBoundaryEventController ] ] ] ] ]
]
