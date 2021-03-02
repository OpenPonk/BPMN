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
		height: 30;
		width: 30;
		borderColor: Color black;
		color: Color white;
		rotation: 22;
		yourself
]

{ #category : #accessing }
OPBPMNGatewayController >> modelClass [
	^ OPBPMNGatewayModel
]
