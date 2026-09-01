"
I am a validation rule verifying the structural correctness of outgoing messages on throwing Intermediate Events other than explicit Message Events.
"
Class {
	#name : 'IE04MessageSendOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
IE04MessageSendOther class >> validateClass [
	^ OPBPMNIntermediateEventModel.
]

{ #category : 'verification' }
IE04MessageSendOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifTrue: [ 
		counter := 0.
		aVerifiedObject outgoing do: [ :each | (
			(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ counter := 1 ]) ] ].
		counter = 1 ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType Send
			| (aVerifiedObject type = OPBPMNNodeType Multiple) ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(IE04) ', aVerifiedObject class name
						   ,
						   ' can have outgoing Message Flow only as Message or Multiple type.') } ] ].
	^ {  }
]
