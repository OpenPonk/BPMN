Class {
	#name : 'OPBPMNAN05ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAN05ValidationTest >> getTestedClass [
	^ AN05LabelValidation.
]

{ #category : 'constants' }
OPBPMNAN05ValidationTest >> getValidatedClass [
	^ OPBPMNNodeModel.
]

{ #category : 'constants' }
OPBPMNAN05ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAN05ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAN05ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
