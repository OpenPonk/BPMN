Class {
	#name : 'OPBPMNNodeSimulator',
	#superclass : 'OPElementSimulator',
	#instVars : [
		'bpmnTokens',
		'blocked'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'adding' }
OPBPMNNodeSimulator >> addBpmnTokens: anInteger from: aFlow [

	self bpmnTokens: self bpmnTokens + anInteger
]

{ #category : 'accessing' }
OPBPMNNodeSimulator >> blocked [

	^ blocked
]

{ #category : 'accessing' }
OPBPMNNodeSimulator >> blocked: aBoolean [

	blocked := aBoolean
]

{ #category : 'accessing' }
OPBPMNNodeSimulator >> bpmnTokens [

	^ bpmnTokens
]

{ #category : 'accessing' }
OPBPMNNodeSimulator >> bpmnTokens: anInteger [

	bpmnTokens := anInteger 
]

{ #category : 'testing' }
OPBPMNNodeSimulator >> canSendBpmnTokens [

	^ outgoing notEmpty and: blocked not
]

{ #category : 'actions' }
OPBPMNNodeSimulator >> fire [

	self canSendBpmnTokens ifFalse: [ ^ self ].
	self outgoingDo: [ :flow | flow addBpmnTokens: self bpmnTokens ].
	self bpmnTokens: 0
]

{ #category : 'initialization' }
OPBPMNNodeSimulator >> initialize [

	super initialize.
	bpmnTokens := 0.
	blocked := false
]

{ #category : 'testing' }
OPBPMNNodeSimulator >> isConfigurable [

	^ false
]

{ #category : 'testing' }
OPBPMNNodeSimulator >> isGateway [

	^ false
]

{ #category : 'testing' }
OPBPMNNodeSimulator >> isSimulable [
	"could there be any possibility to step? - rigid: should return always true or always false"
	
	^ true
]

{ #category : 'testing' }
OPBPMNNodeSimulator >> isSteppable [
	"can I step right now?"

	^ self bpmnTokens > 0 and: self blocked not
]

{ #category : 'initialization' }
OPBPMNNodeSimulator >> setDefaultStepping [
	"sets default stepping settings"

	super setDefaultStepping.
	self
		resetActions;
		addAction: [ :item | item fire ]
]
