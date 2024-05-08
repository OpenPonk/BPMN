Class {
	#name : 'OPBPMNGatewayModel',
	#superclass : 'OPBPMNFlowNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'printing' }
OPBPMNGatewayModel >> defaultType [
	^ OPBPMNNodeType Exclusive
]

{ #category : 'printing' }
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

{ #category : 'printing' }
OPBPMNGatewayModel >> typeIconFor: aType [
	aType = OPBPMNNodeType Parallel
		ifTrue: [ ^ OPBPMNIcon current gatewayParallel ].
	aType = OPBPMNNodeType Inclusive
		ifTrue: [ ^ OPBPMNIcon current gatewayInclusive ].
	aType = OPBPMNNodeType Exclusive
		ifTrue: [ ^ OPBPMNIcon current gatewayExclusive ].
	aType = OPBPMNNodeType Complex
		ifTrue: [ ^ OPBPMNIcon current gatewayComplex ].
	aType = OPBPMNNodeType Eventbased
		ifTrue: [ ^ OPBPMNIcon current gatewayEvent ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
