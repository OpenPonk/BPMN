"
Unit tests for OPBPMNSimulator.
Verifies diagram-level simulation stepping, state management, and overall execution flow logic.
"
Class {
	#name : 'OPBPMNSimulatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'simulator'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNSimulatorTest >> exampleModel [

	| model activity1 flow1 flow2 start1 end1 |
	model := OPBPMNModel new name: 'BPMN Diagram'.
	start1 := OPBPMNStartEventModel new
		          name: 'S1';
		          yourself.
	end1 := OPBPMNEndEventModel new
		        name: 'E1';
		        yourself.
	activity1 := OPBPMNActivityModel new
		             name: 'A1';
		             yourself.
	model
		add: start1;
		add: end1;
		add: activity1.
	flow1 := OPBPMNFlowModel from: start1 to: activity1.
	flow2 := OPBPMNFlowModel from: activity1 to: end1.
	model
		add: flow1;
		add: flow2.
	^ model
]

{ #category : 'running' }
OPBPMNSimulatorTest >> setUp [

	super setUp.

	simulator := self simulatorClass model: self exampleModel
]

{ #category : 'running' }
OPBPMNSimulatorTest >> simulatorClass [

	^ OPBPMNSimulator
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testConfigurableGatewaysExcludesParallelGateways [

	| testModel exclusiveGateway inclusiveGateway parallelGateway mergeGateway deadEndGateway task1 task2 task3 task4 task5 task6 task7 diagramSimulator |
	testModel := OPBPMNModel new name: 'Gateways'.
	exclusiveGateway := OPBPMNGatewayModel new
		                    name: 'ExclusiveSplit';
		                    type: OPBPMNNodeType Exclusive;
		                    yourself.
	inclusiveGateway := OPBPMNGatewayModel new
		                    name: 'InclusiveSplit';
		                    type: OPBPMNNodeType Inclusive;
		                    yourself.
	parallelGateway := OPBPMNGatewayModel new
		                   name: 'ParallelSplit';
		                   type: OPBPMNNodeType Parallel;
		                   yourself.
	mergeGateway := OPBPMNGatewayModel new
		                name: 'MergeGateway';
		                type: OPBPMNNodeType Exclusive;
		                yourself.
	deadEndGateway := OPBPMNGatewayModel new
		                  name: 'DeadEndGateway';
		                  type: OPBPMNNodeType Exclusive;
		                  yourself.
	task1 := OPBPMNActivityModel new name: 'T1'.
	task2 := OPBPMNActivityModel new name: 'T2'.
	task3 := OPBPMNActivityModel new name: 'T3'.
	task4 := OPBPMNActivityModel new name: 'T4'.
	task5 := OPBPMNActivityModel new name: 'T5'.
	task6 := OPBPMNActivityModel new name: 'T6'.
	task7 := OPBPMNActivityModel new name: 'T7'.
	{
		exclusiveGateway.
		inclusiveGateway.
		parallelGateway.
		mergeGateway.
		deadEndGateway.
		task1.
		task2.
		task3.
		task4.
		task5.
		task6.
		task7 } do: [ :eachElement | testModel add: eachElement ].
	{
		(exclusiveGateway -> task1).
		(exclusiveGateway -> task2).
		(inclusiveGateway -> task3).
		(inclusiveGateway -> task4).
		(parallelGateway -> task5).
		(parallelGateway -> task6).
		(mergeGateway -> task7) } do: [ :eachPair |
			| sequenceFlow |
			sequenceFlow := OPBPMNFlowModel from: eachPair key to: eachPair value.
			eachPair key addFlow: sequenceFlow.
			eachPair value addFlow: sequenceFlow.
			testModel add: sequenceFlow ].

	diagramSimulator := self simulatorClass model: testModel.
	self assertCollection: (diagramSimulator configurableGateways collect: #model) hasSameElements: {
			exclusiveGateway.
			inclusiveGateway }
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testConfigurableGatewaysInBuiltInExamples [

	| orderFulfillmentSimulator allElementsSimulator |
	orderFulfillmentSimulator := self simulatorClass model: OPBPMNExamples exampleOrderFulfillment.
	self assert: orderFulfillmentSimulator configurableGateways size equals: 1.
	self assert: orderFulfillmentSimulator configurableGateways first model name equals: 'In Stock?'.

	allElementsSimulator := self simulatorClass model: OPBPMNExamples exampleAllElementsAndTypes.
	self assertEmpty: allElementsSimulator configurableGateways
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testConfigurableGatewaysOrderIsDeterministic [

	| testModel zetaGateway alphaGateway unnamedGateway nilNameGateway targets diagramSimulator |
	testModel := OPBPMNModel new name: 'Deterministic Gateways'.
	zetaGateway := OPBPMNGatewayModel new
		               name: 'Zeta';
		               type: OPBPMNNodeType Exclusive;
		               yourself.
	alphaGateway := OPBPMNGatewayModel new
		                name: 'Alpha';
		                type: OPBPMNNodeType Inclusive;
		                yourself.
	unnamedGateway := OPBPMNGatewayModel new
		                  name: '';
		                  type: OPBPMNNodeType Exclusive;
		                  yourself.
	nilNameGateway := OPBPMNGatewayModel new
		                  name: nil;
		                  type: OPBPMNNodeType Inclusive;
		                  yourself.
	targets := (1 to: 8) collect: [ :index | OPBPMNActivityModel new name: 'Task ' , index asString ].
	{
		zetaGateway.
		alphaGateway.
		unnamedGateway.
		nilNameGateway } , targets do: [ :eachElement | testModel add: eachElement ].
	{
		(zetaGateway -> targets first).
		(zetaGateway -> (targets at: 2)).
		(alphaGateway -> (targets at: 3)).
		(alphaGateway -> (targets at: 4)).
		(unnamedGateway -> (targets at: 5)).
		(unnamedGateway -> (targets at: 6)).
		(nilNameGateway -> (targets at: 7)).
		(nilNameGateway -> (targets at: 8)) } do: [ :eachPair |
			| sequenceFlow |
			sequenceFlow := OPBPMNFlowModel from: eachPair key to: eachPair value.
			eachPair key addFlow: sequenceFlow.
			eachPair value addFlow: sequenceFlow.
			testModel add: sequenceFlow ].

	diagramSimulator := self simulatorClass model: testModel.
	self assert: (diagramSimulator configurableGateways collect: #model as: Array) equals: {
			alphaGateway.
			zetaGateway.
			unnamedGateway.
			nilNameGateway }
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testDefaultStepping [

	| items stepped didAction |
	simulator setDefaultStepping.

	items := simulator itemsForAction.
	self assert: items size equals: 2.
	items do: [ :each |
			self assert: each isSimulable description: 'Default stepping item must be simulable'.
			self assert: each isSteppable description: 'Default stepping item must be steppable' ].
	self assert: (items collect: #class as: Array) equals: {
			OPBPMNStartEventSimulator.
			OPBPMNSequenceFlowSimulator }.

	stepped := OrderedCollection new.
	didAction := OrderedCollection new.
	simulator simulableElementsDo: [ :each |
			each when: OPSimulatorStepped do: [ :event | stepped add: event ] for: self.
			each when: OPSimulatorDidAction do: [ :event | didAction add: event ] for: self ].
	simulator step.
	self assert: stepped size equals: 2.
	self assert: didAction size equals: 2
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testExampleAllElementsAndTypesLoadsWithoutError [

	| exampleModel diagramSimulator |
	exampleModel := OPBPMNExamples exampleAllElementsAndTypes.
	diagramSimulator := self simulatorClass model: exampleModel.
	self denyEmpty: diagramSimulator elements
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testInitialClassMappingContainsAllSupportedBPMNModels [

	| mapping |
	mapping := OPBPMNSimulator initialClassMapping.
	self assert: (mapping at: OPBPMNDataFlowModel) identicalTo: OPBPMNDataFlowSimulator.
	self assert: (mapping at: OPBPMNFlowModel) identicalTo: OPBPMNSequenceFlowSimulator.
	self assert: (mapping at: OPBPMNMessageFlowModel) identicalTo: OPBPMNMessageFlowSimulator.
	self assert: (mapping at: OPBPMNBoundaryEventModel) identicalTo: OPBPMNBoundaryEventSimulator.
	self assert: (mapping at: OPBPMNDataObjectModel) identicalTo: OPBPMNDataObjectSimulator.
	self assert: (mapping at: OPBPMNActivityModel) identicalTo: OPBPMNActivitySimulator.
	self assert: (mapping at: OPBPMNCollapsedSubProcessModel) identicalTo: OPBPMNCollapsedSubProcessSimulator.
	self assert: (mapping at: OPBPMNEndEventModel) identicalTo: OPBPMNEndEventSimulator.
	self assert: (mapping at: OPBPMNIntermediateEventModel) identicalTo: OPBPMNIntermediateEventSimulator.
	self assert: (mapping at: OPBPMNStartEventModel) identicalTo: OPBPMNStartEventSimulator.
	self assert: (mapping at: OPBPMNGatewayModel) identicalTo: OPBPMNGatewaySimulator.
	self assert: (mapping at: OPBPMNSubProcessModel) identicalTo: OPBPMNSubProcessSimulator.
	self assert: (mapping at: OPBPMNPoolModel) identicalTo: OPBPMNPoolSimulator
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testOrderFulfillmentExampleStartEventIsSteppable [

	| exampleModel sim startEvent startSim |
	exampleModel := OPBPMNExamples exampleOrderFulfillment.
	startEvent := exampleModel allElements detect: [ :each |
		              (each isKindOf: OPBPMNStartEventModel) and: [ each name = 'Order Placed' ] ].

	sim := self simulatorClass model: exampleModel.
	sim setDefaultStepping.

	startSim := sim simulatorOf: startEvent.
	self assert: startSim bpmnTokens equals: 1.
	self assert: startSim isSteppable description: 'Order Placed start event must be steppable with initial token'.

	sim step.
	self assert: startSim bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testResetRestoresInitialTokensBlockedStatesAndPreservesGatewayConfiguration [

	| testModel startEvent activity exclusiveGateway inclusiveGateway parallelGateway subProcess innerStart innerEnd catchingEvent dataObject task1 task2 flowStartToActivity flowActivityToExclusive flowExclusiveA flowExclusiveB flowInclusiveInA flowInclusiveInB flowInclusiveOutA flowInclusiveOutB flowParallelInA flowParallelInB flowInner dataFlow diagramSimulator startSimulator innerStartSimulator activitySimulator exclusiveSimulator inclusiveSimulator parallelSimulator catchingSimulator dataFlowSimulator flowStartSimulator branchBSimulator incASimulator incBSimulator |
	testModel := OPBPMNModel new name: 'Reset Model'.
	startEvent := OPBPMNStartEventModel new
		              name: 'Start';
		              type: OPBPMNNodeType Receive;
		              yourself.
	activity := OPBPMNActivityModel new name: 'Activity'.
	exclusiveGateway := OPBPMNGatewayModel new
		                    name: 'Exclusive';
		                    type: OPBPMNNodeType Exclusive;
		                    yourself.
	inclusiveGateway := OPBPMNGatewayModel new
		                    name: 'Inclusive';
		                    type: OPBPMNNodeType Inclusive;
		                    yourself.
	parallelGateway := OPBPMNGatewayModel new
		                   name: 'Parallel';
		                   type: OPBPMNNodeType Parallel;
		                   yourself.
	subProcess := OPBPMNSubProcessModel new name: 'SubProcess'.
	innerStart := OPBPMNStartEventModel new
		              name: 'InnerStart';
		              type: OPBPMNNodeType None;
		              yourself.
	innerEnd := OPBPMNEndEventModel new
		            name: 'InnerEnd';
		            type: OPBPMNNodeType None;
		            yourself.
	catchingEvent := OPBPMNIntermediateEventModel new
		                 name: 'WaitMessage';
		                 type: OPBPMNNodeType Receive;
		                 yourself.
	dataObject := OPBPMNDataObjectModel new
		              name: 'OrderData';
		              type: OPBPMNNodeType DataObject;
		              yourself.
	task1 := OPBPMNActivityModel new name: 'Task 1'.
	task2 := OPBPMNActivityModel new name: 'Task 2'.

	flowInner := OPBPMNFlowModel from: innerStart to: innerEnd.
	innerStart addFlow: flowInner.
	innerEnd addFlow: flowInner.
	subProcess
		add: innerStart;
		add: innerEnd;
		add: flowInner.

	flowStartToActivity := OPBPMNFlowModel from: startEvent to: activity.
	flowActivityToExclusive := OPBPMNFlowModel from: activity to: exclusiveGateway.
	flowExclusiveA := (OPBPMNFlowModel from: exclusiveGateway to: task1)
		                  name: 'Branch A';
		                  type: #Default;
		                  yourself.
	flowExclusiveB := (OPBPMNFlowModel from: exclusiveGateway to: task2)
		                  name: 'Branch B';
		                  yourself.
	flowInclusiveInA := OPBPMNFlowModel from: task1 to: inclusiveGateway.
	flowInclusiveInB := OPBPMNFlowModel from: task2 to: inclusiveGateway.
	flowInclusiveOutA := (OPBPMNFlowModel from: inclusiveGateway to: parallelGateway)
		                     name: 'Inc A';
		                     yourself.
	flowInclusiveOutB := (OPBPMNFlowModel from: inclusiveGateway to: catchingEvent)
		                     name: 'Inc B';
		                     yourself.
	flowParallelInA := OPBPMNFlowModel from: task1 to: parallelGateway.
	flowParallelInB := OPBPMNFlowModel from: task2 to: parallelGateway.
	dataFlow := OPBPMNDataFlowModel from: dataObject to: activity.

	{
		flowStartToActivity.
		flowActivityToExclusive.
		flowExclusiveA.
		flowExclusiveB.
		flowInclusiveInA.
		flowInclusiveInB.
		flowInclusiveOutA.
		flowInclusiveOutB.
		flowParallelInA.
		flowParallelInB.
		dataFlow } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow.
			testModel add: eachFlow ].
	{
		startEvent.
		activity.
		exclusiveGateway.
		inclusiveGateway.
		parallelGateway.
		subProcess.
		catchingEvent.
		dataObject.
		task1.
		task2 } do: [ :eachElement | testModel add: eachElement ].

	diagramSimulator := self simulatorClass model: testModel.
	startSimulator := diagramSimulator simulatorOf: startEvent.
	innerStartSimulator := diagramSimulator simulatorOf: innerStart.
	activitySimulator := diagramSimulator simulatorOf: activity.
	exclusiveSimulator := diagramSimulator simulatorOf: exclusiveGateway.
	inclusiveSimulator := diagramSimulator simulatorOf: inclusiveGateway.
	parallelSimulator := diagramSimulator simulatorOf: parallelGateway.
	catchingSimulator := diagramSimulator simulatorOf: catchingEvent.
	dataFlowSimulator := diagramSimulator simulatorOf: dataFlow.
	flowStartSimulator := diagramSimulator simulatorOf: flowStartToActivity.
	branchBSimulator := diagramSimulator simulatorOf: flowExclusiveB.
	incASimulator := diagramSimulator simulatorOf: flowInclusiveOutA.
	incBSimulator := diagramSimulator simulatorOf: flowInclusiveOutB.

	exclusiveSimulator outgoingActive: (OrderedCollection with: branchBSimulator).
	inclusiveSimulator outgoingActive: (OrderedCollection with: incASimulator with: incBSimulator).

	startSimulator bpmnTokens: 0.
	innerStartSimulator bpmnTokens: 2.
	activitySimulator
		bpmnTokens: 3;
		blocked: true.
	catchingSimulator
		bpmnTokens: 1;
		blocked: false.
	flowStartSimulator bpmnTokens: 2.
	dataFlowSimulator bpmnTokens: 4.
	inclusiveSimulator addBpmnTokens: 2 from: (diagramSimulator simulatorOf: flowInclusiveInA).
	parallelSimulator addBpmnTokens: 3 from: (diagramSimulator simulatorOf: flowParallelInA).

	diagramSimulator reset.

	self assert: startSimulator bpmnTokens equals: 1.
	self deny: startSimulator blocked description: 'Top-level start event must be unblocked after reset'.
	self assert: innerStartSimulator bpmnTokens equals: 0.
	self assert: activitySimulator bpmnTokens equals: 0.
	self deny: activitySimulator blocked description: 'Regular activity must be unblocked after reset'.
	self assert: catchingSimulator bpmnTokens equals: 0.
	self assert: catchingSimulator blocked description: 'Catching intermediate event must restore initial blocked state on reset'.
	self assert: flowStartSimulator bpmnTokens equals: 0.
	self assert: dataFlowSimulator bpmnTokens equals: 0.
	self assert: inclusiveSimulator bpmnTokens equals: 0.
	self assert: parallelSimulator bpmnTokens equals: 0.
	self
		assert: (inclusiveSimulator incomingBpmnTokens values allSatisfy: [ :eachCount | eachCount = 0 ])
		description: 'Inclusive gateway incoming merge counters must reset to zero'.
	self
		assert: (parallelSimulator incomingBpmnTokens values allSatisfy: [ :eachCount | eachCount = 0 ])
		description: 'Parallel gateway incoming merge counters must reset to zero'.
	self assert: exclusiveSimulator outgoingActive asArray equals: { branchBSimulator }.
	self assert: inclusiveSimulator outgoingActive asArray equals: {
			incASimulator.
			incBSimulator }
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testSimulationWithAssociation [

	| testModel activity end association diagramSimulator |
	testModel := self exampleModel.
	activity := testModel elements detect: [ :each | each name = 'A1' ].
	end := testModel elements detect: [ :each | each name = 'E1' ].
	association := OPBPMNAssociationModel new.
	association
		source: activity;
		target: end.
	testModel add: association.

	diagramSimulator := self simulatorClass model: testModel.
	self assert: diagramSimulator elements size equals: 5.
	self
		deny: (diagramSimulator elements anySatisfy: [ :each | each model == association ])
		description: 'Non-simulable associations must be excluded from diagram simulator elements'
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testStartEventInLaneReceivesInitialTokenAndIsSteppable [

	| testModel pool lane start task flow sim startSim |
	testModel := OPBPMNModel new name: 'Process Model'.
	pool := OPBPMNPoolModel new name: 'Pool'.
	lane := OPBPMNLaneModel new name: 'Lane'.
	pool addLane: lane.
	testModel add: pool.

	start := OPBPMNStartEventModel new
		         name: 'Start';
		         type: OPBPMNNodeType Receive;
		         yourself.
	task := OPBPMNActivityModel new name: 'Task'.
	flow := (OPBPMNFlowModel from: start to: task)
		        name: 'Flow';
		        yourself.
	start addFlow: flow.
	task addFlow: flow.

	lane
		add: start;
		add: task.
	testModel add: flow.

	sim := self simulatorClass model: testModel.
	sim setDefaultStepping.

	startSim := sim simulatorOf: start.
	self assert: startSim bpmnTokens equals: 1.
	self assert: startSim isSteppable description: 'Start event inside a lane must be steppable with initial token'.

	sim step.
	self assert: startSim bpmnTokens equals: 0.
	self assert: (sim simulatorOf: task) bpmnTokens equals: 1
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testStepRecordsSequenceAndMessageFlowTransfersExcludingUntakenBranches [

	| testModel startNode gateway taskA taskB receiverTask flowToGateway flowBranchA flowBranchB messageFlow diagramSimulator steppedEvents gatewaySimulator |
	testModel := OPBPMNModel new name: 'Transfer BPMN'.
	startNode := OPBPMNStartEventModel new name: 'Start'.
	gateway := OPBPMNGatewayModel new
		           name: 'Decision';
		           type: OPBPMNNodeType Exclusive;
		           yourself.
	taskA := OPBPMNActivityModel new name: 'Task A'.
	taskB := OPBPMNActivityModel new name: 'Task B'.
	receiverTask := OPBPMNActivityModel new name: 'Receiver'.
	flowToGateway := OPBPMNFlowModel from: startNode to: gateway.
	flowBranchA := (OPBPMNFlowModel from: gateway to: taskA)
		               type: #Default;
		               yourself.
	flowBranchB := OPBPMNFlowModel from: gateway to: taskB.
	messageFlow := OPBPMNMessageFlowModel from: taskA to: receiverTask.
	{
		startNode.
		gateway.
		taskA.
		taskB.
		receiverTask.
		flowToGateway.
		flowBranchA.
		flowBranchB.
		messageFlow } do: [ :each | testModel add: each ].
	{
		flowToGateway.
		flowBranchA.
		flowBranchB.
		messageFlow } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow ].

	diagramSimulator := OPBPMNSimulator model: testModel.
	gatewaySimulator := diagramSimulator simulatorOf: gateway.
	gatewaySimulator outgoingActive: (OrderedCollection with: (diagramSimulator simulatorOf: flowBranchA)).
	steppedEvents := OrderedCollection new.
	diagramSimulator when: OPSimulatorStepped do: [ :event | steppedEvents add: event ] for: self.

	diagramSimulator step.
	self
		assert: steppedEvents first transfers
		equals: { (OPSimulationTransfer source: startNode edge: flowToGateway target: gateway) }.

	diagramSimulator step.
	self assert: steppedEvents second transfers equals: { (OPSimulationTransfer source: gateway edge: flowBranchA target: taskA) }.

	diagramSimulator step.
	self assert: (diagramSimulator simulatorOf: messageFlow) bpmnTokens equals: 1.

	diagramSimulator step.
	self
		assert: steppedEvents fourth transfers
		equals: { ((OPSimulationTransfer source: taskA edge: messageFlow target: receiverTask)
				 kind: #message;
				 yourself) }
]
