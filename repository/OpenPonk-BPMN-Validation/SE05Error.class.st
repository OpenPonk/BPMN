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
	| eventSubProcessOnlyTypes alwaysInterruptingStartTypes |
	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifFalse: [ ^ {  } ].
	alwaysInterruptingStartTypes := {
		OPBPMNNodeType Error .
		OPBPMNNodeType Compensation .
		OPBPMNNodeType None }.
	(aVerifiedObject isNonInterrupting and: [
		alwaysInterruptingStartTypes includes: aVerifiedObject type ]) ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(SE05) ' , aVerifiedObject class name
				, ' of type ' , aVerifiedObject type asString
				, ' cannot be Non-Interrupting.') } ].
	(aVerifiedObject owner isKindOf: OPBPMNSubProcessModel) ifTrue: [ ^ {  } ].
	eventSubProcessOnlyTypes := {
		OPBPMNNodeType Error .
		OPBPMNNodeType Escalation .
		OPBPMNNodeType Compensation }.
	((eventSubProcessOnlyTypes includes: aVerifiedObject type)
		or: [ aVerifiedObject isNonInterrupting ]) ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(SE05) ' , aVerifiedObject class name
				, ' of Error/Escalation/Compensation or Non-Interrupting type can be used only in Sub-Process.') } ].
	^ {  }
]
