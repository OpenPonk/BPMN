Class {
	#name : #GW03ShouldSplitting,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
GW03ShouldSplitting class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : #verification }
GW03ShouldSplitting >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifTrue: [ 
		aVerifiedObject incoming size > 1
		& (aVerifiedObject outgoing size > 1) ifTrue: [ 
			^ { (OPBPMNValidationMessageWarning
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(GW03) ' , aVerifiedObject class name
					   , ' should be either merging or splitting.') } ] ].
	^ {  }
]
