"
Simulation GUI presenter for BPMN diagrams. Extends the base simulation GUI with specific configuration menus and BPMN-specific color highlighting for active tokens.
"
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

{ #category : 'private - updating' }
OPBPMNSimulationGUI >> closeConfigMenu [

	configMenu ifNil: [ ^ self ].
	(configMenu hasWindow and: [ configMenu window isOpen ]) ifTrue: [ configMenu window close ].
	configMenu := nil
]

{ #category : 'private - updating' }
OPBPMNSimulationGUI >> closed [

	self closeConfigMenu.
	super closed
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

	self closeConfigMenu.
	super loadSimulation.
	diagramSimulator when: OPSimulatorStepped do: [ self updateColors ] for: self.
	self updateColors
]

{ #category : 'instance creation' }
OPBPMNSimulationGUI >> openConfiguration [

	self configMenu ifNil: [ self configMenu: (OPBPMNSimConfigurationGUI on: self diagramSimulator) ].
	self configMenu open
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> simulatorClass [
	"diagram simulator class"

	^ OPBPMNSimulator 
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> updateColors [

	diagramSimulator elementsDo: [ :element |
			(self diagramController controllerForModel: element model ifNone: [ nil ]) ifNotNil: [ :controller |
					| diagramElement strokeColor |
					diagramElement := controller diagramElement.
					(diagramElement exists and: [ diagramElement isRendered ]) ifTrue: [
							strokeColor := element bpmnTokens > 0
								               ifFalse: [ Color black ]
								               ifTrue: [
										               element bpmnTokens > 1
											               ifTrue: [ Color orange darker ]
											               ifFalse: [ Color green darker ] ].
							diagramElement
								strokeColor: strokeColor;
								updateRenderFromSelf ] ] ]
]
