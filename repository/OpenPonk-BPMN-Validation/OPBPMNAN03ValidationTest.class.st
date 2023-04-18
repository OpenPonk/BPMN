Class {
	#name : #OPBPMNAN03ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNAN03ValidationTest >> getTestedClass [
	^ AN03MaxOneDefaultFlow.
]

{ #category : #constants }
OPBPMNAN03ValidationTest >> getValidatedClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : #constants }
OPBPMNAN03ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNAN03ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNAN03ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
