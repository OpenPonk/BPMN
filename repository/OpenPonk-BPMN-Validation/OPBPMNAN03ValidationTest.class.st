"
I am a unit test class verifying the AN03MaxOneDefaultFlow validation rule. I ensure it correctly flags activities or gateways defining more than one default outgoing sequence flow.
"
Class {
	#name : 'OPBPMNAN03ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAN03ValidationTest >> getTestedClass [
	^ AN03MaxOneDefaultFlow.
]

{ #category : 'constants' }
OPBPMNAN03ValidationTest >> getValidatedClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'constants' }
OPBPMNAN03ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAN03ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAN03ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
