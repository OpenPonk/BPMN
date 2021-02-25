Class {
	#name : #OPBPMNStartEventController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

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
