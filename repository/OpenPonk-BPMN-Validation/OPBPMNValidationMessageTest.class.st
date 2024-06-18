Class {
	#name : 'OPBPMNValidationMessageTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNValidationMessageTest >> testCreateForWithValidatinoWithText [
	| validationMessage testObject testValidation testMessageText |
	testObject := Object new.
	testValidation := OPBPMNValidation basicNew.
	testMessageText := 'dummyMessageText'. 
	validationMessage := OPBPMNValidationMessage createFor: testObject withValidation: testValidation  withText: testMessageText.
	self assert: validationMessage objectReference equals: testObject;
	assert: validationMessage validation equals: testValidation;	
	assert: validationMessage messageText  equals: testMessageText.
]

{ #category : 'tests' }
OPBPMNValidationMessageTest >> testMessageText [
	| validationMessage testObject testValidation testMessageText secondText |
	testObject := Object new.
	testValidation := OPBPMNValidation basicNew.
	testMessageText := 'dummyMessageText'. 
	secondText := 'changedText'.
	validationMessage := OPBPMNValidationMessage createFor: testObject withValidation: testValidation  withText: testMessageText.
	self assert: validationMessage messageText equals: testMessageText.
	validationMessage messageText: secondText.
	self assert: validationMessage messageText equals: secondText.
	
]

{ #category : 'tests' }
OPBPMNValidationMessageTest >> testNew [
	self should: [ OPBPMNValidationMessage new. ] raise: ShouldNotImplement.
]

{ #category : 'tests' }
OPBPMNValidationMessageTest >> testObjectReference [
	| validationMessage testObject testValidation testMessageText secondObject |
	testObject := Object new.
	testValidation := OPBPMNValidation basicNew.
	testMessageText := 'dummyMessageText'.
	secondObject := testValidation.
	validationMessage := OPBPMNValidationMessage createFor: testObject withValidation: testValidation  withText: testMessageText.
	self assert: validationMessage objectReference equals: testObject.
	validationMessage objectReference: secondObject.
	self assert: validationMessage objectReference equals: secondObject.
]

{ #category : 'tests' }
OPBPMNValidationMessageTest >> testValidation [
	| validationMessage testObject testValidation testMessageText secondVal |
	testObject := Object new.
	testValidation := OPBPMNValidation basicNew.
	testMessageText := 'dummyMessageText'.
	secondVal := testObject.
	validationMessage := OPBPMNValidationMessage createFor: testObject withValidation: testValidation  withText: testMessageText.	
	self assert: validationMessage validation equals: testValidation.
	validationMessage validation: secondVal.
	self assert: validationMessage validation equals: secondVal.
]

{ #category : 'tests' }
OPBPMNValidationMessageTest >> testValidationError [
	| validationMessage testObject testValidation testMessageText |
	testObject := Object new.
	testValidation := OPBPMNValidation basicNew.
	testMessageText := 'dummyMessageText'.
	validationMessage := OPBPMNValidationMessageError createFor: testObject withValidation: testValidation  withText: testMessageText.	
	self assert: validationMessage validation equals: testValidation.
	self assert: validationMessage severity = 'Error'.
]

{ #category : 'tests' }
OPBPMNValidationMessageTest >> testValidationWarning [
	| validationMessage testObject testValidation testMessageText |
	testObject := Object new.
	testValidation := OPBPMNValidation basicNew.
	testMessageText := 'dummyMessageText'.
	validationMessage := OPBPMNValidationMessageWarning createFor: testObject withValidation: testValidation  withText: testMessageText.	
	self assert: validationMessage validation equals: testValidation.
	self assert: validationMessage severity = 'Warning'.
]
