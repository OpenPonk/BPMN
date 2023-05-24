Class {
	#name : #GW06NoConditionalOutgoingFlows,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
GW06NoConditionalOutgoingFlows class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : #verification }
GW06NoConditionalOutgoingFlows >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Parallel
		| (aVerifiedObject type = OPBPMNNodeType Eventbased) ifFalse: [ 
			counter := 0.
			aVerifiedObject outgoing do: [ :each | 
				(each isKindOf: OPBPMNFlowModel) ifTrue: [ 
					each type = 'Conditional' ifTrue: [ counter := 1 ] ] ] ].
		counter = 1 ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(GW06) ' , aVerifiedObject class name
					   , ' should not have conditional outgoing flows') } ] ].
	^ {  }
]
