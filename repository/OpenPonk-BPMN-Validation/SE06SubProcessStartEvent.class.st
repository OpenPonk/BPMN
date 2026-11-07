"
Validates start event triggers inside subprocesses. Ensures that embedded subprocesses connected to sequence flows use only untyped start events, while event subprocesses define an explicit start trigger.
"
Class {
	#name : 'SE06SubProcessStartEvent',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
SE06SubProcessStartEvent class >> validateClass [
	^ OPBPMNStartEventModel
]

{ #category : 'verification' }
SE06SubProcessStartEvent >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| parentSubProcess parentHasSequenceFlow |
	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifFalse: [ ^ {  } ].
	parentSubProcess := aVerifiedObject owner.
	(parentSubProcess isKindOf: OPBPMNSubProcessModel) ifFalse: [ ^ {  } ].
	parentHasSequenceFlow := (parentSubProcess incoming , parentSubProcess outgoing) anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	(parentHasSequenceFlow and: [ aVerifiedObject type ~= OPBPMNNodeType None ]) ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(SE06) ' , aVerifiedObject class name
				, ' inside an embedded Sub-Process must be of None type.') } ].
	((self isEventSubProcess: parentSubProcess) and: [
		aVerifiedObject type = OPBPMNNodeType None ]) ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(SE06) ' , aVerifiedObject class name
				, ' inside an Event Sub-Process must have an event trigger type.') } ].
	^ {  }
]
