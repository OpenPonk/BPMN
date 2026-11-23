"
I am a unit test class verifying the base behavior of the OPBPMNValidation framework, specifically testing the interface and abstract mechanisms for model object validation.
"
Class {
	#name : 'OPBPMNValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests-Settings',
	#package : 'OpenPonk-BPMN-Validation-Tests',
	#tag : 'Settings'
}

{ #category : 'constants' }
OPBPMNValidationTest >> getTestedClass [
	^ OPBPMNValidation.
]

{ #category : 'constants' }
OPBPMNValidationTest >> getValidatedClass [
	^ nil.
]

{ #category : 'constants' }
OPBPMNValidationTest >> getValidatedClassInstance [
	^ nil.
]

{ #category : 'constants' }
OPBPMNValidationTest >> testCanValidate [

	self
		deny: (self getTestedClass canValidate: self getNotValidatedClassInstance)
		description: 'Abstract OPBPMNValidation must reject arbitrary model instances'
]

{ #category : 'tests' }
OPBPMNValidationTest >> testExampleOrderFulfillmentHasZeroValidationErrorsAndZeroWarnings [

	| exampleModel results |
	exampleModel := OPBPMNExamples exampleOrderFulfillment.
	results := OPBPMNValidationController new validate: exampleModel.
	self assertEmpty: (results selectErrors collect: #messageText as: Array) sorted.
	self assertEmpty: (results selectWarnings collect: #messageText as: Array) sorted
]

{ #category : 'tests' }
OPBPMNValidationTest >> testIsAbstract [

	self assert: OPBPMNValidation isAbstract description: 'Base OPBPMNValidation class must report itself as abstract'.
	self deny: AN01FlowNodeIncomingFlow isAbstract description: 'Concrete BPMN validation rule must not report itself as abstract'
]

{ #category : 'constants' }
OPBPMNValidationTest >> testNew [
	self newTest.
]

{ #category : 'tests' }
OPBPMNValidationTest >> testValidateModelWithLanesDoesNotReportMissingActivityOrStartEvent [

	| validationController results exampleModel modelErrors modelWarnings |
	validationController := OPBPMNValidationController new.
	exampleModel := OPBPMNExamples exampleOrderFulfillment.
	results := validationController validate: exampleModel.

	modelErrors := results selectErrors select: [ :each | each objectReference = exampleModel ].
	modelWarnings := results selectWarnings select: [ :each | each objectReference = exampleModel ].

	self assertEmpty: (modelErrors collect: #messageText as: Array).
	self assertEmpty: (modelWarnings collect: #messageText as: Array)
]

{ #category : 'constants' }
OPBPMNValidationTest >> testValidateObjectWithModel [

	self assertEmpty: (self getTestedClass validate: self getValidatedClassInstance withModel: 'dummyModel')
]

{ #category : 'constants' }
OPBPMNValidationTest >> testValidatedClass [
	self assert: self getTestedClass validateClass equals: self getValidatedClass.
]
