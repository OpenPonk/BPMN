"
Spec presenter for configuring the BPMN simulation parameters. Manages the setup of configurable elements like gateway branch routing conditions prior to execution.
"
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
							| flow |
							flow := element outgoing at: index - 1.
							presenter whenActivatedDo: [ (element outgoingActive includes: flow) ifFalse: [ element outgoingActive add: flow ] ].
							presenter whenDeactivatedDo: [ element outgoingActive remove: flow ifAbsent: [ ] ] ] ] ]
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
	self
		initializePresenters;
		connectPresenters
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> initializePresenters [

	| row |
	gatewayPresenters := Dictionary new.
	diagramSimulator ifNil: [ ^ self ].
	diagramSimulator configurableGateways do: [ :element |
			row := OrderedCollection new.
			({
				 OPBPMNNodeType ExclusiveEmpty.
				 OPBPMNNodeType Exclusive.
				 OPBPMNNodeType Eventbased } includes: element model type) ifTrue: [
					element outgoingDo: [ :flow |
							row add: (self newRadioButton
									 label: flow model name;
									 yourself) ].
					(row isNotEmpty and: [ element outgoingActive isNotEmpty ]) ifTrue: [
							| activeIndex |
							row anyOne associatedRadioButtons: row.
							activeIndex := element outgoing indexOf: element outgoingActive first ifAbsent: [ 0 ].
							activeIndex > 0 ifTrue: [ (row at: activeIndex) state: true ] ] ].
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
		initialExtent: 400 @ (50 * (gatewayPresenters size + 1))
]

{ #category : 'accessing - model' }
OPBPMNSimConfigurationGUI >> setModelBeforeInitialization: aDiagramSimulator [

	diagramSimulator := aDiagramSimulator
]
