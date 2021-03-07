Class {
	#name : #OPBPMNPoolController,
	#superclass : #OPBPMNNodeController,
	#instVars : [
		'innerBox',
		'innerConstraint',
		'labeled',
		'labelConstraint',
		'elements'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNPoolController >> addedNodeFigure: aFigure [
	elements add: aFigure
]

{ #category : #'as yet unclassified' }
OPBPMNPoolController >> boxHeight [
	^ 300
]

{ #category : #connecting }
OPBPMNPoolController >> canBeTargetFor: aController [
	^ aController isKindOf: OPBPMNNodeController
]

{ #category : #connecting }
OPBPMNPoolController >> createRoassalShape [
	^ RTBox new
		width: 550;
		height: self boxHeight;
		color: Color transparent;
		borderColor: Color black;
		borderWidth: 2;
		yourself
]

{ #category : #connecting }
OPBPMNPoolController >> elementsToShowInside [
	^ model nodes , (model nodes flatCollect: [ :each | each outgoing ])
]

{ #category : #connecting }
OPBPMNPoolController >> layout: anElementLayout [
	self figure trachelShape
		doWithoutCallbacks: [ super layout: anElementLayout ].
	anElementLayout hasExtent
		ifTrue: [ self figure extent: anElementLayout extent ].
	self refreshFigure
]

{ #category : #accessing }
OPBPMNPoolController >> modelClass [
	^ OPBPMNPoolModel
]

{ #category : #connecting }
OPBPMNPoolController >> nodeFigures [
	^ elements
]

{ #category : #accessing }
OPBPMNPoolController >> refreshFigure [
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	labelConstraint move.
	innerConstraint move.
	figure trachelShape pushBack.
	self diagramController view signalUpdate.
	^ self figure
]

{ #category : #accessing }
OPBPMNPoolController >> removeModel [
	self diagramController model remove: self model
]

{ #category : #construction }
OPBPMNPoolController >> renderFigureIn: aView [
	"| lane laneConstraint |"

	self diagramController addingFigureFor: self.
	figure := self createRoassalShape elementOn: self model.
	figure @ RTResizable.
	figure @ RTGhostDraggable.
	figure renderIn: aView.
	(labeled := RTLabeled new)
		view: aView;
		top;
		color: Color black.
	figure @ labeled.
	labelConstraint := (RTConstraint on: labeled lbl background: figure)
		top;
		left;
		padding: 2;
		stick.
	figure renderIn: aView.
	innerBox := RTRoundedBox new
		width: 30;
		height: self boxHeight;
		color: Color transparent;
		borderColor: Color black;
		element.
	innerConstraint := (RTConstraint on: innerBox background: figure)
		top;
		left;
		stick.
	innerBox renderIn: aView.
	figure addCallback: (TRRemoveCallback with: innerBox).
	"lane := OPBPMNLaneController new createElement.
	laneConstraint := (RTConstraint on: lane background: figure)
		top;
		right;
		stick.
	lane renderIn: aView."
	elements := RTGroup new.
	elements @ RTDraggable.
	figure trachelShape
		addCallback:
			(TRTranslationCallback
				block: [ :shape :step | elements do: [ :e | e translateBy: step ] ]).
	self saveStateOnDragEndFor: figure.
	^ self diagramController addedFigureFor: self
]

{ #category : #connecting }
OPBPMNPoolController >> showDenyFeedbackFor: aController [
	^ nil
]
