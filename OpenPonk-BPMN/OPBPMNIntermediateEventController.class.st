Class {
	#name : #OPBPMNIntermediateEventController,
	#superclass : #OPBPMNElementController,
	#instVars : [
		'innerCircle',
		'elements',
		'innerConstraint',
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #hooks }
OPBPMNIntermediateEventController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #(#Send #Receive #Timer #Link #None);
		iconHolder: [ :type | self typeIconFor: type ];
		displayBlock: [ :type | type asString ];
		setSelectedItem: self model type;
		whenSelectedItemChanged: [ :newValue | 
			self model type: newValue.
			self refreshFigure ]
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [
		(aController isKindOf: OPBPMNMessageFlowController)
		ifTrue: [ ^ (aController source model owner ~= self model owner)]
		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> createRoassalShape [
	^ RTRoundedBox new
		size: 36;
		borderRadius: 18;
		borderWidth: 1;
		color: Color transparent;
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> modelClass [
	^ OPBPMNIntermediateEventModel
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> refreshFigure [
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	innerConstraint move.
		iconElement trachelShape form: self typeIconForModel.
	iconConstraint move.
	self diagramController view signalUpdate.
	figure pushFront.
	^ super refreshFigure
]

{ #category : #construction }
OPBPMNIntermediateEventController >> renderFigureIn: aView [
	self diagramController addingFigureFor: self.
	figure := self createRoassalShape elementOn: self model.
	figure
		addInteraction:
			(OPRTMultilineLabeled new
				view: aView;
				below;
				color: Color black;
				yourself).
	figure @ RTDraggable.
	figure @ OPRTFocusable.
	figure renderIn: aView.
	innerCircle := RTRoundedBox new
		size: 28;
		borderRadius: 14;
		borderWidth: 1;
		color: Color transparent;
		borderColor: Color black;
		element.
	innerConstraint := (RTConstraint on: innerCircle background: figure)
		stick.
	innerCircle renderIn: aView.
	figure addCallback: (TRRemoveCallback with: innerCircle).
		iconElement := (RTBitmap new form: self typeIconForModel) element.
	iconConstraint := (RTConstraint on: iconElement background: figure)
		center;
		stick.
	iconElement renderIn: aView.
	figure addCallback: (TRRemoveCallback with: iconElement).
	self saveStateOnDragEndFor: figure.
	^ self diagramController addedFigureFor: self
]

{ #category : #hooks }
OPBPMNIntermediateEventController >> typeIconFor: aType [
	aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySendSquare ].
	aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Link
		ifTrue: [ ^ OPBPMNIcon current eventLink ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> typeIconForModel [
	^ self typeIconFor: self model type
]
