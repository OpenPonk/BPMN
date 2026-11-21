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
OPBPMNSimulationGUITest >> testButtonItemsAndConfigurationLifecycle [

	| buttonItems buttonsByLabel configMenuFirst |
	rootModel elements do: [ :each | diagramController showInDiagramModel: each ].
	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.
	self assert: simulationGui simulatorClass identicalTo: OPBPMNSimulator.

	buttonItems := simulationGui buttonItems.
	self assert: (buttonItems collect: #label as: Array) equals: #( 'Pause' 'Play' 'Step' 'Configure' ).

	buttonsByLabel := (buttonItems collect: [ :eachButton | eachButton label -> eachButton ]) asDictionary.

	(buttonsByLabel at: 'Step') performAction.
	self assert: (simulationGui diagramSimulator simulatorOf: startEvent) bpmnTokens equals: 0.
	self assert: (simulationGui diagramSimulator simulatorOf: activity) bpmnTokens equals: 1.
	self assert: (diagramController controllerForModel: activity) diagramElement borderColor equals: Color green darker.

	(buttonsByLabel at: 'Pause') performAction.
	self
		deny: (simulationGui diagramSimulator instVarNamed: #shouldRun)
		description: 'Pause button must stop simulation running flag'.

	(buttonsByLabel at: 'Configure') performAction.
	configMenuFirst := simulationGui configMenu.
	self assert: configMenuFirst class identicalTo: OPBPMNSimConfigurationGUI.
	self assert: configMenuFirst diagramSimulator identicalTo: simulationGui diagramSimulator.
	self assert: configMenuFirst window isOpen description: 'Configure button must open configuration window'.

	simulationGui loadSimulation.
	self assert: simulationGui configMenu identicalTo: nil.
	self deny: configMenuFirst window isOpen description: 'Reloading simulation must close stale configuration window'.

	simulationGui openConfiguration.
	self assert: simulationGui configMenu window isOpen description: 'openConfiguration must create a fresh configuration window'.
	simulationGui close.
	self assert: simulationGui configMenu identicalTo: nil
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
OPBPMNSimulationGUITest >> testUpdateColorsIgnoresHiddenAndUnrenderedElements [

	| startController |
	startController := diagramController showInDiagramModel: startEvent.
	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.

	self assert: startController diagramElement borderColor equals: Color green darker.

	startController removeRender.
	(simulationGui diagramSimulator simulatorOf: startEvent) bpmnTokens: 2.
	simulationGui updateColors.
	self assert: startController diagramElement borderColor equals: Color green darker
]

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testUpdateColorsUpdatesPoolAndNodeColorsByTokenCount [

	| poolController startController activityController |
	rootModel elements do: [ :each | diagramController showInDiagramModel: each ].
	poolController := diagramController controllerForModel: poolModel.
	startController := diagramController controllerForModel: startEvent.
	activityController := diagramController controllerForModel: activity.

	simulationGui := OPBPMNSimulationGUI diagramController: diagramController.

	self assert: poolController diagramElement roassalShape borderColor equals: Color black.
	self assert: startController diagramElement borderColor equals: Color green darker.
	self assert: activityController diagramElement borderColor equals: Color black.

	(simulationGui diagramSimulator simulatorOf: activity) bpmnTokens: 2.
	simulationGui updateColors.
	self assert: activityController diagramElement borderColor equals: Color orange darker
]
