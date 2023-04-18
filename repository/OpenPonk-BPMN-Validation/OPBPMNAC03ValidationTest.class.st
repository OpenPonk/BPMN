Class {
	#name : #OPBPMNAC03ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNAC03ValidationTest >> getTestedClass [
	^ AC03MessageReceiveOther 
]

{ #category : #constants }
OPBPMNAC03ValidationTest >> getValidatedClass [
	^ OPBPMNActivityModel.
]

{ #category : #constants }
OPBPMNAC03ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNAC03ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNAC03ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
