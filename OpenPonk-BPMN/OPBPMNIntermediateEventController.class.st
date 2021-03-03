Class {
	#name : #OPBPMNIntermediateEventController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeSourceFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> canBeTargetFor: aController [
	^ aController modelClass = OPBPMNFlowModel
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
OPBPMNIntermediateEventController >> innerCircle [
	^ RTRoundedBox new
		size: 28;
		borderRadius: 14;
		borderWidth: 1;
		color: Color transparent;
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNIntermediateEventController >> modelClass [
	^ OPBPMNIntermediateEventModel
]
