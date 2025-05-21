Class {
	#name : 'OPBPMNSimulationGUI',
	#superclass : 'OPSimulationGUI',
	#instVars : [
		'configMenu'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'toolbar' }
OPBPMNSimulationGUI class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPBPMNPlugin>
	self toolbarMenuItemFor: aBuilder
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> buttonItems [

	^ OrderedCollection
		  with: (self newButton
				   label: 'Pause';
				   iconName: #testYellow;
				   help: 'Pause stepping';
				   action: [ self diagramSimulator stop ])
		  with: (self newButton
				   label: 'Play';
				   iconName: #smallPrintItIcon;
				   help: 'Step every second';
				   action: [ self diagramSimulator repeat ])
		  with: (self newButton
				   label: 'Step';
				   iconName: #forwardIcon;
				   help: 'Step once';
				   action: [ self diagramSimulator step ])
		  with: (self newButton
				   label: 'Configure';
				   help: 'Open configuration menu';
				   action: [ self openConfiguration ])
]

{ #category : 'accessing' }
OPBPMNSimulationGUI >> configMenu [

	^ configMenu
]

{ #category : 'accessing' }
OPBPMNSimulationGUI >> configMenu: aPresenter [

	configMenu := aPresenter
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> loadSimulation [
	"prepares simulation - called with every reload"

	super loadSimulation.
	diagramSimulator
		when: OPSimulatorStepped
		do: [ self updateColors ]
		for: self.
	self updateColors
]

{ #category : 'instance creation' }
OPBPMNSimulationGUI >> openConfiguration [

	self configMenu ifNil: [
		self configMenu: (OPBPMNSimConfigurationGUI new
				 diagramSimulator: self diagramSimulator;
				 yourself) ].

	self configMenu open
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> simulatorClass [
	"diagram simulator class"

	^ OPBPMNSimulator 
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> updateColors [

	| controller |
	diagramSimulator elementsDo: [ :element |
		controller := self diagramController controllerForModel:
			              element model.
		element bpmnTokens > 0
			ifFalse: [ controller diagramElement borderColor: Color black ]
			ifTrue: [
				element bpmnTokens > 1
					ifTrue: [
					controller diagramElement borderColor: Color orange darker ]
					ifFalse: [
					controller diagramElement borderColor: Color green darker ] ].
		controller diagramElement updateRenderFromSelf ]
]
