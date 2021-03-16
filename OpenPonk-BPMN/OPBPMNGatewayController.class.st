Class {
	#name : #OPBPMNGatewayController,
	#superclass : #OPBPMNNodeController,
	#instVars : [
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNGatewayController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #(#Parallel #OR #XOR #Complex #Eventbased #None);
		iconHolder: [ :type | self typeIconFor: type ];
		displayBlock: [ :type | type asString ];
		setSelectedItem: self model type;
		whenSelectedItemChanged: [ :newValue | 
			self model type: newValue.
			self refreshFigure ]
]

{ #category : #connecting }
OPBPMNGatewayController >> canBeSourceFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #connecting }
OPBPMNGatewayController >> canBeTargetFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #connecting }
OPBPMNGatewayController >> createRoassalShape [
	^ RTBox new
		size: 34;
		color: Color transparent;
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNGatewayController >> modelClass [
	^ OPBPMNGatewayModel
]

{ #category : #connecting }
OPBPMNGatewayController >> refreshFigure [
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	iconElement trachelShape form: self typeIconForModel.
	iconConstraint move.
	^ super refreshFigure
]

{ #category : #construction }
OPBPMNGatewayController >> renderFigureIn: aView [
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
	figure rotateByDegrees: 45.
	figure renderIn: aView.
		iconElement := (RTBitmap new form: self typeIconForModel) element.
	iconConstraint := (RTConstraint on: iconElement background: figure)
		center;
		stick.
	iconElement renderIn: aView.
	figure addCallback: (TRRemoveCallback with: iconElement).
	self saveStateOnDragEndFor: figure.
	^ self diagramController addedFigureFor: self
]

{ #category : #connecting }
OPBPMNGatewayController >> typeIconFor: aType [
	aType = OPBPMNNodeType Parallel
		ifTrue: [ ^ OPBPMNIcon current gatewayParallel ].
	aType = OPBPMNNodeType OR
		ifTrue: [ ^ OPBPMNIcon current gatewayOr ].
	aType = OPBPMNNodeType XOR
		ifTrue: [ ^ OPBPMNIcon current gatewayXor ].
	aType = OPBPMNNodeType Complex
		ifTrue: [ ^ OPBPMNIcon current gatewayComplex ].
	aType = OPBPMNNodeType Eventbased
		ifTrue: [ ^ OPBPMNIcon current gatewayEvent ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]

{ #category : #connecting }
OPBPMNGatewayController >> typeIconForModel [
	^ self typeIconFor: self model type
]