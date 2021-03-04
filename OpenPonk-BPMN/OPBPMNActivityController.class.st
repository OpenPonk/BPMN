Class {
	#name : #OPBPMNActivityController,
	#superclass : #OPBPMNNodeController,
	#instVars : [
		'labelConstraint',
		'iconElement',
		'iconConstraint',
		'elements'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNActivityController >> addedNodeFigure: aFigure [
	elements add: aFigure
]

{ #category : #connecting }
OPBPMNActivityController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #(#Service #User #Manual #Send #Receive #None);
		iconHolder: [ :type | self typeIconFor: type ];
		displayBlock: [ :type | type asString ];
		setSelectedItem: self model type;
		whenSelectedItemChanged: [ :newValue | 
			self model type: newValue.
			self refreshFigure ]
]

{ #category : #connecting }
OPBPMNActivityController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #connecting }
OPBPMNActivityController >> canBeTargetFor: aController [
^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #connecting }
OPBPMNActivityController >> createRoassalShape [
	^ RTRoundedBox new
		height: 50;
		borderRadius: 10;
		width: 72;
		color: (Color fromHexString: 'f2f2f2');
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNActivityController >> layout: anElementLayout [
	self figure trachelShape
		doWithoutCallbacks: [ super layout: anElementLayout ].
	anElementLayout hasExtent
		ifTrue: [ self figure extent: anElementLayout extent ].
	self refreshFigure
]

{ #category : #accessing }
OPBPMNActivityController >> modelClass [
	^ OPBPMNActivityModel
]

{ #category : #hooks }
OPBPMNActivityController >> refreshFigure [
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	labelConstraint move.
	figure trachelShape pushBack.
		iconElement trachelShape form: self typeIconForModel.
	iconConstraint move.
	self diagramController view signalUpdate.
	^ self figure
]

{ #category : #hooks }
OPBPMNActivityController >> renderFigureIn: aView [
	| labeled |
	self diagramController addingFigureFor: self.
	figure := self createRoassalShape elementOn: self model.
	figure @ RTDraggable.
	figure @ RTResizable.
	(labeled := RTLabeled new)
		view: aView;
		top;
		color: Color black.
	figure @ labeled.
	labelConstraint := (RTConstraint on: labeled lbl background: figure)
		center;
		padding: 2;
		stick.
	figure renderIn: aView.
	iconElement := (RTBitmap new form: self typeIconForModel) element.
	iconConstraint := (RTConstraint on: iconElement background: figure)
		topLeft;
		padding: 3;
		stick.
	iconElement renderIn: aView.
	figure addCallback: (TRRemoveCallback with: iconElement).
	elements := RTGroup new.
	elements @ RTDraggable.
	figure trachelShape
		addCallback:
			(TRTranslationCallback
				block: [ :shape :step | elements do: [ :e | e translateBy: step ] ]).
	self saveStateOnDragEndFor: figure.
	^ self diagramController addedFigureFor: self
]

{ #category : #hooks }
OPBPMNActivityController >> typeIconFor: aType [
	aType = OPBPMNActivityType Service
		ifTrue: [ ^ OPBPMNIcon current activityService ].
	aType = OPBPMNActivityType User
		ifTrue: [ ^ OPBPMNIcon current activityUser ].
	aType = OPBPMNActivityType Manual
		ifTrue: [ ^ OPBPMNIcon current activityManual ].
			aType = OPBPMNActivityType Send
		ifTrue: [ ^ OPBPMNIcon current activitySend ].
			aType = OPBPMNActivityType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceive ].
			aType = OPBPMNActivityType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]

{ #category : #hooks }
OPBPMNActivityController >> typeIconForModel [
	^ self typeIconFor: self model type
]
