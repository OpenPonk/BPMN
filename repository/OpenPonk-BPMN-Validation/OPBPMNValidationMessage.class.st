Class {
	#name : #OPBPMNValidationMessage,
	#superclass : #Object,
	#instVars : [
		'messageText',
		'objectReference',
		'validation'
	],
	#category : #'OpenPonk-BPMN-Validation-Messages'
}

{ #category : #'as yet unclassified' }
OPBPMNValidationMessage class >> createFor: aObject withValidation: aVerification withText: aText [
	| message |
	message := self basicNew.
	message objectReference: aObject;
	validation: aVerification;
	messageText: aText.
	^ message.
]

{ #category : #'as yet unclassified' }
OPBPMNValidationMessage class >> new [
	^ self shouldNotImplement.
]

{ #category : #accessing }
OPBPMNValidationMessage >> getObjectReferenceName [
	^ self objectReference name.
]

{ #category : #accessing }
OPBPMNValidationMessage >> messageText [
	^ messageText.
]

{ #category : #accessing }
OPBPMNValidationMessage >> messageText: aText [
	^ messageText := aText.
]

{ #category : #accessing }
OPBPMNValidationMessage >> objectReference [
	^ objectReference.
]

{ #category : #accessing }
OPBPMNValidationMessage >> objectReference: aObject [
	^ objectReference := aObject.
]

{ #category : #accessing }
OPBPMNValidationMessage >> severity [
	self subclassResponsibility
]

{ #category : #accessing }
OPBPMNValidationMessage >> validation [
	^ validation.
]

{ #category : #accessing }
OPBPMNValidationMessage >> validation: aVerificationReference [
	^ validation := aVerificationReference.
]
