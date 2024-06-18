Class {
	#name : 'OPBPMNValidationResultsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testAddResult [
	| validationResults dummyMessage |
	dummyMessage := 'dummyMessage'.	
	validationResults := OPBPMNValidationResults new.
	self assert: validationResults results size equals: 0.
	validationResults addResult: dummyMessage.
	self assert: (validationResults results anySatisfy: [ :item | item = dummyMessage ])
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testAddResults [
	| validationResults dummyMessages |
	dummyMessages := {'dummyMessage'.	'dummyMessage2'. }.
	validationResults := OPBPMNValidationResults new.
	self assert: validationResults results size equals: 0.
	validationResults addResults: dummyMessages.
	self assert: validationResults results size equals: 2.
	self assert: (validationResults results anySatisfy: [ :item | item = (dummyMessages at: 1) ]).
	self assert: (validationResults results anySatisfy: [ :item | item = (dummyMessages at: 2) ]).

]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testHasErrors [
	| validationResults dummyMessage dummyObject dummyVerification |
	dummyObject := Object new.
	dummyVerification := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageError createFor: dummyObject withValidation: dummyVerification  withText: 'some text'.	
	validationResults := OPBPMNValidationResults new.
	self assert: (validationResults hasErrors: dummyObject) not.
	validationResults addResult: dummyMessage.
	self assert: (validationResults hasErrors: dummyObject).
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testHasWarnings [
	| validationResults dummyMessage dummyObject dummyVerification |
	dummyObject := Object new.
	dummyVerification := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageWarning createFor: dummyObject withValidation: dummyVerification  withText: 'some text'.	
	validationResults := OPBPMNValidationResults new.
	self assert: (validationResults hasWarnings: dummyObject) not.
	validationResults addResult: dummyMessage.
	self assert: (validationResults hasWarnings: dummyObject).
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
	self assert: validationResults results size equals: 0.
	validationResults addResult: dummyMessage.
	self assert: validationResults results size equals: 1.
	self assert: (validationResults results anySatisfy: [ :item | item = dummyMessage ])
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testSelectErrors [
	| validationResults dummyMessage dummyObject dummyValidation |
	dummyObject := Object new.
	dummyValidation := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageError createFor: dummyObject withValidation: dummyValidation  withText: 'some text'.	
	validationResults := OPBPMNValidationResults new.
	self assert: validationResults selectErrors size equals: 0.
	validationResults addResult: dummyMessage.
	self assert: validationResults selectErrors size equals: 1.	
	self assert: (validationResults selectErrors anySatisfy: [ :item | item = dummyMessage ]).
]

{ #category : 'tests' }
OPBPMNValidationResultsTest >> testSelectWarnings [
	| validationResults dummyMessage dummyObject dummyValidation |
	dummyObject := Object new.
	dummyValidation := OPBPMNValidation basicNew.
	dummyMessage := OPBPMNValidationMessageWarning createFor: dummyObject withValidation: dummyValidation  withText: 'some text'.	
	validationResults := OPBPMNValidationResults new.
	self assert: validationResults selectWarnings  size equals: 0.
	validationResults addResult: dummyMessage.
	self assert: validationResults selectWarnings size equals: 1.	
	self assert: (validationResults selectWarnings anySatisfy: [ :item | item = dummyMessage ]).
]
