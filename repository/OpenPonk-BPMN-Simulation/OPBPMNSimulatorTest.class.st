Class {
	#name : 'OPBPMNSimulatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'simulator'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNSimulatorTest >> controllerClass [

	^ OPBPMNSimulator
]

{ #category : 'running' }
OPBPMNSimulatorTest >> exampleModel [

	| model activity1 flow1 flow2 start1 end1 |
	model := OPBPMNModel new name: 'BPMN Diagram'.
	start1 := OPBPMNStartEventModel new
		          name: 'S1';
		          yourself.
	end1 := OPBPMNEndEventModel new
		        name: 'E1';
		        yourself.
	activity1 := OPBPMNActivityModel new
		             name: 'A1';
		             yourself.
	model
		add: start1;
		add: end1;
		add: activity1.
	flow1 := OPBPMNFlowModel from: start1 to: activity1.
	flow2 := OPBPMNFlowModel from: activity1 to: end1.
	model
		add: flow1;
		add: flow2.
	^ model
]

{ #category : 'running' }
OPBPMNSimulatorTest >> setUp [

	simulator := self controllerClass model: self exampleModel
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testDefaultStepping [

	| items stepped didAction |
	simulator setDefaultStepping.

	items := simulator itemsForAction.
	self assert: items size equals: 2.
	items do: [ :each |
		self assert: each isSimulable.
		self assert: each isSteppable ].
	self assert: (items first isKindOf: OPBPMNStartEventSimulator).
	self assert: (items second isKindOf: OPBPMNSequenceFlowSimulator).

	stepped := OrderedCollection new.
	didAction := OrderedCollection new.
	simulator simulableElementsDo: [ :each |
		each
			when: OPSimulatorStepped
			do: [ :event | stepped add: event ]
			for: self.
		each
			when: OPSimulatorDidAction
			do: [ :event | didAction add: event ]
			for: self ].
	simulator step.
	self assert: stepped size equals: 2.
	self assert: didAction size equals: 2
]
