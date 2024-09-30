Class {
	#name : 'OPBPMNAN01ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAN01ValidationTest >> getTestedClass [
	^ AN01FlowNodeIncomingFlow.
]

{ #category : 'constants' }
OPBPMNAN01ValidationTest >> getValidatedClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'constants' }
OPBPMNAN01ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAN01ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAN01ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
