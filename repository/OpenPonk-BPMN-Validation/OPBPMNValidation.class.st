"
I am the abstract base class for specific BPMN validation rules. I define the interface for validating diagram objects against the BPMN specification.
"
Class {
	#name : 'OPBPMNValidation',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Validation-Settings',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Settings'
}

{ #category : 'testing' }
OPBPMNValidation class >> canValidate: aVerifiedObject [
	"^ aVerifiedObject class = self validateClass."
	^ aVerifiedObject isKindOf: self validateClass.
]

{ #category : 'instance creation' }
OPBPMNValidation class >> new [
	^ self shouldNotImplement.
]

{ #category : 'as yet unclassified' }
OPBPMNValidation class >> validate: aVerifiedObject withModel: aVerifiedModel [
	| verification |
	(self canValidate: aVerifiedObject) ifFalse: [ ^ {} ].
	verification := self basicNew.
	^ verification validateObject: aVerifiedObject withModel: aVerifiedModel.
]

{ #category : 'accessing' }
OPBPMNValidation class >> validateClass [
	^ nil.
]

{ #category : 'verification' }
OPBPMNValidation >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	self subclassResponsibility.
]
