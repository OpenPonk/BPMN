"
I am a unit test class verifying the AC04MessageSendOther validation rule. I ensure it correctly identifies invalid outgoing messages on activities other than explicit Send Tasks.
"
Class {
	#name : 'OPBPMNAC04ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAC04ValidationTest >> getTestedClass [
	^ AC04MessageSendOther 
]

{ #category : 'constants' }
OPBPMNAC04ValidationTest >> getValidatedClass [
	^ OPBPMNActivityModel.
]

{ #category : 'constants' }
OPBPMNAC04ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAC04ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAC04ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
