Class {
	#name : #OPBPMNStartEventController,
	#superclass : #OPBPMNEventController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNStartEventController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #(#Message #Timer #None);
		iconHolder: [ :type | self typeIconFor: type ];
		displayBlock: [ :type | type asString ];
		setSelectedItem: self model type;
		whenSelectedItemChanged: [ :newValue | 
			self model type: newValue.
			self refreshFigure ]
]

{ #category : #connecting }
OPBPMNStartEventController >> canBeSourceFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #connecting }
OPBPMNStartEventController >> canBeTargetFor: aController [
	^ false
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
		ifTrue: [ ^ OPBPMNIcon current activityReceive ].
			aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
