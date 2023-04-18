Class {
	#name : #OPBPMNAC05ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNAC05ValidationTest >> getTestedClass [
	^ AC05ActivityMergingFlows 
]

{ #category : #constants }
OPBPMNAC05ValidationTest >> getValidatedClass [
	^ OPBPMNActivityModel.
]

{ #category : #constants }
OPBPMNAC05ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNAC05ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNAC05ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
