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
OPBPMNPoolController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
			^ aController source model enclosingPool
			  ~= self model enclosingPool and: [ aController source ~= self ] ].

	(aController isKindOf: OPBPMNAssociationController) ifTrue: [
		^ aController source ~= self ].

	(aController isKindOf: self class) ifTrue: [ ^ false ].

	^ aController isKindOf: OPBPMNNodeController
]

{ #category : 'construction' }
OPBPMNPoolController >> hookDiagramElement [

	super hookDiagramElement.

	self diagramElement innerRoassalShapesBlock: [
		self nodeRoassalShapes ]
]

{ #category : 'accessing' }
OPBPMNPoolController >> nodeRoassalShapes [

	^ self model nodes
		  collect: [ :eachModel |
			  self diagramController
				  controllerForModel: eachModel
				  ifFound: #roassalShape ]
		  thenSelect: #isNotNil
]

{ #category : 'deprecation' }
OPBPMNPoolController >> rebuildLaneNamesFrom: amountOfShownLanes inForm: aForm [
	self deprecated: 'Use viewModel instead'.
	^ self viewModel rebuildLaneNamesFrom: amountOfShownLanes inForm: aForm
]

{ #category : 'diagram elements' }
OPBPMNPoolController >> unhookDiagramElement [

	super unhookDiagramElement.
	(self diagramElement ifNotExists: [ ^ self ])
		innerRoassalShapesBlock: [  ]
]
