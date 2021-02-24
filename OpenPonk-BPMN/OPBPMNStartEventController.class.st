Class {
	#name : #OPBPMNStartEventController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #testing }
OPBPMNStartEventController class >> initializePossibleConnected [
	PossibleOutgoing := Set
		with: OPBPMNFlowController
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
