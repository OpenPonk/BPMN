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

	| model start exclusiveGateway inclusiveGateway parallelGateway mergeGateway emptyGateway task1 task2 task3 task4 task5 task6 task7 flow1 flow2 flow3 flow4 flow5 flow6 flow7 flow8 flow9 |
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
	mergeGateway := OPBPMNGatewayModel new
		                name: 'MergeXOR';
		                type: OPBPMNNodeType Exclusive;
		                yourself.
	emptyGateway := OPBPMNGatewayModel new
		                name: 'EmptyXOR';
		                type: OPBPMNNodeType ExclusiveEmpty;
		                yourself.
	task1 := OPBPMNActivityModel new name: 'T1'.
	task2 := OPBPMNActivityModel new name: 'T2'.
	task3 := OPBPMNActivityModel new name: 'T3'.
	task4 := OPBPMNActivityModel new name: 'T4'.
	task5 := OPBPMNActivityModel new name: 'T5'.
	task6 := OPBPMNActivityModel new name: 'T6'.
	task7 := OPBPMNActivityModel new name: 'T7'.
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
	flow6 := (OPBPMNFlowModel from: parallelGateway to: task5)
		         name: 'ParA';
		         yourself.
	flow7 := (OPBPMNFlowModel from: parallelGateway to: task6)
		         name: 'ParB';
		         yourself.
	flow8 := (OPBPMNFlowModel from: start to: mergeGateway)
		         name: 'ToMerge';
		         yourself.
	flow9 := (OPBPMNFlowModel from: mergeGateway to: task7)
		         name: 'FromMerge';
		         yourself.
	{
		flow1.
		flow2.
		flow3.
		flow4.
		flow5.
		flow6.
		flow7.
		flow8.
		flow9 } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow.
			model add: eachFlow ].
	{
		start.
		exclusiveGateway.
		inclusiveGateway.
		parallelGateway.
		mergeGateway.
		emptyGateway.
		task1.
		task2.
		task3.
		task4.
		task5.
		task6.
		task7 } do: [ :eachElement | model add: eachElement ].
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
OPBPMNSimConfigurationGUITest >> testEventBasedAndComplexGatewayLabelsAndExclusiveRefresh [

	| model eventBasedGateway complexGateway unnamedActivity unnamedIntermediate unnamedGateway flow1 flow2 flow3 flow4 diagramSimulator entries eventEntry complexEntry secondEventFlow |
	model := OPBPMNModel new name: 'EventBased And Complex'.
	eventBasedGateway := OPBPMNGatewayModel new
		                     name: 'Wait Choice';
		                     type: OPBPMNNodeType Eventbased;
		                     yourself.
	complexGateway := OPBPMNGatewayModel new
		                  name: '';
		                  type: OPBPMNNodeType Complex;
		                  yourself.
	unnamedActivity := OPBPMNActivityModel new name: ''.
	unnamedIntermediate := OPBPMNIntermediateEventModel new name: ''.
	unnamedGateway := OPBPMNGatewayModel new
		                  name: '';
		                  type: OPBPMNNodeType Parallel;
		                  yourself.
	flow1 := OPBPMNFlowModel from: eventBasedGateway to: unnamedActivity.
	flow2 := OPBPMNFlowModel from: eventBasedGateway to: unnamedIntermediate.
	flow3 := OPBPMNFlowModel from: complexGateway to: unnamedGateway.
	flow4 := (OPBPMNFlowModel from: complexGateway to: unnamedActivity)
		         name: 'Fallback';
		         yourself.
	{
		flow1.
		flow2.
		flow3.
		flow4 } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow.
			model add: eachFlow ].
	{
		eventBasedGateway.
		complexGateway.
		unnamedActivity.
		unnamedIntermediate.
		unnamedGateway } do: [ :eachElement | model add: eachElement ].

	diagramSimulator := OPBPMNSimulator model: model.
	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	entries := configGui gatewayEntries.
	self assert: entries size equals: 2.

	eventEntry := entries first.
	complexEntry := entries second.
	self assert: (eventEntry at: #headerLabel) label equals: 'Wait Choice (Event-based)'.
	self assert: (complexEntry at: #headerLabel) label equals: 'Complex gateway'.
	self
		assert: ((eventEntry at: #branches) collect: [ :eachPair | eachPair value label ] as: Array)
		equals: #( '→ Activity' '→ Intermediate event' ).
	self
		assert: ((complexEntry at: #branches) collect: [ :eachPair | eachPair value label ] as: Array)
		equals: #( '→ Parallel gateway' 'Fallback' ).

	secondEventFlow := (eventEntry at: #branches) second key.
	(eventEntry at: #gateway) outgoingActive: (OrderedCollection with: secondEventFlow).
	configGui refreshFromSimulator.
	self
		assert: (eventEntry at: #branches) second value state
		description: 'Refresh must select matching exclusive branch radio button'.
	self
		deny: (eventEntry at: #branches) first value state
		description: 'Refresh must deselect previous exclusive branch radio button'
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testExclusiveAndInclusiveGatewayControlsLabelsAndDeterministicOrder [

	| model exclusiveGateway mergeGateway inclusiveGateway procureSubProcess prepareSubProcess endEvent flowOutOfStock flowInStock flowUnnamedToNamed flowUnnamedToUnnamed diagramSimulator entries exclusiveEntry inclusiveEntry exclusiveButtons inclusiveButtons outOfStockButton inStockButton firstInclusiveButton secondInclusiveButton warningLabel |
	model := OPBPMNModel new name: 'Labels And Order'.
	exclusiveGateway := OPBPMNGatewayModel new
		                    name: 'In Stock?';
		                    type: OPBPMNNodeType Exclusive;
		                    yourself.
	mergeGateway := OPBPMNGatewayModel new
		                name: '';
		                type: OPBPMNNodeType Exclusive;
		                yourself.
	inclusiveGateway := OPBPMNGatewayModel new
		                    name: '';
		                    type: OPBPMNNodeType Inclusive;
		                    yourself.
	procureSubProcess := OPBPMNSubProcessModel new name: 'Procure Items'.
	prepareSubProcess := OPBPMNCollapsedSubProcessModel new name: 'Prepare Shipment'.
	endEvent := OPBPMNEndEventModel new name: ''.

	flowOutOfStock := (OPBPMNFlowModel from: exclusiveGateway to: procureSubProcess)
		                  name: 'Out of Stock';
		                  yourself.
	flowInStock := (OPBPMNFlowModel from: exclusiveGateway to: mergeGateway)
		               name: 'In Stock';
		               type: #Default;
		               yourself.
	flowUnnamedToNamed := (OPBPMNFlowModel from: inclusiveGateway to: prepareSubProcess)
		                      name: '';
		                      yourself.
	flowUnnamedToUnnamed := (OPBPMNFlowModel from: inclusiveGateway to: endEvent)
		                        name: '';
		                        yourself.
	{
		flowOutOfStock.
		flowInStock.
		flowUnnamedToNamed.
		flowUnnamedToUnnamed } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow.
			model add: eachFlow ].
	{
		exclusiveGateway.
		mergeGateway.
		inclusiveGateway.
		procureSubProcess.
		prepareSubProcess.
		endEvent } do: [ :eachElement | model add: eachElement ].

	diagramSimulator := OPBPMNSimulator model: model.
	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	self assert: configGui defaultLayout class identicalTo: SpBoxLayout.

	entries := configGui gatewayEntries.
	self assert: entries size equals: 2.
	exclusiveEntry := entries first.
	inclusiveEntry := entries second.

	self assert: (exclusiveEntry at: #headerLabel) label equals: 'In Stock? (Exclusive)'.
	self assert: (inclusiveEntry at: #headerLabel) label equals: 'Inclusive gateway'.

	exclusiveButtons := (exclusiveEntry at: #branches) collect: #value.
	self assert: (exclusiveButtons collect: #label as: Array) equals: #( 'Out of Stock (→ Procure Items)'
	   'In Stock' ).
	outOfStockButton := exclusiveButtons first.
	inStockButton := exclusiveButtons second.
	self assert: outOfStockButton associatedRadioButtons asArray equals: { inStockButton }.
	self assert: inStockButton associatedRadioButtons asArray equals: { outOfStockButton }.
	self assert: inStockButton state description: 'Default outgoing branch radio button must start selected'.

	outOfStockButton state: true.
	self assert: (exclusiveEntry at: #gateway) outgoingActive asArray equals: { (diagramSimulator simulatorOf: flowOutOfStock) }.

	inclusiveButtons := (inclusiveEntry at: #branches) collect: #value.
	self assert: (inclusiveButtons collect: #label as: Array) equals: #( '→ Prepare Shipment' '→ End event' ).
	firstInclusiveButton := inclusiveButtons first.
	secondInclusiveButton := inclusiveButtons second.
	warningLabel := inclusiveEntry at: #warningLabel.
	self assert: firstInclusiveButton state description: 'Initially active inclusive branch must start checked'.
	self deny: secondInclusiveButton state description: 'Initially inactive inclusive branch must start unchecked'.
	self assertEmpty: warningLabel label.

	firstInclusiveButton state: false.
	self assertEmpty: (inclusiveEntry at: #gateway) outgoingActive.
	self
		deny: (inclusiveEntry at: #gateway) canSendBpmnTokens
		description: 'Inclusive gateway with no checked branches cannot send tokens'.
	self denyEmpty: warningLabel label.

	secondInclusiveButton state: true.
	self
		assert: (inclusiveEntry at: #gateway) outgoingActive asArray
		equals: { (diagramSimulator simulatorOf: flowUnnamedToUnnamed) }.
	self assertEmpty: warningLabel label
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testExclusiveGatewayWithStaleOutgoingActiveLeavesRadioGroupUnset [

	| diagramSimulator exclusiveSimulator staleFlow exclusiveEntry exclusiveButtons firstButton secondButton |
	diagramSimulator := OPBPMNSimulator model: self buildGatewayModel.
	exclusiveSimulator := diagramSimulator configurableGateways detect: [ :each | each model name = 'XOR' ].
	staleFlow := OPBPMNFlowSimulator new.
	exclusiveSimulator outgoingActive: (OrderedCollection with: staleFlow).

	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	exclusiveEntry := configGui gatewayEntries detect: [ :eachEntry | (eachEntry at: #gateway) == exclusiveSimulator ].
	exclusiveButtons := (exclusiveEntry at: #branches) collect: #value.
	firstButton := exclusiveButtons first.
	secondButton := exclusiveButtons second.

	self assert: firstButton associatedRadioButtons asArray equals: { secondButton }.
	self assert: secondButton associatedRadioButtons asArray equals: { firstButton }.
	self
		deny: firstButton isInitialStateSet
		description: 'Stale outgoingActive flow must leave exclusive radio group without an initial selection'.

	secondButton state: true.
	self assert: exclusiveSimulator outgoingActive asArray equals: { (exclusiveEntry at: #branches) second key }
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testExclusiveRadioButtonsAreGroupedEvenWhenOutgoingActiveIsEmpty [

	| diagramSimulator exclusiveSimulator exclusiveEntry exclusiveButtons firstButton secondButton |
	diagramSimulator := OPBPMNSimulator model: self buildGatewayModel.
	exclusiveSimulator := diagramSimulator configurableGateways detect: [ :each | each model name = 'XOR' ].
	exclusiveSimulator outgoingActive removeAll.

	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	exclusiveEntry := configGui gatewayEntries detect: [ :eachEntry | (eachEntry at: #gateway) == exclusiveSimulator ].
	exclusiveButtons := (exclusiveEntry at: #branches) collect: #value.
	firstButton := exclusiveButtons first.
	secondButton := exclusiveButtons second.

	self assert: firstButton associatedRadioButtons asArray equals: { secondButton }.
	self assert: secondButton associatedRadioButtons asArray equals: { firstButton }.
	self deny: firstButton isInitialStateSet description: 'Empty outgoingActive radio group must not mark initial state set'.

	secondButton state: true.
	self assert: exclusiveSimulator outgoingActive asArray equals: { (exclusiveEntry at: #branches) second key }.
	firstButton state: true.
	self assert: exclusiveSimulator outgoingActive asArray equals: { (exclusiveEntry at: #branches) first key }.
	self deny: secondButton state description: 'Activating first radio button must deactivate sibling radio button'
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testIsSimulationConfigurationSubclassWithEmptyStateWhenNoBranchingGateways [

	| diagramSimulator |
	diagramSimulator := OPBPMNSimulator model: OPBPMNExamples exampleAllElementsAndTypes.
	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	self
		assert: (configGui isKindOf: OPSimulationConfigurationGUI)
		description: 'BPMN configuration GUI must subclass OPSimulationConfigurationGUI'.
	self deny: configGui hasConfigurableItems description: 'Diagram without branching gateways must report empty configuration'.
	self assert: configGui defaultLayout children first label equals: configGui emptyStateMessage
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testNewFollowedByDiagramSimulatorSetterInitializesPresenters [

	| diagramSimulator |
	diagramSimulator := OPBPMNSimulator model: self buildGatewayModel.
	configGui := OPBPMNSimConfigurationGUI new
		             diagramSimulator: diagramSimulator;
		             yourself.
	self assert: configGui diagramSimulator identicalTo: diagramSimulator.
	self assert: configGui hasConfigurableItems description: 'Branching gateways must make configuration non-empty'.
	self
		assert: (configGui gatewayEntries collect: [ :eachEntry | (eachEntry at: #gateway) model name ] as: Array)
		equals: #( 'OR' 'XOR' )
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testNilNamesUnnamedSubProcessAndNilSimulatorRefresh [

	| model gateway subProcess activity flowToSubProcess flowToActivity diagramSimulator entry branches |
	model := OPBPMNModel new name: 'Nil Names'.
	gateway := OPBPMNGatewayModel new
		           name: nil;
		           type: OPBPMNNodeType Exclusive;
		           yourself.
	subProcess := OPBPMNSubProcessModel new
		              name: nil;
		              yourself.
	activity := OPBPMNActivityModel new
		            name: nil;
		            yourself.
	flowToSubProcess := (OPBPMNFlowModel from: gateway to: subProcess)
		                    name: nil;
		                    yourself.
	flowToActivity := (OPBPMNFlowModel from: gateway to: activity)
		                  name: 'Direct';
		                  yourself.
	{
		flowToSubProcess.
		flowToActivity } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow.
			model add: eachFlow ].
	{
		gateway.
		subProcess.
		activity } do: [ :eachElement | model add: eachElement ].

	diagramSimulator := OPBPMNSimulator model: model.
	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	entry := configGui gatewayEntries first.
	branches := entry at: #branches.
	self assert: (entry at: #headerLabel) label equals: 'Exclusive gateway'.
	self assert: (branches collect: [ :eachPair | eachPair value label ] as: Array) equals: #( '→ Sub-process' 'Direct' ).

	configGui diagramSimulator: nil.
	self deny: configGui hasConfigurableItems description: 'Clearing simulator must clear configurable gateway entries'.
	self assertEmpty: configGui gatewayEntries
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testRefreshFromSimulatorSynchronizesControlsAfterExternalChangeAndReset [

	| diagramSimulator inclusiveSimulator inclusiveEntry firstButton secondButton warningLabel secondFlow |
	diagramSimulator := OPBPMNSimulator model: self buildGatewayModel.
	inclusiveSimulator := diagramSimulator configurableGateways detect: [ :each | each model name = 'OR' ].
	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	inclusiveEntry := configGui gatewayEntries detect: [ :eachEntry | (eachEntry at: #gateway) == inclusiveSimulator ].
	firstButton := (inclusiveEntry at: #branches) first value.
	secondButton := (inclusiveEntry at: #branches) second value.
	secondFlow := (inclusiveEntry at: #branches) second key.
	warningLabel := inclusiveEntry at: #warningLabel.

	inclusiveSimulator outgoingActive removeAll.
	configGui refreshFromSimulator.
	self deny: firstButton state description: 'Refresh must uncheck inactive branch checkbox'.
	self deny: secondButton state description: 'Refresh must keep inactive branch unchecked'.
	self denyEmpty: warningLabel label.

	inclusiveSimulator outgoingActive: (OrderedCollection with: secondFlow).
	diagramSimulator reset.
	configGui refreshFromSimulator.
	self deny: firstButton state description: 'Refresh after reset must keep first branch unchecked'.
	self assert: secondButton state description: 'Refresh after reset must preserve selected branch checked'.
	self assertEmpty: warningLabel label
]

{ #category : 'tests' }
OPBPMNSimConfigurationGUITest >> testTargetlessFlowFallsBackToBranchIndexAndDeactivatingAbsentInclusiveFlowIsSafe [

	| model gateway task1 task2 flow1 flow2 diagramSimulator targetlessFlowSimulator entry branchLabels inclusiveModel inclusiveSimulator inclusiveGateway inclusiveEntry firstCheckbox warningLabel |
	model := OPBPMNModel new name: 'Targetless Flow'.
	gateway := OPBPMNGatewayModel new
		           name: 'Choice';
		           type: OPBPMNNodeType Exclusive;
		           yourself.
	task1 := OPBPMNActivityModel new name: 'Done'.
	task2 := OPBPMNActivityModel new name: 'Other'.
	flow1 := (OPBPMNFlowModel from: gateway to: task1)
		         name: '';
		         yourself.
	flow2 := (OPBPMNFlowModel from: gateway to: task2)
		         name: '';
		         yourself.
	{
		flow1.
		flow2 } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow.
			model add: eachFlow ].
	{
		gateway.
		task1.
		task2 } do: [ :eachElement | model add: eachElement ].

	diagramSimulator := OPBPMNSimulator model: model.
	targetlessFlowSimulator := diagramSimulator simulatorOf: flow1.
	targetlessFlowSimulator outgoing removeAll.

	configGui := OPBPMNSimConfigurationGUI on: diagramSimulator.
	entry := configGui gatewayEntries first.
	branchLabels := (entry at: #branches) collect: [ :eachPair | eachPair value label ] as: Array.
	self assert: branchLabels equals: #( '→ Branch 1' '→ Other' ).

	inclusiveModel := self buildGatewayModel.
	inclusiveSimulator := OPBPMNSimulator model: inclusiveModel.
	configGui := OPBPMNSimConfigurationGUI on: inclusiveSimulator.
	inclusiveGateway := inclusiveSimulator configurableGateways detect: [ :each | each model name = 'OR' ].
	inclusiveEntry := configGui gatewayEntries detect: [ :eachEntry | (eachEntry at: #gateway) == inclusiveGateway ].
	firstCheckbox := (inclusiveEntry at: #branches) first value.
	warningLabel := inclusiveEntry at: #warningLabel.

	inclusiveGateway outgoingActive removeAll.
	firstCheckbox state: false.
	self assertEmpty: inclusiveGateway outgoingActive.
	self denyEmpty: warningLabel label
]
