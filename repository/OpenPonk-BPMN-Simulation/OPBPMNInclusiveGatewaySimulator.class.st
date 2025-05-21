Class {
	#name : 'OPBPMNInclusiveGatewaySimulator',
	#superclass : 'OPBPMNGatewaySimulator',
	#instVars : [
		'incomingBpmnTokens'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'adding' }
OPBPMNInclusiveGatewaySimulator >> addBpmnTokens: anInteger from: aFlow [

	| tokenAmount |
	self incomingBpmnTokens
		at: aFlow
		update: [ :value | value + anInteger ].

	(self incomingBpmnTokens values allSatisfy: [ :each | each strictlyPositive ])
		ifFalse: [
			| queue visited node |
			queue := OrderedCollection new.
			visited := Set new.
			visited add: self.
			self incomingBpmnTokens keysAndValuesDo: [ :key :val |
				val isZero ifTrue: [ queue add: key ] ].

			[ queue notEmpty ] whileTrue: [
				node := queue removeFirst.
				node bpmnTokens strictlyPositive ifTrue: [ ^ self ].
				node incomingDo: [ :each |
					(visited includes: each) ifFalse: [
						visited add: each.
						queue add: each ] ] ] ].

	tokenAmount := (self incomingBpmnTokens reject: [ :each |
		                each isZero ]) min.
	self bpmnTokens: self bpmnTokens + tokenAmount.
	(self incomingBpmnTokens reject: [ :each | each isZero ]) keysDo: [
		:key |
		self incomingBpmnTokens
			at: key
			update: [ :value | value - tokenAmount ] ]
]

{ #category : 'actions' }
OPBPMNInclusiveGatewaySimulator >> fire [

	self canSendBpmnTokens ifFalse: [ ^ self ].
	self outgoingActive do: [ :flow |
		flow addBpmnTokens: self bpmnTokens ].
	self bpmnTokens: 0
]

{ #category : 'accessing' }
OPBPMNInclusiveGatewaySimulator >> incomingBpmnTokens [

	^ incomingBpmnTokens
]

{ #category : 'accessing' }
OPBPMNInclusiveGatewaySimulator >> incomingBpmnTokens: aDictionary [

	incomingBpmnTokens := aDictionary
]

{ #category : 'initialization' }
OPBPMNInclusiveGatewaySimulator >> initialize [

	super initialize.
	incomingBpmnTokens := Dictionary new
]

{ #category : 'creation' }
OPBPMNInclusiveGatewaySimulator >> loadConnectedItems [

	super loadConnectedItems.
	model incoming do: [ :flow |
		self incomingBpmnTokens
			at: (diagramSimulator simulatorOf: flow)
			put: 0 ]
]
