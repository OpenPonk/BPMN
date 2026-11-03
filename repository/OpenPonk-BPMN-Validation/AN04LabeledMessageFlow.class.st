"
I am a validation rule that checks whether message flows are explicitly labeled to describe the exchanged information.
"
Class {
	#name : 'AN04LabeledMessageFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN04LabeledMessageFlow class >> validateClass [
	^ OPBPMNSemanticNodeModel.
]

{ #category : 'verification' }
AN04LabeledMessageFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasUnlabeledMessageFlow |
	hasUnlabeledMessageFlow := aVerifiedObject outgoing anySatisfy: [ :eachFlow |
		(eachFlow isKindOf: OPBPMNMessageFlowModel) and: [
			eachFlow name isNil or: [ eachFlow name trimBoth isEmpty ] ] ].
	hasUnlabeledMessageFlow ifTrue: [
		^ { (OPBPMNValidationMessageWarning
			createFor: aVerifiedObject
			withValidation: self
			withText: '(AN04) ' , aVerifiedObject class name
				, ' outgoing Message Flow should be labeled.') } ].
	^ {  }
]
