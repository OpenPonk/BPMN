"
I am a validation rule ensuring that Parallel Event-Based Gateways do not have conditional outgoing flows or invalid target nodes.
"
Class {
	#name : 'GW05ParallelEventGatewayOutgoingFlows',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
GW05ParallelEventGatewayOutgoingFlows class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : 'verification' }
GW05ParallelEventGatewayOutgoingFlows >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| foundWrongFlow |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject type = OPBPMNNodeType Parallel
		or: [ aVerifiedObject type = OPBPMNNodeType Eventbased ]) ifFalse: [ ^ {  } ].
	foundWrongFlow := aVerifiedObject outgoing anySatisfy: [ :eachFlow |
		(eachFlow isKindOf: OPBPMNFlowModel) and: [
			eachFlow type = 'Conditional' or: [ eachFlow type = 'Default' ] ] ].
	foundWrongFlow ifFalse: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(GW05) ' , aVerifiedObject class name
			, ' of type Parallel/Eventbased should not have conditional or default outgoing flows') }
]
