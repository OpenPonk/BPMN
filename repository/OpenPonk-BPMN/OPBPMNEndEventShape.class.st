Class {
	#name : #OPBPMNEndEventShape,
	#superclass : #OPBPMNEventShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNEndEventShape >> createRoassalShape [
	^ RSCircle new
		size: 36;
		borderColor: Color black;
		border: (RSBorder new
		color: (Color black);
		width: 5);
		yourself
]

{ #category : #hooks }
OPBPMNEndEventShape >> typeIconFor: aType [
	aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySendSquare ].
	aType = OPBPMNNodeType EscalationThrow
		ifTrue: [ ^ OPBPMNIcon current eventEscalationThrow ].
	aType = OPBPMNNodeType Error
		ifTrue: [ ^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Cancel
		ifTrue: [ ^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType CompensationThrow
		ifTrue: [ ^ OPBPMNIcon current eventCompensationThrow ].
	aType = OPBPMNNodeType SignalThrow
		ifTrue: [ ^ OPBPMNIcon current eventSignalThrow ].
	aType = OPBPMNNodeType MultipleThrow
		ifTrue: [ ^ OPBPMNIcon current eventMultipleThrow ].
	aType = OPBPMNNodeType Terminate 
		ifTrue: [ ^ OPBPMNIcon current eventTerminate ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
