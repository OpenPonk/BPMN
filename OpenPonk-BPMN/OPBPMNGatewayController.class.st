Class {
	#name : #OPBPMNGatewayController,
	#superclass : #OPBPMNNodeController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #connecting }
OPBPMNGatewayController >> canBeSourceFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #connecting }
OPBPMNGatewayController >> canBeTargetFor: aController [
	^ aController modelClass = OPBPMNFlowModel
]

{ #category : #connecting }
OPBPMNGatewayController >> createRoassalShape [
	^ RTBox new
		size: 34;
		rotation: 22;
		color: Color transparent;
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPBPMNGatewayController >> modelClass [
	^ OPBPMNGatewayModel
]
