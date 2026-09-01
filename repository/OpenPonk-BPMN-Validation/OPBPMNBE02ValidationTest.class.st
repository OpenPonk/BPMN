"
I am a unit test class verifying the BE02OneSequenceFlow validation rule. I ensure it correctly enforces that a boundary event has exactly one outgoing sequence flow.
"
Class {
	#name : 'OPBPMNBE02ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNBE02ValidationTest >> getTestedClass [
	^ BE02OneSequenceFlow.
]

{ #category : 'constants' }
OPBPMNBE02ValidationTest >> getValidatedClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'constants' }
OPBPMNBE02ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNBE02ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNBE02ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
