"
I am the controller for BPMN Data Associations. I manage the interactions and diagram logic for directed edges connecting data objects to activities.
"
Class {
	#name : 'OPBPMNDataFlowController',
	#superclass : 'OPBPMNAbstractFlowController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNDataFlowController class >> diagramElementClass [

	^ OPBPMNDataFlowShape
]

{ #category : 'accessing' }
OPBPMNDataFlowController class >> viewModelClass [
	^ OPBPMNDataFlowViewModel
]

{ #category : 'connecting' }
OPBPMNDataFlowController >> canConnectSource: aSourceController toTarget: aTargetController [
	| sourceModel targetModel |
	(super canConnectSource: aSourceController toTarget: aTargetController) ifFalse: [ ^ false ].
	aSourceController ifNil: [ ^ true ].
	((aSourceController isKindOf: OPBPMNDataObjectController) and: [
		aTargetController isKindOf: OPBPMNDataObjectController ]) ifTrue: [ ^ false ].
	(aTargetController isKindOf: OPBPMNStartEventController) ifTrue: [ ^ false ].
	(aTargetController isKindOf: OPBPMNBoundaryEventController) ifTrue: [ ^ false ].
	(aSourceController isKindOf: OPBPMNDataObjectController)
		ifTrue: [ (self isValidFlowTarget: aTargetController) ifFalse: [ ^ false ] ]
		ifFalse: [ (aTargetController isKindOf: OPBPMNDataObjectController) ifFalse: [ ^ false ] ].
	sourceModel := aSourceController model.
	targetModel := aTargetController model.
	(sourceModel isNil or: [ targetModel isNil ]) ifTrue: [ ^ true ].
	^ sourceModel enclosingPool == targetModel enclosingPool
]

{ #category : 'private' }
OPBPMNDataFlowController >> isValidFlowTarget: aTargetController [
	^ (aTargetController isKindOf: OPBPMNActivityController)
		or: [ (aTargetController isKindOf: OPBPMNSubProcessController)
		or: [ (aTargetController isKindOf: OPBPMNCollapsedSubProcessController)
		or: [ (aTargetController isKindOf: OPBPMNIntermediateEventController)
		or: [ aTargetController isKindOf: OPBPMNEndEventController ] ] ] ]
]
