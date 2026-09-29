"
I am a validation rule ensuring that error boundary events are always marked as interrupting, as BPMN specification prohibits non-interrupting error events.
"
Class {
	#name : 'BE05ErrorNonInterrupting',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
BE05ErrorNonInterrupting class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'verification' }
BE05ErrorNonInterrupting >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifFalse: [
		^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Error ifFalse: [ ^ {  } ].
	aVerifiedObject isNonInterrupting ifFalse: [ ^ {  } ].

	^ { (OPBPMNValidationMessageError
		   createFor: aVerifiedObject
		   withValidation: self
		   withText: '(BE05) ' , aVerifiedObject class name
			   , ' of type Error could not be Non-Interrupting.') }
]
