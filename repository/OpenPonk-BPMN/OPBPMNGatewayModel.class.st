"
I represent a BPMN Gateway in the semantic model, controlling the divergence and convergence of process paths based on its specific gateway type.
"
Class {
	#name : 'OPBPMNGatewayModel',
	#superclass : 'OPBPMNFlowNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNGatewayModel >> defaultType [
	^ OPBPMNNodeType ExclusiveEmpty
]

{ #category : 'printing' }
OPBPMNGatewayModel >> printType [

	type = OPBPMNNodeType Parallel ifTrue: [ ^ 'parallelGateway' ].
	type = OPBPMNNodeType Inclusive ifTrue: [ ^ 'inclusiveGateway' ].
	(type = OPBPMNNodeType Exclusive or: [
		 type = OPBPMNNodeType ExclusiveEmpty ]) ifTrue: [
		^ 'exclusiveGateway' ].
	type = OPBPMNNodeType Complex ifTrue: [ ^ 'complexGateway' ].
	type = OPBPMNNodeType Eventbased ifTrue: [ ^ 'eventBasedGateway' ].
	type = OPBPMNNodeType None ifTrue: [ ^ 'exclusiveGateway' ]
]
