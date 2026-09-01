"
Simulator component for BPMN gateways. Evaluates routing conditions, manages active outgoing branches, and splits or merges token flows.
"
Class {
	#name : 'OPBPMNGatewaySimulator',
	#superclass : 'OPBPMNFlowNodeSimulator',
	#instVars : [
		'outgoingActive'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'instance creation' }
OPBPMNGatewaySimulator class >> model: anElement diagramSimulator: aDiagramSimulator [

	| type simulator |
	type := anElement type.

	simulator := nil.

	type = OPBPMNNodeType Parallel ifTrue: [
		simulator := OPBPMNParallelGatewaySimulator new ].

	({
		 OPBPMNNodeType Inclusive.
		 OPBPMNNodeType Complex } includes: type) ifTrue: [
		simulator := OPBPMNInclusiveGatewaySimulator new ].

	({
		 OPBPMNNodeType ExclusiveEmpty.
		 OPBPMNNodeType Exclusive.
		 OPBPMNNodeType Eventbased } includes: type) ifTrue: [
		simulator := OPBPMNExclusiveGatewaySimulator new ].

	self assert: simulator isNotNil.

	^ simulator
		  model: anElement;
		  diagramSimulator: aDiagramSimulator;
		  yourself
]

{ #category : 'testing' }
OPBPMNGatewaySimulator >> canSendBpmnTokens [

	^ outgoingActive notEmpty
]

{ #category : 'initialization' }
OPBPMNGatewaySimulator >> initialize [

	super initialize.
	outgoingActive := OrderedCollection new
]

{ #category : 'testing' }
OPBPMNGatewaySimulator >> isConfigurable [

	^ true
]

{ #category : 'testing' }
OPBPMNGatewaySimulator >> isGateway [

	^ true
]

{ #category : 'creation' }
OPBPMNGatewaySimulator >> loadConnectedItems [
	"loads and/or connects appropriate tokens and elements"

	super loadConnectedItems.
	model outgoing ifEmpty: [ ^ self ].
	outgoingActive := model outgoing
		                  select: [ :flow | flow type = #Default ]
		                  thenCollect: [ :flow |
		                  diagramSimulator simulatorOf: flow ].
	outgoingActive ifEmpty: [
		outgoingActive add:
			(diagramSimulator simulatorOf: model outgoing first) ]
]

{ #category : 'accessing' }
OPBPMNGatewaySimulator >> outgoingActive [

	^ outgoingActive
]

{ #category : 'accessing' }
OPBPMNGatewaySimulator >> outgoingActive: anOrderedCollection [

	outgoingActive := anOrderedCollection
]
