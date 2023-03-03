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
		items:
			#( #Send #Receive #Timer #Escalation #EscalationThrow
			   #Conditional #Link #LinkThrow #Compensation #CompensationThrow
			   #Signal #SignalThrow #Multiple #MultipleThrow #ParallelMultiple
			   #None );
		displayIcon: [ :type | self typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
	self model type = OPBPMNNodeType Timer ifTrue: [ 
		(aForm addDroplist: 'Timer type')
			items: #( #none #timeDate #timeDuration #timeCycle );
			display: [ :type | type asString ];
			selectItem: self model timerType;
			whenSelectedItemChangedDo: [ :newValue | 
				self model timerType: newValue.
				self refreshFigure ].
		(aForm addText: 'Timer value')
			text: self model timerValue;
			whenTextChangedDo: [ :newValue | 
				self model timerValue: newValue asString.
				self refreshFigure ] ].
	self model type = OPBPMNNodeType Send
		ifTrue: [ 
			(aForm addText: 'Executable attribute')
				text: self model executableAttribute;
				whenTextChangedDo: [ :newValue | 
					self model executableAttribute: newValue asString.
					self refreshFigure ].
			(aForm addText: 'Executable attribute value')
				text: self model executableAttributeValue;
				whenTextChangedDo: [ :newValue | 
					self model executableAttributeValue: newValue asString.
					self refreshFigure ] ]
		ifFalse: [ self model executableAttribute: nil ]
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ aController isKindOf: OPBPMNEdgeController ]
			 ]
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

{ #category : #connecting }
OPBPMNIntermediateEventController >> diagramElementClass [

	^ OPBPMNIntermediateEventShape
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> modelClass [
	^ OPBPMNIntermediateEventModel
]

{ #category : #construction }
OPBPMNIntermediateEventController >> renderFigureIn: aView [
	self diagramController willRender: self.
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
	^ self diagramController rendered: self
]

{ #category : #hooks }
OPBPMNIntermediateEventController >> typeIconFor: aType [
	aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySendSquare ].
	aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation
		ifTrue: [ ^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType EscalationThrow
		ifTrue: [ ^ OPBPMNIcon current eventEscalationThrow ].
	aType = OPBPMNNodeType Conditional
		ifTrue: [ ^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Link
		ifTrue: [ ^ OPBPMNIcon current eventLink ].
	aType = OPBPMNNodeType LinkThrow
		ifTrue: [ ^ OPBPMNIcon current eventLinkThrow ].
	aType = OPBPMNNodeType Compensation
		ifTrue: [ ^ OPBPMNIcon current eventCatchCompensation ].
	aType = OPBPMNNodeType CompensationThrow
		ifTrue: [ ^ OPBPMNIcon current eventCompensationThrow ].
	aType = OPBPMNNodeType Signal
		ifTrue: [ ^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType SignalThrow
		ifTrue: [ ^ OPBPMNIcon current eventSignalThrow ].
	aType = OPBPMNNodeType Multiple
		ifTrue: [ ^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType MultipleThrow
		ifTrue: [ ^ OPBPMNIcon current eventMultipleThrow ].
	aType = OPBPMNNodeType ParallelMultiple
		ifTrue: [ ^ OPBPMNIcon current eventParallelMultiple ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]

{ #category : #connecting }
OPBPMNIntermediateEventController >> typeIconForModel [
	^ self typeIconFor: self model type
]
