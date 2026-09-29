"
I am a unit test class verifying the AC01MessageReceive validation rule. I ensure it correctly identifies structural violations regarding incoming message flows on Receive Tasks.
"
Class {
	#name : 'OPBPMNAC01ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAC01ValidationTest >> getTestedClass [
	^ AC01MessageReceive.
]

{ #category : 'constants' }
OPBPMNAC01ValidationTest >> getValidatedClass [
	^ OPBPMNActivityModel.
]

{ #category : 'constants' }
OPBPMNAC01ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAC01ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAC01ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
