"
I manage the diagram interactions and connection rules for BPMN Associations, linking artifacts like text annotations to process elements.
"
Class {
	#name : 'OPBPMNAssociationController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNAssociationController class >> diagramElementClass [

	^ OPBPMNAssociationShape
]

{ #category : 'accessing' }
OPBPMNAssociationController class >> viewModelClass [
	^ OPBPMNAssociationViewModel
]

{ #category : 'connecting' }
OPBPMNAssociationController >> canConnectSource: aSourceController toTarget: aTargetController [
	| sourceModel targetModel |
	(super canConnectSource: aSourceController toTarget: aTargetController) ifFalse: [ ^ false ].
	aSourceController ifNil: [ ^ true ].
	aTargetController ifNil: [ ^ true ].
	(aSourceController isKindOf: OPBPMNAnnotationController) ifTrue: [
		^ (aTargetController isKindOf: OPBPMNAnnotationController) not ].
	(aTargetController isKindOf: OPBPMNAnnotationController) ifTrue: [ ^ true ].
	((aSourceController isKindOf: OPBPMNBoundaryEventController) and: [
		aSourceController model isNotNil and: [
			(aSourceController model type = OPBPMNNodeType CatchCompensation
				or: [ aSourceController model type = OPBPMNNodeType Compensation ]) and: [
				(aTargetController isKindOf: OPBPMNActivityController) or: [
					(aTargetController isKindOf: OPBPMNSubProcessController) or: [
						aTargetController isKindOf: OPBPMNCollapsedSubProcessController ] ] ] ] ])
		ifFalse: [ ^ false ].
	sourceModel := aSourceController model.
	targetModel := aTargetController model.
	(sourceModel isNil or: [ targetModel isNil ]) ifTrue: [ ^ true ].
	sourceModel owner == targetModel ifTrue: [ ^ false ].
	(self enclosingSubProcessOf: sourceModel) == (self enclosingSubProcessOf: targetModel)
		ifFalse: [ ^ false ].
	^ sourceModel enclosingPool == targetModel enclosingPool
]
