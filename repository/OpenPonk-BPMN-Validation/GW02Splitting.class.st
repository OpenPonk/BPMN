"
I am a validation rule checking whether a gateway correctly acts as a splitting (diverging) node by having multiple outgoing sequence flows.
"
Class {
	#name : 'GW02Splitting',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
GW02Splitting class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : 'verification' }
GW02Splitting >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifTrue: [ 
		aVerifiedObject incoming size < 2
		& (aVerifiedObject outgoing size < 2) ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(GW02) ' , aVerifiedObject class name
					   ,
					   ' must be merging (more incoming sequence flows) or splitting  (more outgoing sequence flows).') } ] ].
	^ {  }
]
