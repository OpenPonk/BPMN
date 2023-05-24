Class {
	#name : #OPBPMNGW02ValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNGW02ValidationTest >> getTestedClass [
	^ GW02Splitting.
]

{ #category : #constants }
OPBPMNGW02ValidationTest >> getValidatedClass [
	^ OPBPMNGatewayModel.
]

{ #category : #constants }
OPBPMNGW02ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : #constants }
OPBPMNGW02ValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNGW02ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
