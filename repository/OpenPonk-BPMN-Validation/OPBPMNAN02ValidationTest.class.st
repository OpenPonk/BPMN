"
I am a unit test class verifying the AN02FlowNodeOutgoingFlow validation rule. I ensure it correctly detects standard flow nodes missing at least one outgoing sequence flow.
"
Class {
	#name : 'OPBPMNAN02ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAN02ValidationTest >> getTestedClass [
	^ AN02FlowNodeOutgoingFlow.
]

{ #category : 'constants' }
OPBPMNAN02ValidationTest >> getValidatedClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'constants' }
OPBPMNAN02ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAN02ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAN02ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
