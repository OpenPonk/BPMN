"
Headless UI tests for the BPMN simulation GUI presenter, token color updates, configuration dialog lifecycle, and simulation model command.
"
Class {
	#name : 'OPBPMNSimulationGUITest',
	#superclass : 'OPAbstractUITest',
	#instVars : [
		'openWindowsBefore',
		'rootModel',
		'poolModel',
		'startEvent',
		'activity',
		'editor',
		'diagramController',
		'simulationGui'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNSimulationGUITest >> setUp [

	| project diagram projectController plugin endEvent flow1 flow2 |
	super setUp.
	openWindowsBefore := (self currentWorld submorphs select: [ :eachMorph | eachMorph isSystemWindow ]) asIdentitySet.
	rootModel := OPBPMNModel new name: 'Process Model'.
	poolModel := OPBPMNPoolModel new name: 'Main Pool'.
	startEvent := OPBPMNStartEventModel new name: 'Start'.
	activity := OPBPMNActivityModel new name: 'Task'.
	endEvent := OPBPMNEndEventModel new name: 'End'.
	flow1 := OPBPMNFlowModel from: startEvent to: activity.
	flow2 := OPBPMNFlowModel from: activity to: endEvent.
	startEvent addFlow: flow1.
	activity
		addFlow: flow1;
		addFlow: flow2.
	endEvent addFlow: flow2.
	rootModel
		add: poolModel;
		add: startEvent;
		add: activity;
		add: endEvent;
		add: flow1;
		add: flow2.

	project := OPProject named: 'BPMN Simulation GUI Test'.
	project addModel: rootModel.
	diagram := OPOpenPonkDiagram forModelElement: rootModel.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	plugin := OPPluginRegistry default plugins detect: [ :eachPlugin | eachPlugin isKindOf: OPBPMNPlugin ].
	editor := OPEditor on: plugin.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		editor: editor;
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: diagram;
		model: rootModel
]

{ #category : 'running' }
OPBPMNSimulationGUITest >> tearDown [

	(simulationGui isNotNil and: [ simulationGui isOpen ]) ifTrue: [ simulationGui close ].
	self currentWorld submorphs
		select: [ :eachMorph | eachMorph isSystemWindow and: [ (openWindowsBefore includes: eachMorph) not ] ]
		thenDo: [ :eachWindow | eachWindow delete ].
	simulationGui := nil.
	diagramController := nil.
	editor := nil.
	activity := nil.
	startEvent := nil.
	poolModel := nil.
	rootModel := nil.
	openWindowsBefore := nil.
	super tearDown
]

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testActiveNodesUseThickerBorderAndRestoreOnResetAndClose [

	| startShape activityShape originalStartWidth originalActivityWidth |
	rootModel elements do: [ :each | diagramController showInDiagramModel: each ].
	startShape := (diagramController controllerForModel: startEvent) roassalShape.
	activityShape := (diagramController controllerForModel: activity) roassalShape.
	originalStartWidth := startShape border width.
	originalActivityWidth := activityShape border width.

	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.
	self assert: startShape borderColor equals: Color green darker.
	self assert: startShape border width equals: 3.
	self assert: activityShape border width equals: originalActivityWidth.

	simulationGui session step.
	self assert: startShape border width equals: originalStartWidth.
	self assert: activityShape borderColor equals: Color green darker.
	self assert: activityShape border width equals: 3.

	simulationGui session reset.
	self assert: startShape border width equals: 3.
	self assert: activityShape border width equals: originalActivityWidth.

	simulationGui close.
	self assert: startShape border width equals: originalStartWidth.
	self assert: activityShape border width equals: originalActivityWidth
]

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testButtonItemsAndConfigurationLifecycle [

	| buttonsByLabel windowsCountBefore initialConfiguration |
	rootModel elements do: [ :each | diagramController showInDiagramModel: each ].
	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.
	self assert: simulationGui simulatorClass identicalTo: OPBPMNSimulator.
	self assert: simulationGui hasConfiguration description: 'BPMN simulation GUI must advertise configuration sidebar'.
	self deny: simulationGui isConfigurationVisible description: 'Configuration sidebar must start collapsed'.
	self assert: (simulationGui buttons collect: #label as: Array) equals: #( 'Play' 'Step' 'Reset' 'Configure' ).
	self assert: simulationGui controlsPresenter showsDelayControl description: 'Step delay control must be shown'.

	buttonsByLabel := (simulationGui buttons collect: [ :eachButton | eachButton label -> eachButton ]) asDictionary.

	(buttonsByLabel at: 'Step') performAction.
	self assert: (simulationGui diagramSimulator simulatorOf: startEvent) bpmnTokens equals: 0.
	self assert: (simulationGui diagramSimulator simulatorOf: activity) bpmnTokens equals: 1.
	self assert: (diagramController controllerForModel: activity) roassalShape borderColor equals: Color green darker.
	self assert: (diagramController controllerForModel: activity) diagramElement borderColor equals: Color black.

	windowsCountBefore := self currentWorld submorphs count: [ :eachMorph | eachMorph isSystemWindow ].
	(buttonsByLabel at: 'Configure') performAction.
	self assert: simulationGui isConfigurationVisible description: 'Configure button must expand embedded sidebar'.
	self assert: (self currentWorld submorphs count: [ :eachMorph | eachMorph isSystemWindow ]) equals: windowsCountBefore.
	initialConfiguration := simulationGui configurationPresenter.
	self assert: initialConfiguration class identicalTo: OPBPMNSimConfigurationGUI.
	self assert: initialConfiguration diagramSimulator identicalTo: simulationGui diagramSimulator.

	(buttonsByLabel at: 'Reset') performAction.
	self assert: (simulationGui diagramSimulator simulatorOf: startEvent) bpmnTokens equals: 1.
	self assert: (simulationGui diagramSimulator simulatorOf: activity) bpmnTokens equals: 0.
	self assert: (diagramController controllerForModel: startEvent) roassalShape borderColor equals: Color green darker.
	self assert: (diagramController controllerForModel: activity) roassalShape borderColor equals: Color black.

	rootModel add: (OPBPMNActivityModel new name: 'Added Task').
	self assert: simulationGui isConfigurationVisible description: 'Open configuration sidebar must stay open across reload'.
	self deny: simulationGui configurationPresenter identicalTo: initialConfiguration.
	self assert: simulationGui configurationPresenter diagramSimulator identicalTo: simulationGui diagramSimulator.

	simulationGui close.
	self assert: (diagramController controllerForModel: startEvent) roassalShape borderColor equals: Color black.
	self assert: simulationGui configurationPresenter identicalTo: nil
]

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testConfigurationSidebarRendersBranchingGatewayAndResetPreservesSelection [

	| gateway branchTaskA branchTaskB flowToGateway flowBranchA flowBranchB buttonsByLabel entry gatewaySimulator branchButtons |
	gateway := OPBPMNGatewayModel new
		           name: 'Decision';
		           type: OPBPMNNodeType Exclusive;
		           yourself.
	branchTaskA := OPBPMNActivityModel new name: 'Option A'.
	branchTaskB := OPBPMNActivityModel new name: 'Option B'.
	flowToGateway := OPBPMNFlowModel from: activity to: gateway.
	flowBranchA := (OPBPMNFlowModel from: gateway to: branchTaskA)
		               name: 'Path A';
		               type: #Default;
		               yourself.
	flowBranchB := (OPBPMNFlowModel from: gateway to: branchTaskB)
		               name: 'Path B';
		               yourself.
	{
		flowToGateway.
		flowBranchA.
		flowBranchB } do: [ :eachFlow |
			eachFlow source addFlow: eachFlow.
			eachFlow target addFlow: eachFlow.
			rootModel add: eachFlow ].
	{
		gateway.
		branchTaskA.
		branchTaskB } do: [ :eachElement | rootModel add: eachElement ].
	rootModel elements do: [ :each | diagramController showInDiagramModel: each ].

	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.
	buttonsByLabel := (simulationGui buttons collect: [ :eachButton | eachButton label -> eachButton ]) asDictionary.
	(buttonsByLabel at: 'Configure') performAction.

	entry := simulationGui configurationPresenter gatewayEntries first.
	gatewaySimulator := entry at: #gateway.
	branchButtons := (entry at: #branches) collect: #value.
	self assert: (entry at: #headerLabel) label equals: 'Decision (Exclusive)'.
	self assert: (branchButtons collect: #label as: Array) equals: #( 'Path A (→ Option A)' 'Path B (→ Option B)' ).

	branchButtons second state: true.
	self assert: gatewaySimulator outgoingActive asArray equals: { (simulationGui diagramSimulator simulatorOf: flowBranchB) }.

	(buttonsByLabel at: 'Step') performAction.
	(buttonsByLabel at: 'Reset') performAction.
	self assert: (simulationGui diagramSimulator simulatorOf: startEvent) bpmnTokens equals: 1.
	self assert: gatewaySimulator outgoingActive asArray equals: { (simulationGui diagramSimulator simulatorOf: flowBranchB) }.
	self assert: branchButtons second state description: 'Reset must keep user-selected branch active in sidebar'
]

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testSimulationCommandActivationAndExecution [

	| activation toolContext command |
	activation := OPBPMNSimulationCommand modelMenuActivation.
	self assert: activation class identicalTo: OPModelMenuActivation.

	editor instVarNamed: #diagramController put: diagramController.
	toolContext := CmdSimpleToolContext for: editor.
	command := OPBPMNSimulationCommand new.
	self assert: command defaultMenuItemName equals: 'Simulation'.
	self assert: command defaultMenuIconName equals: #glamorousSpawn.

	command
		readParametersFromContext: toolContext;
		prepareFullExecutionInContext: toolContext;
		execute.

	simulationGui := OPBPMNSimulationGUI allInstances
		                 detect: [ :eachGui | eachGui isOpen and: [ eachGui diagramController == diagramController ] ]
		                 ifNone: [ self fail: 'Executing OPBPMNSimulationCommand must open OPBPMNSimulationGUI' ].
	self assert: simulationGui diagramModel identicalTo: rootModel
]

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testUpdateSimulationVisualsHighlightsByTokenCountAndPreservesCustomStrokeColors [

	| poolController startController activityController flowController firstFlow |
	rootModel elements do: [ :each | diagramController showInDiagramModel: each ].
	firstFlow := startEvent outgoing first.
	poolController := diagramController controllerForModel: poolModel.
	startController := diagramController controllerForModel: startEvent.
	activityController := diagramController controllerForModel: activity.
	flowController := diagramController controllerForModel: firstFlow.

	activityController roassalShape borderColor: Color blue.
	flowController roassalShape color: Color purple.

	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.

	self assert: poolController roassalShape borderColor equals: Color black.
	self assert: startController roassalShape borderColor equals: Color green darker.
	self assert: activityController roassalShape borderColor equals: Color blue.
	self assert: flowController roassalShape color equals: Color purple.

	(simulationGui diagramSimulator simulatorOf: activity) bpmnTokens: 2.
	(simulationGui diagramSimulator simulatorOf: firstFlow) bpmnTokens: 1.
	simulationGui updateSimulationVisuals.
	self assert: activityController roassalShape borderColor equals: Color orange darker.
	self assert: activityController diagramElement borderColor equals: Color black.
	self assert: flowController roassalShape color equals: Color green darker.

	(simulationGui diagramSimulator simulatorOf: activity) bpmnTokens: 0.
	(simulationGui diagramSimulator simulatorOf: firstFlow) bpmnTokens: 0.
	simulationGui updateSimulationVisuals.
	self assert: activityController roassalShape borderColor equals: Color blue.
	self assert: flowController roassalShape color equals: Color purple.

	simulationGui close.
	self assert: startController roassalShape borderColor equals: Color black
]

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testUpdateSimulationVisualsIgnoresHiddenAndUnrenderedElements [

	| startController unattachedGui |
	unattachedGui := OPBPMNSimulationGUI new.
	unattachedGui updateSimulationVisuals.
	self assert: unattachedGui diagramSimulator identicalTo: nil.

	startController := diagramController showInDiagramModel: startEvent.
	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.

	self assert: startController roassalShape borderColor equals: Color green darker.
	self assert: startController diagramElement borderColor equals: Color black.

	startController removeRender.
	(simulationGui diagramSimulator simulatorOf: startEvent) bpmnTokens: 2.
	simulationGui updateSimulationVisuals.
	self assert: startController roassalShape identicalTo: nil.
	self assert: startController diagramElement borderColor equals: Color black
]
