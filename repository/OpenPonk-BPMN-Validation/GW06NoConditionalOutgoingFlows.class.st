"
I am a validation rule verifying that specific gateways (like Parallel or Event-Based Gateways) do not have conditional outgoing sequence flows.
"
Class {
	#name : 'GW06NoConditionalOutgoingFlows',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
GW06NoConditionalOutgoingFlows class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : 'verification' }
GW06NoConditionalOutgoingFlows >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasConditionalFlow |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject type = OPBPMNNodeType Parallel
		or: [ aVerifiedObject type = OPBPMNNodeType Eventbased ]) ifTrue: [ ^ {  } ].
	hasConditionalFlow := aVerifiedObject outgoing anySatisfy: [ :each |
		(each isKindOf: OPBPMNFlowModel) and: [ each type = 'Conditional' ] ].
	hasConditionalFlow ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(GW06) ' , aVerifiedObject class name
				, ' should not have conditional outgoing flows') } ].
	^ {  }
]
