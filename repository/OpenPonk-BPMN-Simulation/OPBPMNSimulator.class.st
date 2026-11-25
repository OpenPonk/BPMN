"
Simulator for BPMN diagrams. Coordinates execution flow across the process, manages global stepping, and tracks configurable gateways.
"
Class {
	#name : 'OPBPMNSimulator',
	#superclass : 'OPDiagramSimulator',
	#instVars : [
		'configurableGateways'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'initialization' }
OPBPMNSimulator class >> initialClassMapping [

	^ super initialClassMapping
		  at: OPBPMNDataFlowModel put: OPBPMNDataFlowSimulator;
		  at: OPBPMNFlowModel put: OPBPMNSequenceFlowSimulator;
		  at: OPBPMNMessageFlowModel put: OPBPMNMessageFlowSimulator;
		  at: OPBPMNBoundaryEventModel put: OPBPMNBoundaryEventSimulator;
		  at: OPBPMNDataObjectModel put: OPBPMNDataObjectSimulator;
		  at: OPBPMNActivityModel put: OPBPMNActivitySimulator;
		  at: OPBPMNCollapsedSubProcessModel
		  put: OPBPMNCollapsedSubProcessSimulator;
		  at: OPBPMNEndEventModel put: OPBPMNEndEventSimulator;
		  at: OPBPMNIntermediateEventModel
		  put: OPBPMNIntermediateEventSimulator;
		  at: OPBPMNStartEventModel put: OPBPMNStartEventSimulator;
		  at: OPBPMNGatewayModel put: OPBPMNGatewaySimulator;
		  at: OPBPMNSubProcessModel put: OPBPMNSubProcessSimulator;
		  at: OPBPMNPoolModel put: OPBPMNPoolSimulator;
		  yourself
]

{ #category : 'accessing' }
OPBPMNSimulator >> configurableGateways [

	^ configurableGateways
]

{ #category : 'initialization' }
OPBPMNSimulator >> initialize [

	super initialize.
	configurableGateways := OrderedCollection new
]

{ #category : 'private - creation' }
OPBPMNSimulator >> isGateway: firstGateway orderedBefore: secondGateway [

	| firstKey secondKey |
	firstKey := self sortKeyForGateway: firstGateway.
	secondKey := self sortKeyForGateway: secondGateway.
	firstKey with: secondKey do: [ :firstPart :secondPart | firstPart = secondPart ifFalse: [ ^ firstPart < secondPart ] ].
	^ true
]

{ #category : 'private - creation' }
OPBPMNSimulator >> loadConfigurableGateways [
	"Selects branching configurable gateways in deterministic order."

	configurableGateways := (elements select: [ :element | element isGateway and: [ element isConfigurable ] ]) sorted: [
		                        :firstGateway
		                        :secondGateway | self isGateway: firstGateway orderedBefore: secondGateway ]
]

{ #category : 'initialization' }
OPBPMNSimulator >> loadItems [
	"creates simulators for model elements"

	super loadItems.
	self loadConfigurableGateways 
]

{ #category : 'initialization' }
OPBPMNSimulator >> setDefaultStepping [
	"sets default stepping settings"

	super setDefaultStepping.
	self
		fromSteppableElements;
		orderByPriority;
		selectAll;
		resetActions;
		addAction: [ :item | item step ]
]

{ #category : 'private - creation' }
OPBPMNSimulator >> sortKeyForGateway: aGatewaySimulator [

	| trimmedName |
	trimmedName := (aGatewaySimulator model name ifNil: [ '' ]) trimBoth.
	^ {
		  (trimmedName isEmpty
			   ifTrue: [ 1 ]
			   ifFalse: [ 0 ]).
		  trimmedName asLowercase.
		  aGatewaySimulator model type asString asLowercase.
		  aGatewaySimulator model uuid asString }
]
