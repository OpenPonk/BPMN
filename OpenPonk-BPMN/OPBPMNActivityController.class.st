Class {
	#name : #OPBPMNActivityController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #testing }
OPBPMNActivityController class >> initializePossibleConnected [
	PossibleOutgoing := Set
		with: OPBPMNFlowController
]

{ #category : #connecting }
OPBPMNActivityController >> createRoassalShape [
	^ RTRoundedBox new
		height: 45;
		borderRadius: 10;
		width: 60;
		color: (Color fromHexString: 'f2f2f2');
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNActivityController >> modelClass [
	^ OPBPMNActivityModel
]
