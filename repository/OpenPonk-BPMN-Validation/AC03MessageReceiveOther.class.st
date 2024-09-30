Class {
	#name : 'AC03MessageReceiveOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
AC03MessageReceiveOther class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : 'verification' }
AC03MessageReceiveOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifTrue: [ 
		counter := 0.
		aVerifiedObject incoming do: [ :each | (
			(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ counter := 1 ]) ] ].
		counter = 1 ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType Receive
			| (aVerifiedObject type = OPBPMNNodeType Multiple) ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(AC03) ', aVerifiedObject class name
						   ,
						   ' can have incoming Message Flow only as Message Receive type.') } ] ].
	^ {  }
]
