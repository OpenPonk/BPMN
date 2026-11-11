"
I am the controller for BPMN Boundary Events. I manage the lifecycle and diagram interactions of events attached directly to the boundary of an activity.
"
Class {
	#name : 'OPBPMNBoundaryEventController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNBoundaryEventController class >> diagramElementClass [

	^ OPBPMNBoundaryEventShape
]

{ #category : 'accessing' }
OPBPMNBoundaryEventController class >> viewModelClass [
	^ OPBPMNBoundaryEventViewModel
]

{ #category : 'connecting' }
OPBPMNBoundaryEventController >> canBeSourceFor: aController [
	(aController isKindOf: OPBPMNAssociationController) ifTrue: [ ^ true ].
	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [ ^ true ].
	(aController isKindOf: OPBPMNFlowController) ifTrue: [
		^ self model isNil or: [
			(self model type = OPBPMNNodeType CatchCompensation
				or: [ self model type = OPBPMNNodeType Compensation ]) not ] ].
	^ false
]

{ #category : 'connecting' }
OPBPMNBoundaryEventController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNFlowController) ifTrue: [ ^ false ].
	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [ ^ false ].
	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].
	^ aController canConnectTo: self
]
