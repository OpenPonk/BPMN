Class {
	#name : 'GW07LabeledOutgoingFlows',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
GW07LabeledOutgoingFlows class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : 'verification' }
GW07LabeledOutgoingFlows >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) & (aVerifiedObject outgoing size > 1) ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Parallel
		| (aVerifiedObject type = OPBPMNNodeType Eventbased) ifFalse: [ 
			counter := 0.
			aVerifiedObject outgoing do: [ :each | 
				(each isKindOf: OPBPMNFlowModel) ifTrue: [ 
					each name isNotNil & (each type ~= 'Default') ifTrue: [ 
						counter := 1 ] ] ] ].
		counter = 1 ifTrue: [ 
			^ { (OPBPMNValidationMessageWarning
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(GW07) ' , aVerifiedObject class name
					   ,
					   ' should have labeled outgoing flows (except Default Flow). Label should answer the Gateway condition.') } ] ].
	^ {  }
]
