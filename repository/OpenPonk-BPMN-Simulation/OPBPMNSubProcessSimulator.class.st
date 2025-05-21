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

	| simulator |
	super loadConnectedItems.
	model elements ifEmpty: [ ^ self ].

	model elements do: [ :each |
		simulator := diagramSimulator simulatorOf: each.

		(each isKindOf: OPBPMNStartEventModel) ifTrue: [
			startEvents add: simulator ].
		(each isKindOf: OPBPMNEndEventModel) ifTrue: [
			simulator
				when: OPSimulatorWillDoAction 
				do: [ :event | self bpmnTokens: event simulator bpmnTokens ]
				for: self ] ]
]

{ #category : 'accessing' }
OPBPMNSubProcessSimulator >> startEvents [

	^ startEvents
]

{ #category : 'accessing' }
OPBPMNSubProcessSimulator >> startEvents: anOrderedCollection [

	startEvents := anOrderedCollection
]
