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
	| sourceModel targetModel isDataStoreInvolved |
	(super canConnectSource: aSourceController toTarget: aTargetController) ifFalse: [ ^ false ].
	aSourceController ifNil: [ ^ true ].
	sourceModel := aSourceController model.
	((aSourceController isKindOf: OPBPMNDataObjectController) and: [
		sourceModel isNotNil and: [ sourceModel type = OPBPMNNodeType DataOutput ] ])
		ifTrue: [ ^ false ].
	(aSourceController isKindOf: OPBPMNEndEventController) ifTrue: [ ^ false ].
	((aSourceController isKindOf: OPBPMNIntermediateEventController) and: [
		sourceModel isNotNil and: [ sourceModel printType = 'intermediateThrowEvent' ] ])
		ifTrue: [ ^ false ].
	aTargetController ifNil: [ ^ true ].
	targetModel := aTargetController model.
	((aSourceController isKindOf: OPBPMNDataObjectController) and: [
		aTargetController isKindOf: OPBPMNDataObjectController ]) ifTrue: [ ^ false ].
	(aTargetController isKindOf: OPBPMNStartEventController) ifTrue: [ ^ false ].
	(aTargetController isKindOf: OPBPMNBoundaryEventController) ifTrue: [ ^ false ].
	(aSourceController isKindOf: OPBPMNDataObjectController)
		ifTrue: [ (self isValidFlowTarget: aTargetController) ifFalse: [ ^ false ] ]
		ifFalse: [
			(aTargetController isKindOf: OPBPMNDataObjectController) ifFalse: [ ^ false ].
			(targetModel isNotNil and: [ targetModel type = OPBPMNNodeType DataInput ])
				ifTrue: [ ^ false ] ].
	(sourceModel isNil or: [ targetModel isNil ]) ifTrue: [ ^ true ].
	isDataStoreInvolved := ((sourceModel isKindOf: OPBPMNDataObjectModel) and: [
		sourceModel type = OPBPMNNodeType DataStore ]) or: [
		(targetModel isKindOf: OPBPMNDataObjectModel) and: [
			targetModel type = OPBPMNNodeType DataStore ] ].
	isDataStoreInvolved ifTrue: [ ^ true ].
	^ sourceModel enclosingPool == targetModel enclosingPool
]

{ #category : 'private' }
OPBPMNDataFlowController >> isValidFlowTarget: aTargetController [
	(aTargetController isKindOf: OPBPMNActivityController) ifTrue: [ ^ true ].
	(aTargetController isKindOf: OPBPMNSubProcessController) ifTrue: [ ^ true ].
	(aTargetController isKindOf: OPBPMNCollapsedSubProcessController) ifTrue: [ ^ true ].
	(aTargetController isKindOf: OPBPMNEndEventController) ifTrue: [ ^ true ].
	(aTargetController isKindOf: OPBPMNIntermediateEventController) ifTrue: [
		^ aTargetController model isNil or: [
			aTargetController model printType = 'intermediateThrowEvent' ] ].
	^ false
]
