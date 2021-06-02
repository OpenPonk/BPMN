Class {
	#name : #OPBPMNStartEventController,
	#superclass : #OPBPMNEventController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNStartEventController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #(#Receive #Timer #None);
		iconHolder: [ :type | self typeIconFor: type ];
		displayBlock: [ :type | type asString ];
		setSelectedItem: self model type;
		whenSelectedItemChanged: [ :newValue | 
			self model type: newValue.
			self refreshFigure ].
	self model type = OPBPMNNodeType Timer
		ifTrue: [ (aForm addDroplist: 'Timer type')
				items: #(#none #timeDate #timeDuration #timeCycle);
				displayBlock: [ :type | type asString ];
				setSelectedItem: self model timerType;
				whenSelectedItemChanged: [ :newValue | 
					self model timerType: newValue.
					self refreshFigure ].
			(aForm addText: 'Timer value')
				text: self model timerValue;
				whenTextIsAccepted: [ :newValue | 
					self model timerValue: newValue asString.
					self refreshFigure ] ]
]

{ #category : #connecting }
OPBPMNStartEventController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : #connecting }
OPBPMNStartEventController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNMessageFlowController)
		ifTrue: [ ^ aController source model owner ~= self model owner ]
		ifFalse: [ ^ false ] 
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

{ #category : #connecting }
OPBPMNStartEventController >> modelClass [
	^ OPBPMNStartEventModel
]

{ #category : #hooks }
OPBPMNStartEventController >> typeIconFor: aType [
	aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
