Class {
	#name : 'OPBPMNEE04ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNEE04ValidationTest >> getTestedClass [
	^ EE04MessageOther.
]

{ #category : 'constants' }
OPBPMNEE04ValidationTest >> getValidatedClass [
	^ OPBPMNEndEventModel.
]

{ #category : 'constants' }
OPBPMNEE04ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNEE04ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNEE04ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
