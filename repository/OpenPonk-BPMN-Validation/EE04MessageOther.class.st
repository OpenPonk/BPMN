"
I am a validation rule verifying the structural correctness of outgoing messages on End Events other than explicit Message End Events.
"
Class {
	#name : 'EE04MessageOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
EE04MessageOther class >> validateClass [
	^ OPBPMNEndEventModel.
]

{ #category : 'verification' }
EE04MessageOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNEndEventModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject outgoing anySatisfy: [ :each | each isKindOf: OPBPMNMessageFlowModel ])
		ifTrue: [
			(aVerifiedObject type = OPBPMNNodeType Send
				or: [ aVerifiedObject type = OPBPMNNodeType MultipleThrow ]) ifFalse: [
				^ { (OPBPMNValidationMessageError
					createFor: aVerifiedObject
					withValidation: self
					withText: '(EE04) ' , aVerifiedObject class name
						, ' can have outgoing Message Flow only as Message or Multiple type.') } ] ].
	^ {  }
]
