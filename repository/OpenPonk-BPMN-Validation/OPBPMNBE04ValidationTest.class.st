Class {
	#name : 'OPBPMNBE04ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNBE04ValidationTest >> getTestedClass [
	^ BE04BoundaryEscalationSibling.
]

{ #category : 'constants' }
OPBPMNBE04ValidationTest >> getValidatedClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'constants' }
OPBPMNBE04ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNBE04ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNBE04ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
