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
	type = OPBPMNNodeType Parallel
		ifTrue: [ ^ 'parallelGateway' ].
	type = OPBPMNNodeType Inclusive
		ifTrue: [ ^ 'inclusiveGateway' ].
	type = OPBPMNNodeType Exclusive
		ifTrue: [ ^ 'exclusiveGateway' ].
	type = OPBPMNNodeType Complex
		ifTrue: [ ^ 'complexGateway' ].
	type = OPBPMNNodeType Eventbased
		ifTrue: [ ^ 'eventBasedGateway' ].
	type = OPBPMNNodeType None
		ifTrue: [ ^ 'exclusiveGateway' ]
]
