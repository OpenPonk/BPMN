Class {
	#name : #OPBPMNLaneController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNLaneController >> canBeTargetFor: aController [
	^ aController isKindOf: OPBPMNNodeController
]

{ #category : #connecting }
OPBPMNLaneController >> createElement [
	^ RTBox new
		width: 280;
		height: 100;
		color: Color transparent;
		borderColor: Color black;
		borderWidth: 1;
		element
]

{ #category : #connecting }
OPBPMNLaneController >> createRoassalShape [
	^ RTBox new
		width: 520;
		height: 100;
		color: Color transparent;
		borderColor: Color black;
		borderWidth: 1;
		yourself
]

{ #category : #accessing }
OPBPMNLaneController >> modelClass [
	^ OPBPMNLaneModel
]
