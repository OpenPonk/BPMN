Class {
	#name : #OPBPMNValidationTest,
	#superclass : #OPBPMNAbstractValidationTest,
	#category : #'OpenPonk-BPMN-Validation-Tests'
}

{ #category : #constants }
OPBPMNValidationTest >> getTestedClass [
	^ OPBPMNValidation.
]

{ #category : #constants }
OPBPMNValidationTest >> getValidatedClass [
	^ nil.
]

{ #category : #constants }
OPBPMNValidationTest >> getValidatedClassInstance [
	^ nil.
]

{ #category : #constants }
OPBPMNValidationTest >> testCanValidate [
	self assert: (self getTestedClass canValidate: self getNotValidatedClassInstance) equals: false.
]

{ #category : #constants }
OPBPMNValidationTest >> testNew [
	self newTest.
]

{ #category : #constants }
OPBPMNValidationTest >> testValidateObjectWithModel [
	self
		assertCollection:
			(self getTestedClass
				validate: self getValidatedClassInstance
				withModel: 'dummyModel')
		hasSameElements: {}
]

{ #category : #constants }
OPBPMNValidationTest >> testValidatedClass [
	self assert: self getTestedClass validateClass equals: self getValidatedClass.
]
