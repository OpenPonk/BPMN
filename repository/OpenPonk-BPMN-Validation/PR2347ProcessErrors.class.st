Class {
	#name : 'PR2347ProcessErrors',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
PR2347ProcessErrors class >> PR02ActivityCounterError: aValidateModel [
	^ (OPBPMNValidationMessageError
				   createFor: aValidateModel
				   withValidation: self
				   withText: '(PR02) ' , aValidateModel class name
					   , ' must have at least one Activity.').
]

{ #category : 'as yet unclassified' }
PR2347ProcessErrors class >> PR03MoreProcesses: aValidateModel [
	^ (OPBPMNValidationMessageWarning
				   createFor: aValidateModel
				   withValidation: self
				   withText: '(PR03) ' , aValidateModel class name
					   , ' elements of one process should be in one Pool.').
]

{ #category : 'as yet unclassified' }
PR2347ProcessErrors class >> PR04AllInsidePool: aValidateModel [
	^ (OPBPMNValidationMessageWarning
				   createFor: aValidateModel
				   withValidation: self
				   withText: '(PR04) ' , aValidateModel class name
					   , ' if diagram contains Pool, all elements should be inside of Pool.').
]

{ #category : 'as yet unclassified' }
PR2347ProcessErrors class >> PR07StartCounterError: aValidateModel [
	^ (OPBPMNValidationMessageWarning
				   createFor: aValidateModel
				   withValidation: self
				   withText: '(PR07) ' , aValidateModel class name
					   , ' should containt at least one Start Event and at least one End Event.').
]

{ #category : 'verification' }
PR2347ProcessErrors >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	"validation in ValidationController. Error methods here on class side"
	^ {  }
]
