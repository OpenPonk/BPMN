Class {
	#name : 'OPBPMNLaneController',
	#superclass : 'OPBPMNNodeController',
	#instVars : [
		'targetLaneModel',
		'insertBefore'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNLaneController class >> diagramElementClass [
	^ OPBPMNLaneShape
]

{ #category : 'accessing' }
OPBPMNLaneController class >> viewModelClass [
	^ OPBPMNLaneViewModel
]

{ #category : 'user interface' }
OPBPMNLaneController >> addAsTargetFor: aController onPosition: aPoint [
	| targetCenterY willInsertBefore |
	(self canBeTargetFor: aController) ifFalse: [
		self error: self class asString , ' cannot be target for ' , aController class asString ].
	(aController isKindOf: self class) ifTrue: [
		targetCenterY := self diagramElement roassalShape position y.
		willInsertBefore := aPoint y < targetCenterY.
		aController configureInsertionTargetLane: self model before: willInsertBefore ].
	super addAsTargetFor: aController onPosition: aPoint
]

{ #category : 'connecting' }
OPBPMNLaneController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNAssociationController
]

{ #category : 'connecting' }
OPBPMNLaneController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNAssociationController) ifTrue: [ ^ aController source ~~ self ].

	(aController isKindOf: self class) ifTrue: [ ^ aController ~~ self ].

	^ aController isKindOf: OPBPMNNodeController
]

{ #category : 'configuration' }
OPBPMNLaneController >> configureInsertionTargetLane: aLaneModel before: aBoolean [
	targetLaneModel := aLaneModel.
	insertBefore := aBoolean
]

{ #category : 'construction' }
OPBPMNLaneController >> createModelIn: aParentModel [
	self viewModel: (self viewModelRegistry
		registerNewViewModelOfClass: self class viewModelClass
		createdBy: [ :newViewModel |
			targetLaneModel ifNotNil: [
				newViewModel targetLaneModel: targetLaneModel.
				newViewModel insertBefore: (insertBefore ifNil: [ false ]) ].
			newViewModel createModelIn: aParentModel ]).
	^ self model
]

{ #category : 'creation' }
OPBPMNLaneController >> creationCommandIn: aParentModel andShowInDiagram: aDiagramController onPosition: aPoint [
	^ OPCreateNodeCommand
		controller: self
		parentModel: aParentModel
		diagramController: aDiagramController
		position: nil
]

{ #category : 'diagram elements' }
OPBPMNLaneController >> intendedModelOfOwningDiagramElement [
	"Resolves the model element of the owning diagram element, prioritizing domain pool ownership."
	self model ifNotNil: [ :laneModel |
		(laneModel respondsTo: #pool) ifTrue: [
			laneModel pool ifNotNil: [ :enclosingPool |
				(self diagramController hasControllerForModel: enclosingPool) ifTrue: [
					^ enclosingPool ] ] ].
		laneModel owner ifNotNil: [ :ownerModel |
			(self diagramController hasControllerForModel: ownerModel) ifTrue: [
				^ ownerModel ] ] ].
	^ super intendedModelOfOwningDiagramElement
]

{ #category : 'geometry' }
OPBPMNLaneController >> moveSeparatorBy: aDeltaNumber [
	| nextLaneController command |
	nextLaneController := self nextLaneController.
	nextLaneController ifNil: [ ^ self ].
	command := OPBPMNChangeLaneHeightsCommand
		firstLaneShape: self diagramElement
		secondLaneShape: nextLaneController diagramElement
		delta: aDeltaNumber.
	self undoManager execute: command
]

{ #category : 'accessing' }
OPBPMNLaneController >> nextLaneController [
	| poolModel laneCollection currentLaneIndex |
	poolModel := self model pool ifNil: [
		self owner ifNotNil: [ :parentController | parentController model ] ].
	poolModel ifNil: [ ^ nil ].
	laneCollection := poolModel lanes.
	currentLaneIndex := laneCollection indexOf: self model.
	(currentLaneIndex > 0 and: [ currentLaneIndex < laneCollection size ]) ifFalse: [ ^ nil ].
	^ self diagramController controllerForModel: (laneCollection at: currentLaneIndex + 1)
]

{ #category : 'connecting' }
OPBPMNLaneController >> parentWhenTargetFor: aCreatedController [
	"When aCreatedController is targeting self (a lane), the parent model for creation is the enclosing pool."
	(aCreatedController isKindOf: self class) ifTrue: [
		(self model respondsTo: #pool) ifTrue: [
			self model pool ifNotNil: [ :enclosingPool | ^ enclosingPool ] ].
		^ self model owner ].
	^ super parentWhenTargetFor: aCreatedController
]
