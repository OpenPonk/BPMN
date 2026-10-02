"
I am a unit test class verifying the base behavior of the OPBPMNValidation framework, specifically testing the interface and abstract mechanisms for model object validation.
"
Class {
	#name : 'OPBPMNValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
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

	self deny:
		(self getTestedClass canValidate: self getNotValidatedClassInstance)
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

	self
		assert: modelErrors isEmpty
		description: [ 'Expected no errors for ' , exampleModel name , ' but got: ' , (modelErrors collect: #messageText) asArray asString ].
	self
		assert: modelWarnings isEmpty
		description: [ 'Expected no warnings for ' , exampleModel name , ' but got: ' , (modelWarnings collect: #messageText) asArray asString ]
]

{ #category : 'constants' }
OPBPMNValidationTest >> testValidateObjectWithModel [
	self
		assertCollection:
			(self getTestedClass
				validate: self getValidatedClassInstance
				withModel: 'dummyModel')
		hasSameElements: {}
]

{ #category : 'constants' }
OPBPMNValidationTest >> testValidatedClass [
	self assert: self getTestedClass validateClass equals: self getValidatedClass.
]
