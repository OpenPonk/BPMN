"
I am a validation rule ensuring that essential BPMN elements possess descriptive text labels for process clarity.
"
Class {
	#name : 'AN05LabelValidation',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN05LabelValidation class >> validateClass [
	^ OPBPMNSemanticNodeModel.
]

{ #category : 'verification' }
AN05LabelValidation >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| size |
	(aVerifiedObject isKindOf: OPBPMNSemanticNodeModel) ifTrue: [ 
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
