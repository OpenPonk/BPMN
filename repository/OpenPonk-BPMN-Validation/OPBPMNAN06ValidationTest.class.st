"
I am a unit test class verifying the AN06OnlyConditionalFlow validation rule. I ensure it correctly warns when nodes have only conditional outgoing flows without a default flow fallback.
"
Class {
	#name : 'OPBPMNAN06ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAN06ValidationTest >> getTestedClass [
	^ AN06OnlyConditionalFlow.
]

{ #category : 'constants' }
OPBPMNAN06ValidationTest >> getValidatedClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'constants' }
OPBPMNAN06ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAN06ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAN06ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
