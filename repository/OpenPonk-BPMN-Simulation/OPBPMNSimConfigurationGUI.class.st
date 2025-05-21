Class {
	#name : 'OPBPMNSimConfigurationGUI',
	#superclass : 'SpPresenter',
	#instVars : [
		'diagramSimulator',
		'gatewayPresenters'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> connectPresenters [

	gatewayPresenters keysAndValuesDo: [ :element :row |
		row doWithIndex: [ :presenter :index |
			index = 1 ifFalse: [
				presenter whenActivatedDo: [
					element outgoingActive add: (element outgoing at: index - 1) ].
				presenter whenDeactivatedDo: [
					element outgoingActive remove: (element outgoing at: index - 1) ] ] ] ]
]

{ #category : 'layout' }
OPBPMNSimConfigurationGUI >> defaultLayout [

	^ SpGridLayout build: [ :builder |
		  gatewayPresenters do: [ :row |
			  row do: [ :presenter | builder add: presenter ].
			  builder nextRow ] ]
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> diagramSimulator [

	^ diagramSimulator
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> diagramSimulator: aDiagramSimulator [

	diagramSimulator := aDiagramSimulator.
	super initialize
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> initialize [

	gatewayPresenters := Dictionary new
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> initializePresenters [

	| row |
	super initializePresenters.

	diagramSimulator configurableGateways do: [ :element |
		row := OrderedCollection new.
		({
			 OPBPMNNodeType Exclusive.
			 OPBPMNNodeType Eventbased } includes: element model type) ifTrue: [
			element outgoingDo: [ :flow |
				row add: (self newRadioButton
						 label: flow model name;
						 yourself) ].
			row notEmpty ifTrue: [
				row anyOne associatedRadioButtons: row.
				(row at: (element outgoing indexOf: element outgoingActive first))
					state: true ] ].
		({
			 OPBPMNNodeType Inclusive.
			 OPBPMNNodeType Complex } includes: element model type) ifTrue: [
			element outgoingDo: [ :flow |
				row add: (self newCheckBox
						 label: flow model name;
						 state: (element outgoingActive includes: flow);
						 yourself) ] ].

		row addFirst: (self newLabel label: element model name).
		gatewayPresenters at: element put: row ]
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Simulator Configuration';
		initialExtent: 400 @ 50 * (gatewayPresenters size + 1)
]
