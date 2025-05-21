Class {
	#name : 'OPBPMNFlowSimulator',
	#superclass : 'OPEdgeSimulator',
	#instVars : [
		'bpmnTokens'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'adding' }
OPBPMNFlowSimulator >> addBpmnTokens: anInteger [

	self bpmnTokens: self bpmnTokens + anInteger
]

{ #category : 'accessing' }
OPBPMNFlowSimulator >> bpmnTokens [

	^ bpmnTokens
]

{ #category : 'accessing' }
OPBPMNFlowSimulator >> bpmnTokens: anInteger [

	bpmnTokens := anInteger
]

{ #category : 'actions' }
OPBPMNFlowSimulator >> fire [

^ self subclassResponsibility 
]

{ #category : 'initialization' }
OPBPMNFlowSimulator >> initialize [

	super initialize.
	bpmnTokens := 0.
	priority := -1
]

{ #category : 'testing' }
OPBPMNFlowSimulator >> isConfigurable [

	^ false
]

{ #category : 'testing' }
OPBPMNFlowSimulator >> isGateway [

	^ false
]

{ #category : 'testing' }
OPBPMNFlowSimulator >> isSimulable [
	"could there be any possibility to step? - rigid: should return always true or always false"

	^ true
]

{ #category : 'initialization' }
OPBPMNFlowSimulator >> setDefaultStepping [
	"sets default stepping settings"

	super setDefaultStepping.
	self
		resetActions;
		addAction: [ :item | item fire ]
]
