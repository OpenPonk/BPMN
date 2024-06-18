Class {
	#name : 'OPBPMNAC02ValidationTest',
	#superclass : 'OPBPMNAbstractValidationTest',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAC02ValidationTest >> getTestedClass [
	^ AC02MessageSend.
]

{ #category : 'constants' }
OPBPMNAC02ValidationTest >> getValidatedClass [
	^ OPBPMNActivityModel.
]

{ #category : 'constants' }
OPBPMNAC02ValidationTest >> testCanValidate [
	self canValidateTest.
]

{ #category : 'constants' }
OPBPMNAC02ValidationTest >> testNew [
	self newTest.
]

{ #category : 'constants' }
OPBPMNAC02ValidationTest >> testValidatedClass [
	self validatedClassTest.
]
