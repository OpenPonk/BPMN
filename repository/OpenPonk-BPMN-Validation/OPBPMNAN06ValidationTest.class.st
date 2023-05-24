Class {
	#name : #OPBPMNAN06ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNAN06ValidationTest >> getTestedClass [
	^ AN06OnlyConditionalFlow.
]

{ #category : #constants }
OPBPMNAN06ValidationTest >> getValidatedClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : #constants }
OPBPMNAN06ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNAN06ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNAN06ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
