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
OPBPMNActivityController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #(#Service #User  #Manual #Send);
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
		height: 45;
		borderRadius: 10;
		width: 60;
		color: (Color fromHexString: 'f2f2f2');
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNActivityController >> modelClass [
	^ OPBPMNActivityModel
]

{ #category : #connecting }
OPBPMNActivityController >> refreshFigure [
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	labelConstraint move.
	figure trachelShape pushBack.
	iconElement trachelShape form: self typeIconForModel.
	iconConstraint move.
	self diagramController view signalUpdate.
	^ self figure
]

{ #category : #connecting }
OPBPMNActivityController >> renderFigureIn: aView [
	| labeled |
	self diagramController addingFigureFor: self.
	figure := self createRoassalShape elementOn: self model.
	figure
		@ RTDraggable;
		@ RTResizable.
	(labeled := RTLabeled new)
		view: aView;
		top;
		color: Color black.
	figure @ labeled.
	labelConstraint := (RTConstraint on: labeled lbl background: figure)
		topLeft;
		padding: 5;
		stick.
	figure renderIn: aView.
	iconElement := (RTBitmap new form: self typeIconForModel) element.
	iconElement renderIn: aView.
	iconConstraint := (RTConstraint on: iconElement background: figure)
		topRight;
		padding: 5;
		stick.
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
		ifTrue: [ ^ OPBPMNIcon current activity ]

]

{ #category : #hooks }
OPBPMNActivityController >> typeIconForModel [
	^ self typeIconFor: self model type
]
