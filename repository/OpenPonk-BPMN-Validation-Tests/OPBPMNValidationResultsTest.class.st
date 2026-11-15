"
I am a unit test class verifying the aggregation and filtering logic of OPBPMNValidationResults. I test the separation and retrieval of validation errors and warnings.
"
Class {
	#name : 'OPBPMNValidationResultsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Validation-Tests-Results',
	#package : 'OpenPonk-BPMN-Validation-Tests',
	#tag : 'Results'
}

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testAddResult [

	| validationResults dummyMessage |
	dummyMessage := 'dummyMessage'.
	validationResults := OPBPMNValidationResults new.
	self assertEmpty: validationResults results.
	validationResults addResult: dummyMessage.
	self assertCollection: validationResults results hasSameElements: { dummyMessage }
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testAddResults [

	| validationResults dummyMessages |
	dummyMessages := { 'dummyMessage'. 'dummyMessage2' }.
	validationResults := OPBPMNValidationResults new.
	self assertEmpty: validationResults results.
	validationResults addResults: dummyMessages.
	self assert: validationResults results size equals: 2.
	self assertCollection: validationResults results hasSameElements: dummyMessages
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testHasErrors [

	| validationResults dummyMessage dummyObject dummyVerification |
	dummyObject := Object new.
	dummyVerification := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageError createFor: dummyObject withValidation: dummyVerification withText: 'some text'.
	validationResults := OPBPMNValidationResults new.
	self deny: (validationResults hasErrors: dummyObject) description: 'Empty validation results must not report errors'.
	validationResults addResult: dummyMessage.
	self
		assert: (validationResults hasErrors: dummyObject)
		description: 'Validation results with added error must report hasErrors: for target object'
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testHasWarnings [

	| validationResults dummyMessage dummyObject dummyVerification |
	dummyObject := Object new.
	dummyVerification := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageWarning createFor: dummyObject withValidation: dummyVerification withText: 'some text'.
	validationResults := OPBPMNValidationResults new.
	self deny: (validationResults hasWarnings: dummyObject) description: 'Empty validation results must not report warnings'.
	validationResults addResult: dummyMessage.
	self
		assert: (validationResults hasWarnings: dummyObject)
		description: 'Validation results with added warning must report hasWarnings: for target object'
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testInitialize [
	self assert: OPBPMNValidationResults new results equals: Set new.
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testResults [

	| validationResults dummyMessage |
	dummyMessage := 'dummyMessage'.
	validationResults := OPBPMNValidationResults new.
	self assertEmpty: validationResults results.
	validationResults addResult: dummyMessage.
	self assert: validationResults results size equals: 1.
	self assertCollection: validationResults results hasSameElements: { dummyMessage }
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testSelectErrors [

	| validationResults dummyMessage dummyObject dummyValidation |
	dummyObject := Object new.
	dummyValidation := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageError createFor: dummyObject withValidation: dummyValidation withText: 'some text'.
	validationResults := OPBPMNValidationResults new.
	self assertEmpty: validationResults selectErrors.
	validationResults addResult: dummyMessage.
	self assert: validationResults selectErrors size equals: 1.
	self assertCollection: validationResults selectErrors hasSameElements: { dummyMessage }
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testSelectWarnings [

	| validationResults dummyMessage dummyObject dummyValidation |
	dummyObject := Object new.
	dummyValidation := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageWarning createFor: dummyObject withValidation: dummyValidation withText: 'some text'.
	validationResults := OPBPMNValidationResults new.
	self assertEmpty: validationResults selectWarnings.
	validationResults addResult: dummyMessage.
	self assert: validationResults selectWarnings size equals: 1.
	self assertCollection: validationResults selectWarnings hasSameElements: { dummyMessage }
]
