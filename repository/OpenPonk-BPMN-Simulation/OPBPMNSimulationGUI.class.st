"
Simulation GUI presenter for BPMN diagrams. Uses OPSimulationGUI controls, embedded configuration sidebar for branching gateways, and OPSimulationHighlighter stroke overlays to display active BPMN token counts without mutating persistent diagram element styles.
"
Class {
	#name : 'OPBPMNSimulationGUI',
	#superclass : 'OPSimulationGUI',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'configuration' }
OPBPMNSimulationGUI >> buildConfigurationPresenter [

	^ OPBPMNSimConfigurationGUI on: self diagramSimulator
]

{ #category : 'testing' }
OPBPMNSimulationGUI >> hasConfiguration [

	^ true
]

{ #category : 'private - updating' }
OPBPMNSimulationGUI >> highlightColorForTokens: anInteger [

	^ anInteger > 1
		  ifTrue: [ Color orange darker ]
		  ifFalse: [ Color green darker ]
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> simulatorClass [
	"diagram simulator class"

	^ OPBPMNSimulator 
]

{ #category : 'private - hooks' }
OPBPMNSimulationGUI >> updateSimulationVisuals [

	diagramSimulator ifNil: [ ^ self ].
	self highlighter replaceHighlightsDuring: [
			diagramSimulator elementsDo: [ :eachElement |
					eachElement bpmnTokens > 0 ifTrue: [
						self highlighter
							highlightStrokeOfModel: eachElement model
							color: (self highlightColorForTokens: eachElement bpmnTokens)
							width: 3 ] ] ]
]
