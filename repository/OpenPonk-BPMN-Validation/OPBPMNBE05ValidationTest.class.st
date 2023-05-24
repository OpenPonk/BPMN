Class {
	#name : #OPBPMNBE05ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNBE05ValidationTest >> getTestedClass [
	^ BE05ErrorNonInterrupting.
]

{ #category : #constants }
OPBPMNBE05ValidationTest >> getValidatedClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : #constants }
OPBPMNBE05ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNBE05ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNBE05ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
