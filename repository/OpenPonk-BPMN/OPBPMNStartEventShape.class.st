Class {
	#name : #OPBPMNStartEventShape,
	#superclass : #OPBPMNEventShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNStartEventShape >> createRoassalShape [
	^ RSCircle new
		size: 39;
		borderColor: Color black;
		yourself
]

{ #category : #hooks }
OPBPMNStartEventShape >> typeIconFor: aType [
	aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
