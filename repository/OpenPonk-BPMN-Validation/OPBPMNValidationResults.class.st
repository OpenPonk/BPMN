Class {
	#name : #OPBPMNValidationResults,
	#superclass : #Object,
	#instVars : [
		'results'
	],
	#category : #'OpenPonk-BPMN-Validation-Results'
}

{ #category : #accessing }
OPBPMNValidationResults >> addResult: aVerificationMessage [

	aVerificationMessage ifNotNil: [ results add: aVerificationMessage ]
]

{ #category : #accessing }
OPBPMNValidationResults >> addResults: aVerificationMessageCollection [

	(aVerificationMessageCollection isKindOf: OPBPMNValidationResults)
		ifTrue: [ results addAll: aVerificationMessageCollection results ]
		ifFalse: [ 
			aVerificationMessageCollection isCollection
				ifTrue: [ results addAll: aVerificationMessageCollection ]
				ifFalse: [ results add: aVerificationMessageCollection ] ]
]

{ #category : #accessing }
OPBPMNValidationResults >> hasErrors: aVerifiedObject [
	^ self selectErrors anySatisfy: [ :verificationMessage | verificationMessage objectReference = aVerifiedObject ].
	
]

{ #category : #accessing }
OPBPMNValidationResults >> hasWarnings: aVerifiedObject [
	^ self selectWarnings anySatisfy: [ :verificationMessage | verificationMessage objectReference = aVerifiedObject ].
]

{ #category : #accessing }
OPBPMNValidationResults >> initialize [
	super initialize.
	results := Set new.
]

{ #category : #accessing }
OPBPMNValidationResults >> results [
	^ results.
]

{ #category : #accessing }
OPBPMNValidationResults >> selectErrors [
	^ results select: [ :verificationMessage | verificationMessage class = OPBPMNValidationMessageError ].
]

{ #category : #accessing }
OPBPMNValidationResults >> selectWarnings [
	^ results select: [ :verificationMessage | verificationMessage class = OPBPMNValidationMessageWarning ].
]
