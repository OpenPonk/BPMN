Class {
	#name : 'OPBPMNAbstractValidationTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> canValidateTest [

	self deny:
		(self getTestedClass canValidate: self getNotValidatedClassInstance).
	self assert:
		(self getTestedClass canValidate: self getValidatedClassInstance)
]

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> getNotValidatedClass [
	^ Object.
]

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> getNotValidatedClassInstance [
	^ self getNotValidatedClass new.
]

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> getTestedClass [
	self subclassResponsibility.
]

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> getValidatedClass [
	self subclassResponsibility.
]

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> getValidatedClassInstance [
	^ self getValidatedClass new.
]

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> newTest [
	self should: [ self getTestedClass new. ] raise: ShouldNotImplement.
]

{ #category : 'constants' }
OPBPMNAbstractValidationTest >> validatedClassTest [
	self assert: self getTestedClass validateClass equals: self getValidatedClass.
]
