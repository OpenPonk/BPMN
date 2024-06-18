Class {
	#name : 'OPBPMNBE03ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNBE03ValidationTest >> getTestedClass [
	^ BE03BoundaryErrorSibling.
]

{ #category : 'constants' }
OPBPMNBE03ValidationTest >> getValidatedClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'constants' }
OPBPMNBE03ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNBE03ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNBE03ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
