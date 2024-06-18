Class {
	#name : 'SE03MessageReceive',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
SE03MessageReceive class >> validateClass [
	^ OPBPMNStartEventModel.
]

{ #category : 'verification' }
SE03MessageReceive >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Receive
		& (aVerifiedObject incoming size = 0) ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(SE03) ' , aVerifiedObject class name
					   ,
					   ' of Message Receive type has to have incoming Message Flow.') } ] ].
	^ {  }
]
