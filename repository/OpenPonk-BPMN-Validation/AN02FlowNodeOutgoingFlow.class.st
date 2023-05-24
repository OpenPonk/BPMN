Class {
	#name : #AN02FlowNodeOutgoingFlow,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
AN02FlowNodeOutgoingFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : #verification }
AN02FlowNodeOutgoingFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifTrue: [ 
		(aVerifiedObject isKindOf: OPBPMNEndEventModel) ifFalse: [ 
		counter := 0.
		aVerifiedObject outgoing do: [ :each | (
			(each isKindOf: OPBPMNFlowModel) ifTrue: [ counter := 1 ]) ] ].
		(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType LinkThrow ifTrue: [ 
				counter := 1 ] ].
		counter = 0 ifTrue: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(AN02) ', aVerifiedObject class name
						   ,
						   ' must have outgoing Sequence Flow.') } ] ].
	^ {  }
]
