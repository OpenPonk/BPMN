"
I am the controller for BPMN Sequence Flows. I manage the interactions and rendering of the primary directed edges dictating process execution order.
"
Class {
	#name : 'OPBPMNFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNFlowController class >> diagramElementClass [

	^ OPBPMNFlowShape
]

{ #category : 'accessing' }
OPBPMNFlowController class >> viewModelClass [
	^ OPBPMNFlowViewModel
]

{ #category : 'connecting' }
OPBPMNFlowController >> canConnectSource: aSourceController toTarget: aTargetController [
	| sourceModel targetModel sourceSubProcess targetSubProcess |
	(super canConnectSource: aSourceController toTarget: aTargetController) ifFalse: [ ^ false ].
	aSourceController ifNil: [ ^ true ].
	sourceModel := aSourceController model.
	targetModel := aTargetController model.
	(sourceModel isNil or: [ targetModel isNil ]) ifTrue: [ ^ true ].
	sourceSubProcess := self enclosingSubProcessOf: sourceModel.
	targetSubProcess := self enclosingSubProcessOf: targetModel.
	sourceSubProcess == targetSubProcess ifFalse: [ ^ false ].
	^ sourceModel enclosingPool == targetModel enclosingPool
]
