"
I am a validation rule warning against nodes that have only conditional outgoing flows without a default flow, which risks deadlocking the process if no conditions are met.
"
Class {
	#name : 'AN06OnlyConditionalFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN06OnlyConditionalFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'verification' }
AN06OnlyConditionalFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| outgoingSequenceFlows |
	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifFalse: [ ^ {  } ].
	outgoingSequenceFlows := aVerifiedObject outgoing select: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	(outgoingSequenceFlows isNotEmpty and: [
		outgoingSequenceFlows allSatisfy: [ :eachFlow | eachFlow type = 'Conditional' ] ]) ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(AN06) ' , aVerifiedObject class name
				, ' could not have outgoing only Conditional Flow.') } ].
	^ {  }
]
