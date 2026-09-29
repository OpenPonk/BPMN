"
I am a unit test class verifying the EE03MessageSend validation rule. I ensure it correctly identifies missing or invalid outgoing message flows on Message End Events.
"
Class {
	#name : 'OPBPMNEE03ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNEE03ValidationTest >> getTestedClass [
	^ EE03MessageSend.
]

{ #category : 'constants' }
OPBPMNEE03ValidationTest >> getValidatedClass [
	^ OPBPMNEndEventModel.
]

{ #category : 'constants' }
OPBPMNEE03ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNEE03ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNEE03ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
