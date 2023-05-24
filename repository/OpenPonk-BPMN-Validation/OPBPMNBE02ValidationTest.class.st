Class {
	#name : #OPBPMNBE02ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNBE02ValidationTest >> getTestedClass [
	^ BE02OneSequenceFlow.
]

{ #category : #constants }
OPBPMNBE02ValidationTest >> getValidatedClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : #constants }
OPBPMNBE02ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNBE02ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNBE02ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
