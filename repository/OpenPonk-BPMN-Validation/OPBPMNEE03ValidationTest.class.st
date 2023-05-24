Class {
	#name : #OPBPMNEE03ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNEE03ValidationTest >> getTestedClass [
	^ EE03MessageSend.
]

{ #category : #constants }
OPBPMNEE03ValidationTest >> getValidatedClass [
	^ OPBPMNEndEventModel.
]

{ #category : #constants }
OPBPMNEE03ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNEE03ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNEE03ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
