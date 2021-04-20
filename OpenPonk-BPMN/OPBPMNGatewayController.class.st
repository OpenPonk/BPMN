Class {
	#name : #OPBPMNGatewayController,
	#superclass : #OPBPMNElementController,
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
		items: #(#Exclusive #Inclusive #Parallel #Complex #Eventbased);
		iconHolder: [ :type | self typeIconFor: type ];
		displayBlock: [ :type | type asString ];
		setSelectedItem: self model type;
		whenSelectedItemChanged: [ :newValue | 
			self model type: newValue.
			self refreshFigure ]
]

{ #category : #connecting }
OPBPMNGatewayController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNFlowController
]

{ #category : #connecting }
OPBPMNGatewayController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPBPMNFlowController)
		
]

{ #category : #connecting }
OPBPMNGatewayController >> createRoassalShape [
	^ RTBox new
		size: 34;
		color: (Color fromHexString: 'bce2fe');
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
	aType = OPBPMNNodeType Inclusive
		ifTrue: [ ^ OPBPMNIcon current gatewayInclusive ].
	aType = OPBPMNNodeType Exclusive
		ifTrue: [ ^ OPBPMNIcon current gatewayExclusive ].
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
