Class {
	#name : #OPBPMNActivityController,
	#superclass : #OPBPMNElementController,
	#instVars : [
		'labelConstraint',
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

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
	(aController isKindOf: OPBPMNMessageFlowController)
		ifTrue: [ ^ (aController source model owner ~= self model owner)]
		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
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
OPBPMNActivityController >> modelClass [
	^ OPBPMNActivityModel
]

{ #category : #hooks }
OPBPMNActivityController >> refreshFigure [
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	labelConstraint move.
	iconElement trachelShape form: self typeIconForModel.
	iconConstraint move.
	self diagramController view signalUpdate.
	figure pushFront.
   (figure attributeAt: #RTLabelledLabel) trachelShape pushFront.
	iconElement pushFront.
	^ super refreshFigure
]

{ #category : #hooks }
OPBPMNActivityController >> renderFigureIn: aView [
	| labeled |
	self diagramController addingFigureFor: self.
	figure := self createRoassalShape elementOn: self model.
	figure @ RTDraggable.
	figure @ RTResizable.
	figure @ OPRTFocusable.
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
	"(self diagramController
		showWithoutDependentInDiagramModel: self model owner)
		addedNodeFigure: figure."
	^ self diagramController addedFigureFor: self
]

{ #category : #hooks }
OPBPMNActivityController >> typeIconFor: aType [
	aType = OPBPMNNodeType Service
		ifTrue: [ ^ OPBPMNIcon current activityService ].
	aType = OPBPMNNodeType User
		ifTrue: [ ^ OPBPMNIcon current activityUser ].
	aType = OPBPMNNodeType Manual
		ifTrue: [ ^ OPBPMNIcon current activityManual ].
			aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySend ].
			aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceive ].
			aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]

{ #category : #hooks }
OPBPMNActivityController >> typeIconForModel [
	^ self typeIconFor: self model type
]
