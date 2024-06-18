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
