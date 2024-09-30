Class {
	#name : 'OPBPMNAN04ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAN04ValidationTest >> getTestedClass [
	^ AN04LabeledMessageFlow.
]

{ #category : 'constants' }
OPBPMNAN04ValidationTest >> getValidatedClass [
	^ OPBPMNNodeModel.
]

{ #category : 'constants' }
OPBPMNAN04ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAN04ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAN04ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
