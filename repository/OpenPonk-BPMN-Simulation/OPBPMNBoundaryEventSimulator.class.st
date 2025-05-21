Class {
	#name : 'OPBPMNBoundaryEventSimulator',
	#superclass : 'OPBPMNNodeSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'initialization' }
OPBPMNBoundaryEventSimulator class >> typeMapping [

	^ Dictionary new
		  at: OPBPMNNodeType Escalation put: OPBPMNNodeType EscalationThrow;
		  at: OPBPMNNodeType CatchCompensation
		  put: OPBPMNNodeType CompensationThrow;
		  at: OPBPMNNodeType Signal put: OPBPMNNodeType SignalThrow;
		  at: OPBPMNNodeType Multiple put: OPBPMNNodeType MultipleThrow;
		  at: OPBPMNNodeType Error put: OPBPMNNodeType Error;
		  yourself
]

{ #category : 'creation' }
OPBPMNBoundaryEventSimulator >> loadConnectedItems [
	"loads and/or connects appropriate tokens and elements"

	| eventType |
	super loadConnectedItems.

	eventType := self class typeMapping at: self model type ifAbsent: nil.
	eventType ifNil: [ ^ self ].

	self model owner elements
		select: [ :each |
			((each isKindOf: OPBPMNIntermediateEventModel) or:
				 (each isKindOf: OPBPMNEndEventModel)) and: each type = eventType ]
		thenDo: [ :each |
			(diagramSimulator simulatorOf: each)
				when: OPSimulatorWillDoAction
				do: [ :event |
					self bpmnTokens: event simulator bpmnTokens.
					self model isNonInterrupting ifFalse: [
						event simulator bpmnTokens: 0 ] ]
				for: self ]
]
