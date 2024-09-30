Class {
	#name : 'BE05ErrorNonInterrupting',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
BE05ErrorNonInterrupting class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'verification' }
BE05ErrorNonInterrupting >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifTrue: [ 
		(aVerifiedObject type = OPBPMNNodeType Error) & (aVerifiedObject isNonInterrupting = True) ifTrue: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(BE05) ', aVerifiedObject class name
						   ,
						   ' of type Error could not be Non-Interrupting.') } ] ].
	^ {  }
]
