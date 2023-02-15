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
	aType = OPBPMNNodeType Link
		ifTrue: [ ^ OPBPMNIcon current eventLink ].
	aType = OPBPMNNodeType Cancel
		ifTrue: [ ^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType Error
		ifTrue: [ ^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
