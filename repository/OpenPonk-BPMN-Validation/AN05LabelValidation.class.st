Class {
	#name : 'AN05LabelValidation',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
AN05LabelValidation class >> validateClass [
	^ OPBPMNNodeModel.
]

{ #category : 'verification' }
AN05LabelValidation >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| size |
	(aVerifiedObject isKindOf: OPBPMNNodeModel) ifTrue: [ 
		size := aVerifiedObject name size.
		(aVerifiedObject isKindOf: OPBPMNStartEventModel)
		| (aVerifiedObject isKindOf: OPBPMNGatewayModel) ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType None
			| (aVerifiedObject type = OPBPMNNodeType Parallel) ifTrue: [ 
				size := 1 ] ].

		size = 0 ifTrue: [ 
			^ { (OPBPMNValidationMessageWarning
				   createFor: aVerifiedObject
				   withValidation: self
				   withText:
				   '(AN05) ' , aVerifiedObject class name , ' should be labeled.') } ] ].
	^ {  }
]
