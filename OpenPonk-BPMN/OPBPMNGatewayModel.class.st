Class {
	#name : #OPBPMNGatewayModel,
	#superclass : #OPBPMNNodeModel,
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #printing }
OPBPMNGatewayModel >> defaultType [
	^ OPBPMNNodeType Exclusive
]

{ #category : #printing }
OPBPMNGatewayModel >> printType [
	^ 'exclusiveGateway'
]
