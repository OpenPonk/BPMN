"
I am a validation rule verifying that Error Start Events are used correctly, such as ensuring they only appear in event sub-processes and are not triggered by external message flows.
"
Class {
	#name : 'SE05Error',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
SE05Error class >> validateClass [
	^ OPBPMNStartEventModel.
]

{ #category : 'verification' }
SE05Error >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifTrue: [ 
		(aVerifiedObject type = OPBPMNNodeType Error) ifTrue: [ 
			((aVerifiedObject owner) isKindOf: OPBPMNSubProcessModel)  ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(SE05) ', aVerifiedObject class name
						   ,
						   ' of Error type can be used only in Sub-Process.') } ] ] ].
	^ {  }
]
