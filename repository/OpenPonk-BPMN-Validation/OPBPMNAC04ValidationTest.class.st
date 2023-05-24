Class {
	#name : #OPBPMNAC04ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNAC04ValidationTest >> getTestedClass [
	^ AC04MessageSendOther 
]

{ #category : #constants }
OPBPMNAC04ValidationTest >> getValidatedClass [
	^ OPBPMNActivityModel.
]

{ #category : #constants }
OPBPMNAC04ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNAC04ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNAC04ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
