Class {
	#name : #OPBPMNStartEventController,
	#superclass : #OPBPMNEventController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNStartEventController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #None #Receive #Timer #Escalation #Conditional #Error #Compensation
			   #Signal #Multiple #ParallelMultiple );
		displayIcon: [ :type | self typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ].
	(aForm addCheckbox: 'Is Non-Interrupting')
		state: self model isNonInterrupting;
		whenChangedDo: [ :val | 
			self model isNonInterrupting: val.
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
				self refreshFigure ] ]
]

{ #category : #connecting }
OPBPMNStartEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #connecting }
OPBPMNStartEventController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNMessageFlowController)
		  ifTrue: [ ^ aController source model owner ~= self model owner ]
		  ifFalse: [
		  		(aController isKindOf: OPBPMNDataFlowController)
		  		ifTrue: [ ^ (aController source model) isKindOf: OPBPMNDataObjectModel  ]
		 		ifFalse: [ ^ false]
			 ]
]

{ #category : #connecting }
OPBPMNStartEventController >> createRoassalShape [
	^ RTRoundedBox new
		size: 36;
		borderRadius: 18;
		color: Color transparent;
		borderColor: Color black;
		yourself
]

{ #category : #hooks }
OPBPMNStartEventController >> diagramElementClass [

	^ OPBPMNStartEventShape
]

{ #category : #connecting }
OPBPMNStartEventController >> modelClass [
	^ OPBPMNStartEventModel
]

{ #category : #connecting }
OPBPMNStartEventController >> typeIconFor: aType [
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ].
	aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation
		ifTrue: [ ^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType Conditional
		ifTrue: [ ^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Error
		ifTrue: [ ^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Compensation
		ifTrue: [ ^ OPBPMNIcon current eventCatchCompensation ].
	aType = OPBPMNNodeType Signal
		ifTrue: [ ^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType Multiple
		ifTrue: [ ^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType ParallelMultiple
		ifTrue: [ ^ OPBPMNIcon current eventParallelMultiple ].
]
