"
Headless UI tests for the BPMN simulation configuration presenter, verifying lifecycle initialization, window sizing, and exclusive and inclusive gateway routing controls.
"
Class {
	#name : 'OPBPMNSimConfigurationGUITest',
	#superclass : 'OPAbstractUITest',
	#instVars : [
		'openWindowsBefore',
		'configGui',
		'window'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNSimConfigurationGUITest >> buildGatewayModel [

	| model start exclusiveGateway inclusiveGateway parallelGateway emptyGateway task1 task2 task3 task4 flow1 flow2 flow3 flow4 flow5 flow6 |
	model := OPBPMNModel new name: 'Gateway Config Model'.
	start := OPBPMNStartEventModel new name: 'Start'.
	exclusiveGateway := OPBPMNGatewayModel new
		                    name: 'XOR';
		                    type: OPBPMNNodeType Exclusive;
		                    yourself.
	inclusiveGateway := OPBPMNGatewayModel new
		                    name: 'OR';
		                    type: OPBPMNNodeType Inclusive;
		                    yourself.
	parallelGateway := OPBPMNGatewayModel new
		                   name: 'AND';
		                   type: OPBPMNNodeType Parallel;
		                   yourself.
	emptyGateway := OPBPMNGatewayModel new
		                name: 'EmptyXOR';
		                type: OPBPMNNodeType ExclusiveEmpty;
		                yourself.
	task1 := OPBPMNActivityModel new name: 'T1'.
	task2 := OPBPMNActivityModel new name: 'T2'.
	task3 := OPBPMNActivityModel new name: 'T3'.
	task4 := OPBPMNActivityModel new name: 'T4'.
	flow1 := (OPBPMNFlowModel from: start to: exclusiveGateway)
		         name: 'F1';
		         yourself.
	flow2 := (OPBPMNFlowModel from: exclusiveGateway to: task1)
		         name: 'BranchA';
		         yourself.
	flow3 := (OPBPMNFlowModel from: exclusiveGateway to: task2)
		         name: 'BranchB';
		         type: #Default;
		         yourself.
	flow4 := (OPBPMNFlowModel from: inclusiveGateway to: task3)
		         name: 'IncA';
		         yourself.
	flow5 := (OPBPMNFlowModel from: inclusiveGateway to: task4)
		         name: 'IncB';
		         yourself.
	flow6 := (OPBPMNFlowModel from: start to: parallelGateway)
		         name: 'F6';
		         yourself.
	start
		addFlow: flow1;
		addFlow: flow6.
	exclusiveGateway
		addFlow: flow1;
		addFlow: flow2;
		addFlow: flow3.
	inclusiveGateway
		addFlow: flow4;
		addFlow: flow5.
	parallelGateway addFlow: flow6.
	task1 addFlow: flow2.
	task2 addFlow: flow3.
	task3 addFlow: flow4.
	task4 addFlow: flow5.
	model
		add: start;
		add: exclusiveGateway;
		add: inclusiveGateway;
		add: parallelGateway;
		add: emptyGateway;
		add: task1;
		add: task2;
		add: task3;
		add: task4;
		add: flow1;
		add: flow2;
		add: flow3;
		add: flow4;
		add: flow5;
		add: flow6.
	^ model
]

{ #category : 'running' }
OPBPMNSimConfigurationGUITest >> setUp [

	super setUp.
	openWindowsBefore := (self currentWorld submorphs select: [ :eachMorph | eachMorph isSystemWindow ]) asIdentitySet
]

{ #category : 'running' }
OPBPMNSimConfigurationGUITest >> tearDown [

	(window isNotNil and: [ window isOpen ]) ifTrue: [ window close ].
	self currentWorld submorphs
		select: [ :eachMorph | eachMorph isSystemWindow and: [ (openWindowsBefore includes: eachMorph) not ] ]
		thenDo: [ :eachWindow | eachWindow delete ].
	window := nil.
	configGui := nil.
	openWindowsBefore := nil.
	super tearDown
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testNewFollowedByDiagramSimulatorSetterInitializesPresenters [

	| diagramSimulator gatewayPresenters |
	diagramSimulator := OPBPMNSimulator model: self buildGatewayModel.
	configGui := OPBPMNSimConfigurationGUI new
		             diagramSimulator: diagramSimulator;
		             yourself.
	self assert: configGui diagramSimulator identicalTo: diagramSimulator.
	gatewayPresenters := configGui instVarNamed: #gatewayPresenters.
	self assert: gatewayPresenters size equals: 3
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testOpenConfigurationWithExclusiveAndInclusiveGateways [

	| diagramSimulator gatewayPresenters exclusiveSimulator inclusiveSimulator emptySimulator exclusiveRow inclusiveRow emptyRow branchAButton branchBButton incAButton incBButton |
	diagramSimulator := OPBPMNSimulator model: self buildGatewayModel.
	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	window := configGui asWindow.
	configGui initializeWindow: window.

	self assert: window title equals: 'Simulator Configuration'.
	self assert: window initialExtent equals: 400 @ 200.

	gatewayPresenters := configGui instVarNamed: #gatewayPresenters.
	self assert: gatewayPresenters size equals: 3.

	exclusiveSimulator := diagramSimulator configurableGateways detect: [ :each | each model name = 'XOR' ].
	inclusiveSimulator := diagramSimulator configurableGateways detect: [ :each | each model name = 'OR' ].
	emptySimulator := diagramSimulator configurableGateways detect: [ :each | each model name = 'EmptyXOR' ].

	emptyRow := gatewayPresenters at: emptySimulator.
	self assert: emptyRow size equals: 1.
	self assert: emptyRow first label equals: 'EmptyXOR'.

	exclusiveRow := gatewayPresenters at: exclusiveSimulator.
	self assert: exclusiveRow size equals: 3.
	self assert: exclusiveRow first label equals: 'XOR'.
	branchAButton := exclusiveRow allButFirst detect: [ :each | each label = 'BranchA' ].
	branchBButton := exclusiveRow allButFirst detect: [ :each | each label = 'BranchB' ].
	self assert: branchBButton state description: 'Default outgoing branch radio button must start selected'.

	branchAButton state: true.
	self assert: exclusiveSimulator outgoingActive size equals: 1.
	self assert: exclusiveSimulator outgoingActive first model name equals: 'BranchA'.

	inclusiveRow := gatewayPresenters at: inclusiveSimulator.
	self assert: inclusiveRow size equals: 3.
	incAButton := inclusiveRow allButFirst detect: [ :each | each label = 'IncA' ].
	incBButton := inclusiveRow allButFirst detect: [ :each | each label = 'IncB' ].
	self assert: incAButton state description: 'Initially active outgoing branch checkbox must start checked'.
	self deny: incBButton state description: 'Initially inactive outgoing branch checkbox must start unchecked'.

	incBButton state: true.
	self assert: inclusiveSimulator outgoingActive size equals: 2.
	incAButton state: false.
	self assert: inclusiveSimulator outgoingActive size equals: 1.
	self assert: inclusiveSimulator outgoingActive first model name equals: 'IncB'
]
