"
Simulator component for expanded BPMN subprocesses. Manages the execution of internal elements, routing tokens to inner start events upon activation.
"
Class {
	#name : 'OPBPMNSubProcessSimulator',
	#superclass : 'OPBPMNFlowNodeSimulator',
	#instVars : [
		'startEvents'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'adding' }
OPBPMNSubProcessSimulator >> addBpmnTokens: anInteger from: aFlow [

	startEvents do: [ :each | each addBpmnTokens: anInteger from: aFlow ]
]

{ #category : 'initialization' }
OPBPMNSubProcessSimulator >> initialize [

	super initialize.
	startEvents := OrderedCollection new
]

{ #category : 'creation' }
OPBPMNSubProcessSimulator >> loadConnectedItems [
	"loads and/or connects appropriate tokens and elements"

	super loadConnectedItems.
	model allElements ifEmpty: [ ^ self ].

	model allElements do: [ :each |
			(each isKindOf: OPBPMNStartEventModel) ifTrue: [ startEvents add: (diagramSimulator simulatorOf: each) ].
			(each isKindOf: OPBPMNEndEventModel) ifTrue: [
					(diagramSimulator simulatorOf: each)
						when: OPSimulatorWillDoAction
						do: [ :event | self bpmnTokens: event simulator bpmnTokens ]
						for: self ] ]
]

{ #category : 'accessing' }
OPBPMNSubProcessSimulator >> startEvents [

	^ startEvents
]
