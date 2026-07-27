Class {
	#name : 'OPBPMNPoolController',
	#superclass : 'OPBPMNNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNPoolController >> buildEditorForm: aForm [

	| amountOfShownLanes lanesInput |
	super buildEditorForm: aForm.

	"IMPORTANT: Lanes need to be last items in the form as only last items can be removed"

	amountOfShownLanes := 0.

	(lanesInput := aForm addNumberInput: 'Lanes')
		minimum: 0;
		text: self model lanes asString;
		whenTextChangedDo: [ :newValue |
				self model lanes: ((newValue asInteger ifNil: [ 0 ]) max: 0).
				amountOfShownLanes = self model lanes ifFalse: [
							amountOfShownLanes := self
								                      rebuildLaneNamesFrom: amountOfShownLanes
								                      inForm: aForm.
							aForm rebuildWidget ].
				self modelChanged ].

	amountOfShownLanes := self rebuildLaneNamesFrom: 0 inForm: aForm
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
OPBPMNPoolController >> diagramElementClass [

	^ OPBPMNPoolShape
]

{ #category : 'accessing' }
OPBPMNPoolController >> elementsToShowInside [

	^ self model nodes
	  , (self model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : 'construction' }
OPBPMNPoolController >> hookDiagramElement [

	super hookDiagramElement.

	self diagramElement innerRoassalShapesBlock: [
		self nodeRoassalShapes ]
]

{ #category : 'accessing' }
OPBPMNPoolController >> modelClass [
	^ OPBPMNPoolModel
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

{ #category : 'forms' }
OPBPMNPoolController >> rebuildLaneNamesFrom: amountOfShownLanes inForm: aForm [

	aForm removeLast: amountOfShownLanes - self model lanes * 2.

	self model laneNames withIndexDo: [ :eachLaneName :eachIndex |
			eachIndex > amountOfShownLanes ifTrue: [
					(aForm addTextInput: 'Lane ' , eachIndex asString)
						text: eachLaneName;
						whenTextChangedDo: [ :newValue |
								self model laneNamesAt: eachIndex put: newValue.
								self modelChanged ] ] ].

	^ self model lanes
]

{ #category : 'diagram elements' }
OPBPMNPoolController >> unhookDiagramElement [

	super unhookDiagramElement.
	(self diagramElement ifNotExists: [ ^ self ])
		innerRoassalShapesBlock: [  ]
]
