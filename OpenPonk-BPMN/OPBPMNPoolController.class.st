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

{ #category : #construction }
OPBPMNPoolController >> boxHeight [
	^ 300
]

{ #category : #connecting }
OPBPMNPoolController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNMessageFlowController
]

{ #category : #connecting }
OPBPMNPoolController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPBPMNElementController)
		| (aController isKindOf: OPBPMNLaneController)
		| (aController isKindOf: OPBPMNMessageFlowController)
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
	labeled trachelShape text: self model name.
	labelConstraint move.
	innerConstraint move.
	figure trachelShape pushBack.
	self diagramController view signalUpdate.
	^ super refreshFigure
]

{ #category : #accessing }
OPBPMNPoolController >> removeFigure [
	super removeFigure
]

{ #category : #connecting }
OPBPMNPoolController >> removeModel [
	self diagramController model remove: self model
]

{ #category : #connecting }
OPBPMNPoolController >> removedNodeFigure: aFigure [
	elements remove: aFigure
]

{ #category : #construction }
OPBPMNPoolController >> renderFigureIn: aView [
	"| lane laneConstraint |"

	self diagramController addingFigureFor: self.
	figure := self createRoassalShape elementOn: self model.
	figure @ RTGhostDraggable.
	figure @ RTResizable.
	figure renderIn: aView.
	labeled := (RTLabel new
		height: 12;
		text: self model name;
		element)
		rotateByDegrees: -90;
		color: Color black;
		yourself.
	labeled model: figure.
	figure trachelShape
		addCallback:
			(TRRemoveCallback new
				block: [ :removedShape | labeled remove ]).
	labeled renderIn: figure view.
	labelConstraint := (RTConstraint on: labeled "lbl" background: figure)
		center;
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
	figure trachelShape
		addCallback:
			(TRExtentCallback
				block: [ :shape :step | innerBox height: shape height ]).
	"lane := OPBPMNLaneController new createElement.
	laneConstraint := (RTConstraint on: lane background: figure)
		top;
		right;
		stick.
	lane renderIn: aView."
	elements := RTGroup new.
	elements @ OPRTFocusable.
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
