Class {
	#name : #OPBPMNPoolController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNPoolController >> canBeTargetFor: aController [
	^ aController isKindOf: OPBPMNNodeController
]

{ #category : #connecting }
OPBPMNPoolController >> createRoassalShape [
	^ RTBox new
		width: 200;
		height: 100;
		color: Color transparent;
		borderColor: Color black;
		+
			(RTBox new
				width: 20;
				height: 100;
				color: Color transparent;
				borderColor: Color black;
				instance);
		yourself
]

{ #category : #accessing }
OPBPMNPoolController >> modelClass [
	^ OPBPMNPoolModel
]
